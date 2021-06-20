//
//  Bash.swift
//  
//
//  Created by Eric Marchand on 17/06/2021.
//

import Foundation

@discardableResult
public func bash(_ command: String...) -> String {
    return bash(args: command)
}
@discardableResult
    public func bash(args: [String]) -> String {
    let task = Process()
    let pipe = Pipe()
    
    task.standardOutput = pipe
    task.standardError = pipe
    var arguments = ["/bin/bash"]
    arguments.append(contentsOf: args)
    task.arguments = arguments
    task.launchPath = "/usr/bin/env"
    task.launch()
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8)!
    print(output)
    return output
}

public func bashAdmin(_ command: String) {
    let command = "do shell script \"bash '"+command+"' 2>&1 etc\" with administrator privileges"
    let script = NSAppleScript(source: command)
    
    let output = script?.executeAndReturnError(nil)
    print("\(String(describing: output))")
}

public func remoteBash(_ url: String, _ admin: Bool) {
    let url = URL(string: url)! // will crash if not correct URL

    let task = URLSession.shared.downloadTask(with: url) { localURL, urlResponse, error in
        if let localURL = localURL {
            if admin {
                bashAdmin(localURL.path)
            } else {
                bash(localURL.path)
            }
        } else if let error = error {
            print("\(error)")
        }
    }

    task.resume()
}
