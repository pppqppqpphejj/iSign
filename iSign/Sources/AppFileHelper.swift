//
//  AppFileHelper.swift
//  Mixup
//
//  Created by A on 2017/4/12.
//  Copyright © 2017年 A. All rights reserved.
//

import Cocoa

enum AppFileType {
    case dir // .app .xcarchive
    case zip // .zip .ipa
    case unknown
}

class AppFileHelper: BaseHelper {
    
    private let ipaMgr = IPAFileMgr()
    
    func unzip(path: String) -> String {
        
        guard path.hasSuffix(".ipa") else {
            print("Bad Unzip Input")
            exit(-1)
        }
        
        let unzipPath = ipaMgr.unzipFile(zipPath: path, to: ".")
        return unzipPath
    }
    
    func zip() {
        
        let appPath = console.ask("Input the Payload/xxx.app path").trim(characters: [" ", "\n"])
        guard appPath.hasSuffix(".app") else {
            print("Bad Payload/xxx.app path Input")
            exit(-1)
        }
        _ = ipaMgr.zipFile(from: appPath, to: "./tmp.ipa")
    }
    
    func changeExeName(path: String) {
        
        // TODO: 2
        print("you are naughty")
    }
}
