//
//  InfoPlistMgr.swift
//  Mixup
//
//  Created by A on 2017/4/17.
//  Copyright © 2017年 A. All rights reserved.
//

import Cocoa
import Foundation

enum PlistFormat {
    case xml
    case bin
    case json
}

class InfoPlistMgr: Object {

    private var path = ""
    
    init?(path: String) {
    
        super.init()
        guard !path.hasPrefix(".plist") else {
            print("InfoPlistMgr init failed: path is error")
            return nil
        }
        guard FileManager.default.fileExists(atPath: path) else {
            print("InfoPlistMgr init failed: path doesn't have a valid file")
            return nil
        }
        self.path = path
    }
    
    var dictionary: NSDictionary {
        
        get {
            
            let dictOp = NSDictionary(contentsOfFile: path)
            guard let nsDict = dictOp else {
                print("InfoPlistMgr dictionary failed: read file error")
                return [:]
            }
            return nsDict
        }
    }

}
