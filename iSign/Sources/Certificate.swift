//
//  Certificate.swift
//  Mixup
//
//  Created by A on 2017/4/11.
//
//

import Foundation

class Certificate: Object {
    
    var codesigningCerts: [String] {
        
        get {
            do {
                let args = ["find-identity", "-v", "-p", "codesigning"]
                let retStr = try console.backgroundExecute(program: "security", arguments: args)
                if retStr.isEmpty {
                    print("Certificate security find-identity failed")
                    return []
                }
                let certs = retStr.components(separatedBy: "\"")
                
                var output: [String] = []
                for index in stride(from: 0, through: certs.count - 2, by: 2) {
                    if !(certs.count - 1 < index + 1) {
                        output.append(certs[index + 1])
                    }
                }
                return output
            } catch {
                print("Certificate security find-identity error:\(error)")
                return []
            }
        }
    }
}
