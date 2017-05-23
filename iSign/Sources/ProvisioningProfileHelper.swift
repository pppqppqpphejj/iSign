//
//  ProvisioningProfileHelper.swift
//  Mixup
//
//  Created by A on 2017/4/19.
//  Copyright © 2017年 A. All rights reserved.
//

import Cocoa

class ProvisioningProfileHelper: Object {

    func saveEntitlements() -> String {
        
        let pfPath = console.ask("Input ProvisionProfile").trim(characters: [" ", "\n"])
        guard pfPath.hasSuffix(".mobileprovision") else {
            print("Bad input of ProvisionProfile")
            exit(-1)
        }
        let pf = ProvisioningProfile(path: pfPath)
        let entPath = pf.saveEntitlements(toPath: ".")
        
        return entPath
    }
}
