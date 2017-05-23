//
//  BaseHelper.swift
//  Mixup
//
//  Created by A on 2017/4/19.
//  Copyright © 2017年 A. All rights reserved.
//

import Cocoa

class BaseHelper: Object {

    func input(withTip tip: String, suffix: String = "") -> String {
        
        let path = console.ask(tip).trim(characters: [" ", "\n"])
        if suffix.isEmpty {
            guard !path.isEmpty else {
                print("Path is nil")
                exit(-1)
            }
        } else {
            guard path.hasSuffix(suffix) else {
                print("Bad input path")
                exit(-1)
            }
        }
        return path
    }
    
    func inputsList(withTip tip: String, suffix: String = "") -> String {
        
        var paths = console.ask(tip).components(separatedBy: " ")
        paths = paths.filter { (str) -> Bool in
            if str.equals(caseInsensitive: "") {
                return false
            } else {
                return true
            }
        }
        print("paths ------- ", paths)
        return ""
        //let b = suffix.isEmpty ? (!path.isEmpty) : (path.hasSuffix(suffix))
    }
}
