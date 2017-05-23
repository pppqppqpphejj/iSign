//
//  IPAFileMgr.swift
//  Mixup
//
//  Created by A on 2017/4/12.
//  Copyright © 2017年 A. All rights reserved.
//

import Foundation

class IPAFileMgr: Object {
    
    private let dirMgr = DirectoryMgr()
    
    func unzipFile(zipPath: String, to unzipPath: String) -> String {
        
        let payloadPath = unzipPath + "/Payload"
        let symbolsPath = unzipPath + "/Symbols"
        
        if FileManager.default.fileExists(atPath: payloadPath) {
            _ = dirMgr.removeDir(dir: payloadPath)
        }
        if FileManager.default.fileExists(atPath: symbolsPath) {
            _ = dirMgr.removeDir(dir: symbolsPath)
        }
        do {
            let args = ["-q", zipPath, "-d", unzipPath]
            let loadingBar = console.loadingBar(title: "Unzip...")
            loadingBar.start()
            let retStr = try console.backgroundExecute(program: "unzip", arguments: args)
            
            guard retStr.isEmpty else {
                print("Unzip failed")
                exit(-1)
            }
            loadingBar.finish()
            
            let payloadPath = unzipPath + "/Payload"
            guard FileManager.default.fileExists(atPath: payloadPath) else {
                print("\(payloadPath) file doesn't exists")
                exit(-1)
            }
            let contents = dirMgr.listContents(dir: payloadPath)
            guard contents.count != 0 else {
                print("Unzip failed")
                exit(-1)
            }
            let appName = contents[0]
            let appPath = unzipPath + "/Payload" + "/" + appName
            guard FileManager.default.fileExists(atPath: appPath) else {
                print("\(appPath) file doesn't Exists")
                exit(-1)
            }
            return appPath
        } catch {
            print("Unzip error:\(error)")
            exit(-1)
        }
    }
    
    func zipFile(from resPath: String, to disPath: String) -> String {
        
        do {
            let args = ["-r", "-q", disPath, resPath]
            let loadingBar = console.loadingBar(title: "Zip...")
            loadingBar.start()
            let retStr = try console.backgroundExecute(program: "zip", arguments: args)
            guard retStr.isEmpty else {
                print("Zip failed")
                loadingBar.fail()
                return ""
            }
            loadingBar.finish()
            return disPath
        } catch {
            print("Zip error \(error)")
            exit(-1)
        }
    }
}
