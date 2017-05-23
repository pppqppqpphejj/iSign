//
//  ProcessEx.swift
//  Mixup
//
//  Created by A on 2017/4/6.
//
//

import Foundation

struct ProcessOutput {
    var output: String
    var status: Int32
    init(status: Int32, output: String){
        self.status = status
        self.output = output
    }
}

extension Process {
    
    func launchSyncronous() -> ProcessOutput {
        self.standardInput = FileHandle.nullDevice
        let pipe = Pipe()
        self.standardOutput = pipe
        self.standardError = pipe
        let pipeFile = pipe.fileHandleForReading
        self.launch()
        
        let data = NSMutableData()
        while self.isRunning {
            data.append(pipeFile.availableData)
        }
        
        let output = String(data: data as Data, encoding: String.Encoding.utf8)
        guard output != nil else {
            return ProcessOutput(status: self.terminationStatus, output: "")
        }
        return ProcessOutput(status: self.terminationStatus, output: output!)
        
    }
    
    func execute(_ launchPath: String, workingDirectory: String?, arguments: [String]?) -> ProcessOutput {
        self.launchPath = launchPath
        if arguments != nil {
            self.arguments = arguments
        }
        if workingDirectory != nil {
            self.currentDirectoryPath = workingDirectory!
        }
        return self.launchSyncronous()
    }
}
