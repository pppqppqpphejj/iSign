//
//  CodeSignMgr.swift
//  Mixup
//
//  Created by A on 2017/4/12.
//
//

import Foundation

class CodeSignMgr: Object {
    
    private let dirMgr = DirectoryMgr()
    
    func signFrameworks(framework: String, certificate: String) -> Bool {
        
        checkCert(certificate: certificate)
        
        let frameworks = dirMgr.listContents(dir: framework)
        
        for f in frameworks {
            
            let fPath = framework + "/" + f
            let args = ["-fs", certificate, fPath]
            if !signWithArgs(args: args) { // 签名失败就终止返回
                return false
            }
        }
        return true
    }
    
    func signApp(app: String, certificate: String, entitlements: String) -> Bool {
        
        checkCert(certificate: certificate)
        let args = ["-fs", certificate, "--entitlements", entitlements, app]
        return signWithArgs(args: args)
    }
    
    private func signWithArgs(args: [String]) -> Bool {
        
        //print("codesign args: \(args)")
        do {
            let loadingBar = console.loadingBar(title: "CodeSign...")
            loadingBar.start()
            let retStr = try console.backgroundExecute(program: "codesign", arguments: args)
            if !retStr.isEmpty {
                print("CodeSign failed")
                return false
            }
            loadingBar.finish()
            return true
        } catch {
            print("CodeSign error:\(error)")
            return false
        }
    }
    
    private func checkCert(certificate: String) {
    
        guard certificate.hasPrefix("iPhone Distribution") ||
            certificate.hasPrefix("iPhone Developer") else {
                print("Invalid Certificate")
                exit(-1)
        }
    }
}
