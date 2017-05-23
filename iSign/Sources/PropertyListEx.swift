//
//  PropertyListEx.swift
//  Mixup
//
//  Created by A on 2017/4/11.
//
//

import Foundation

extension PropertyListSerialization {
    
    class func dictFrom(plistStr: String) -> [String : Any] {
        
        guard PropertyListSerialization.propertyList(plistStr, isValidFor: .xml) else {
            print("PropertyListSerialization falied because of invalid list string")
            return [:]
        }
        
        let retData = plistStr.data(using: String.Encoding.utf8)
        
        guard let data = retData else {
            print("PropertyListSerialization string to data error")
            return [:]
        }
        
        do {
            let plist = try PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil)
            guard let retDict = plist as? [String : Any] else {
                print("PropertyListSerialization failed")
                return [:]
            }
            return retDict
        } catch {
            print("PropertyListSerialization error:\(error)")
            return [:]
        }
    }
}
