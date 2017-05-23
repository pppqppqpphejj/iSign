//
//  ProvisioningProfile.swift
//  Mixup
//
//  Created by A on 2017/4/11.
//
//

import Foundation

class ProvisioningProfile: Object {
    
    init(path: String) {
        self.provisionPath = path
    }
    
    private var provisionPath = "./"
    
    private func decryptMobileprovision() -> String {
        
        let launchPath = "security"
        let args = ["cms", "-D", "-i", self.provisionPath]
        do {
            let retStr = try console.backgroundExecute(program: launchPath, arguments: args)
            if retStr.isEmpty {
                console.print("Decrypt Provision file failed")
                return ""
            }
            return retStr
        } catch {
            print("Decrypt Provision file error:\(error)")
            return ""
        }
    }
    
    var plistDict: [String : Any] {
        
        let plistStr = decryptMobileprovision()
        return PropertyListSerialization.dictFrom(plistStr: plistStr)
    }
    
    var entitlements: String {
        
        let mpPath = "./mobileprovision.plist"
        saveDecryptProvision(toPath: "./")
//        if !FileManager.default.fileExists(atPath: mpPath) {
//            saveDecryptProvision(toPath: "./")
//        }
        let launchPath = "/usr/libexec/PlistBuddy"
        let args = ["-c", "Print :Entitlements", mpPath, "-x"]
        do {
            let retStr = try console.backgroundExecute(program: launchPath, arguments: args)
            if retStr.isEmpty {
                console.print("PlistBuddy Print :Entitlements failed")
                return ""
            }
            return retStr
        } catch {
            print("PlistBuddy Print :Entitlements error:\(error)")
            return ""
        }
    }
    
    var entitlementsDict: [String : Any] {
        
        get {
            let decryptDict = plistDict //decryptMobileprovision()
            guard let entsOp = decryptDict["Entitlements"] else {
                print("Entitlements is nil")
                return [:]
            }
            guard let ents = entsOp as? [String : Any] else {
                print("Entitlements Any to Dict failed")
                return [:]
            }
            return ents
        }
    }
    
    func saveDecryptProvision(toPath: String) {
        
        let path = toPath + "/mobileprovision.plist"
        do {
            try decryptMobileprovision().write(toFile: path, atomically: false, encoding: String.Encoding.utf8)
        } catch {
            print("ProvisioningProfile saveDecryptProvision error:\(error)")
        }
    }
    
    func saveEntitlements(toPath: String) -> String {
        
        let path = toPath + "/entitlements.plist"
        do {
            try entitlements.write(toFile: path, atomically: false, encoding: String.Encoding.utf8)
            if FileManager.default.fileExists(atPath: path) {
                return path
            }
            return ""
        } catch {
            print("ProvisioningProfile saveEntitlements error:\(error)")
            return ""
        }
    }
}
