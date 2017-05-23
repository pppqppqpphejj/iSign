//
//  StringEx.swift
//  Mixup
//
//  Created by A on 2017/4/19.
//  Copyright © 2017年 A. All rights reserved.
//

import Foundation

extension String {
    
    func lastWord(separatedBy str: String) -> String {
    
        let comps = components(separatedBy: str)
        let cleanComps = comps.filter { (str) -> Bool in
            if str.equals(caseInsensitive: "") {
                return false
            } else {
                return true
            }
        }
        return cleanComps.last ?? ""
    }
    
    func lastChars(byNumber num: Int) -> String {
        
        let endIdx = self.index(endIndex, offsetBy: -(num-1))
        let startIdx = self.index(before: endIdx)
        let subStr = substring(from: startIdx)
        return subStr
    }
    
    func removeLast(byNumber num: Int) -> String {
        
        let endIdx = self.index(endIndex, offsetBy: -(num-1))
        let startIdx = self.index(before: endIdx)
        let subStr = substring(to: startIdx)
        return subStr
    }
    
    func subString(byRange range: Range<Int>) -> String {
        
        let startIdx = self.index(startIndex, offsetBy: range.lowerBound)
        let endIdx = self.index(startIndex, offsetBy: range.upperBound)
        let subStr = substring(with: startIdx..<endIdx)
        return subStr
    }
}
