//
//  Utility.swift
//  CheckPurchase
//
//  Created by A on 2017/3/30.
//
//

import Foundation


func pwd() {
    
    let console: ConsoleProtocol = Terminal(arguments: CommandLine.arguments)
    do {
        let retStr = try console.backgroundExecute(program: "pwd", arguments: [])
        if retStr.isEmpty {
            console.print("pwd failed")
            return
        }
        print(retStr)
    } catch {
        print("pwd error :\(error)")
        return
    }
}

// MARK: - crash
func md5_bak(fileDir: String) -> String {
    
    print("fileDir", fileDir)
    let prs = Process()
    let output = prs.execute("md5", workingDirectory: "./", arguments: [fileDir])
    print("output", output)
    print("output.output", output.output)
    return output.output
}

func md5(fileDir: String) -> String {
    
    let console: ConsoleProtocol = Terminal(arguments: CommandLine.arguments)
    do {
        let retStr = try console.backgroundExecute(program: "md5", arguments: ["-q", fileDir])
        if retStr.isEmpty {
            console.print("md5 failed")
            return ""
        }
        return retStr
    } catch {
        print("md5 error :\(error)")
        return ""
    }
}

func isSameFile(fileDir0: String, fileDir1: String) -> Bool {
    return md5(fileDir: fileDir0).equals(caseInsensitive: md5(fileDir: fileDir1))
}

func copy(res: String, dis: String) -> Bool {
    
    let console: ConsoleProtocol = Terminal(arguments: CommandLine.arguments)
    let args = ["-f", res, dis]
    //print("Copy args: \(args)")
    
    do {
        let retStr = try console.backgroundExecute(program: "cp", arguments: args)
        if !retStr.isEmpty {
            console.print("Copy failed")
            return false
        }
        return true
    } catch {
        print("Copy error :\(error)")
        return false
    }
}

func convert(plistPath: String, format: PlistFormat) {
    
    var fmt = ""
    switch format {
    case .xml:
        fmt = "xml1"
    case .bin:
        fmt = "binary1"
    case .json:
        fmt = "json"
    }
    
    let console: ConsoleProtocol = Terminal(arguments: CommandLine.arguments)
    do {
        let args = ["-convert", fmt, plistPath]
        let retStr = try console.backgroundExecute(program: "plutil", arguments: args)
        guard retStr.isEmpty else {
            print("InfoPlistMgr dictionary failed: plutil failed")
            exit(-1)
        }
    } catch {
        print("InfoPlistMgr dictionary failed: plutil error\(error)")
        exit(-1)
    }
}
