//
//  CodeSignHelper.swift
//  Mixup
//
//  Created by A on 2017/4/12.
//  Copyright © 2017年 A. All rights reserved.
//

import Foundation

class CodeSignHelper: BaseHelper {
    
    private var appPath: String = ""
    private var entitlementsPath = ""
    private var provisionFilePath = ""
    private let dirMgr = DirectoryMgr()
    
    func codeSign() {
        
        let args = CommandLine.arguments
        
        guard args.count == 3 else {
            console.error("Usage: iSign xxx.mobileprovision xxx.ipa | xxx.app", newLine: true)
            exit(-1)
        }
        
        guard args[1].hasSuffix(".mobileprovision") else {
            console.error("Not a mobileprovision file", newLine: true)
            exit(-1)
        }
        
        if args[2].hasSuffix(".ipa") {
            //unzip
            appPath = AppFileHelper().unzip(path: args[2])
        } else if args[2].hasSuffix(".app") {
            appPath = args[2]
        } else if args[2].hasSuffix(".app/") {
            appPath = args[2].removeLast(byNumber: 1)
        } else {
            print("File type not support")
            exit(-1)
        }
        
        if LoadCommandMgr().checkEncrypt(path: appPath) {
            print("This MachO file was encrypted, Use clutch or dumpdecrypted decryped it first!")
            exit(-1)
        }
        
        let ePath = getEntitlements(path: args[1])
        
        let empPath = appPath + "/" + "embedded.mobileprovision"
        let copyRet = copy(res: provisionFilePath, dis: empPath)
        guard copyRet else {
            print("Replace embedded.mobileprovision failed")
            exit(-1)
        }
        
        let csMgr = CodeSignMgr()
        let cert = chooseCert()
        let fMgr = FileManager.default
        
        // codesign framworks
        let framework = appPath + "/Frameworks"
        
        if fMgr.fileExists(atPath: framework) && !dirMgr.isEmpty(dir: framework) {
            let signFrameworkRet = csMgr.signFrameworks(framework: framework, certificate: cert)
            if !signFrameworkRet {
                print("CodeSign Framework failed")
            } else {
                console.output("CodeSign Framework success", style: .custom(.red))
            }
        }
        
        // remove watch
        let watch = appPath + "/Watch"
        if fMgr.fileExists(atPath: watch) && !dirMgr.isEmpty(dir: watch) {
            _ = dirMgr.removeDir(dir: watch)
        }
        
        // codesign plugIns
        let plugIn = appPath + "/PlugIns"
        if fMgr.fileExists(atPath: plugIn) && !dirMgr.isEmpty(dir: plugIn) {
            
            let contents = dirMgr.listContents(dir: plugIn)
            for content in contents {
                let pluginPath = plugIn + "/" + content
                let signWatchRet = csMgr.signApp(app: pluginPath, certificate: cert, entitlements: ePath)
                if !signWatchRet {
                    print("CodeSign plugin failed")
                } else {
                    console.output("CodeSign plugin success", style: .custom(.red))
                }
            }
        }
        
        // codesign app
        let signAppRet = csMgr.signApp(app: appPath, certificate: cert, entitlements: ePath)
        if !signAppRet {
            print("CodeSign app failed")
        } else {
            console.output("CodeSign app success", style: .custom(.red))
            let appName = getAppName(path: appPath) ?? "tmp"
            zipApp(path: appPath, appName: appName)
        }
        
        clean(paths: ["./Payload", "./entitlements.plist", "./mobileprovision.plist", "./Symbols"])
    }
    
    private func zipApp(path: String, appName: String) {
        _ = IPAFileMgr().zipFile(from: path, to: "./\(appName).ipa")
    }
    
    private func clean(paths: [String]) {
        
        for path in paths {
            if FileManager.default.fileExists(atPath: path) {
                _ = dirMgr.removeDir(dir: path)
            }
        }
    }
    
    private func chooseCert() -> String {
        
        let certs = Certificate().codesigningCerts
        for i in 0..<certs.count {
            let desp = "\(i)" + " == " + certs[i]
            console.output(desp, style: .custom(.red))
        }
        var certIndex = console.ask("Choose a certificate")
        if certIndex.int == nil {
            print("Bad Input of choose")
            exit(-1)
        }
        if certIndex.int! >= certs.count {
            print("Your choose index is beyond range")
            certIndex = console.ask("Choose a certificate")
            exit(-1)
        }
        return certs[certIndex.int!]
    }
    
    private func getEntitlements(path: String) -> String {
        
        let pf = ProvisioningProfile(path: path)
        let entPath = pf.saveEntitlements(toPath: ".")
        provisionFilePath = path
        return entPath
    }
    
    private func getAppName(path: String) -> String? {
    
        let comps = path.components(separatedBy: "/").filter { !$0.equals(caseInsensitive: ".") }
        for str in comps {
            if str.hasSuffix(".app") {
                return str.removeLast(byNumber: 4)
            }
        }
        return nil
    }
    
}
