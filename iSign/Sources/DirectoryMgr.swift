//
//  DirectoryMgr.swift
//  Mixup
//
//  Created by A on 2017/4/6.
//
//

import Foundation

class DirectoryMgr: Object {
    
    // This func may not work
    func cdToDir(dir: String) -> Bool {
        
        console.output("cd to dir \(dir)", style: .custom(.red), newLine: true)
        do {
            let retStr = try console.backgroundExecute(program: "cd", arguments: ["\(dir)"])
            if !retStr.isEmpty {
                console.print("cd to dir \(dir) failed")
                return false
            }
            return true
        } catch {
            print("cd to dir \(dir) error:\(error)")
            return false
        }
    }
    
    func listCurrentDirs() -> [String] {
        
        return listAllContents(dir: "./")
    }
    
    func listAllContents(dir: String) -> [String] {
        
        //console.output("List current directory contents", style: .custom(.red), newLine: true)
        do {
            let retStr = try console.backgroundExecute(program: "ls", arguments: ["-a", dir])
            if retStr.isEmpty {
                console.print("List current directory contents failed")
                return []
            }
            var retArr = retStr.components(separatedBy: "\n")
            retArr.removeLast()
            return retArr
        } catch {
            print("List current directory contents error:\(error)")
            return []
        }
    }
    
    func listContents(dir: String) -> [String] {
        
        //console.output("List current directory contents", style: .custom(.red), newLine: true)
        do {
            let retStr = try console.backgroundExecute(program: "ls", arguments: [dir])
            if retStr.isEmpty {
                console.print("List directory contents failed")
                return []
            }
            var retArr = retStr.components(separatedBy: "\n")
            retArr.removeLast()
            return retArr
        } catch {
            print("List directory contents error:\(error)")
            return []
        }
    }
    
    func createDir(dir: String) -> Bool {
        
        console.output("Create dir \(dir)", style: .custom(.magenta))
        do {
            let retStr = try console.backgroundExecute(program: "mkdir", arguments: ["\(dir)"])
            if !retStr.isEmpty {
                console.print("Create dir \(dir) failed")
                return false
            }
            return true
        } catch {
            print("Create dir \(dir) error:\(error)")
            return false
        }
    }
    
    func removeDir(dir: String) -> Bool {
        
        //console.output("Remove dir \(dir)", style: .custom(.magenta))
        do {
            let retStr = try console.backgroundExecute(program: "rm", arguments: ["-rf", dir])
            if !retStr.isEmpty {
                console.print("Remove dir \(dir) failed")
                return false
            }
            return true
        } catch {
            print("Remove dir \(dir) error:\(error)")
            return false
        }
    }
    
    // abandoned
    func excludeDotsDirs(dirs: [String]) -> [String] {
        
        let cleanItems = dirs.filter { (str) -> Bool in
            if str.equals(caseInsensitive: ".") || str.equals(caseInsensitive: "..") {
                return false
            } else {
                return true
            }
        }
        return cleanItems
    }
    
    func isEmpty(dir: String) -> Bool {
        let items = listContents(dir: dir)
        return items.count == 0
    }
}
