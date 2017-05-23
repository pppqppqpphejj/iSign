//
//  LoadCommandMgr.swift
//  iSign
//
//  Created by A on 2017/5/23.
//  Copyright © 2017年 A. All rights reserved.
//

import Foundation


class LoadCommandMgr: Object {
    
    func lds(path: String) -> [String] {
        
        do {
            let args = ["-l", path]
            let retStr = try console.backgroundExecute(program: "otool", arguments: args)
            if retStr.isEmpty {
                print("LoadCommandMgr otool check encryped failed")
                exit(-1)
            }
            let retArr = retStr.components(separatedBy: "Load command")
            return retArr
        } catch {
            print("LoadCommandMgr otool check encryped error: \(error)")
            exit(-1)
        }
    }
    
    func checkEncrypt(path: String) -> Bool {
        
        let infoPlistPath = path + "/" + "Info.plist"
        let infoDict = InfoPlistMgr(path: infoPlistPath)?.dictionary
        let machOFile = infoDict?["CFBundleExecutable"]
        guard machOFile != nil else {
            print("LoadCommandMgr checkEncrypt listContents failed")
            return false
        }
        
        let machOFilePath = path + "/" + (machOFile as! String)
        let lds = self.lds(path: machOFilePath)
        for ld in lds {
            if ld.contains("LC_ENCRYPTION_INFO") || ld.contains("LC_ENCRYPTION_INFO_64") {
                //print(ld)
                let cryptInfos = ld.components(separatedBy: "\n")
                for cryptoInfo in cryptInfos {
                    if cryptoInfo.contains("cryptid") {
                        //print(cryptoInfo)
                        let cryptoVales = cryptoInfo.components(separatedBy: " ")
                        for cryptoVale in cryptoVales {
                            if cryptoVale.equals(caseInsensitive: "")
                            || cryptoVale.equals(caseInsensitive: "cryptid") {
                                continue
                            }
                            // 考虑大多数情况下ARM64和ARM的加密状况是一致的，所以只判断一个
                            if cryptoVale.equals(caseInsensitive: "0") {
                                return false
                            } else {
                                return true
                            }
                        }
                    }
                }
            }
        }
        return false
    }
}
