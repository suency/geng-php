//
//  cmd.swift
//  genglearn
//
//  Created by geng on 2022/12/18.
//

import Foundation
import SwiftUI


struct runGengShell {
    @Binding var log:String
    func runCode(_ args: String,onComplete:@escaping ()->Void) {
        let task = Process()
        task.launchPath = "/bin/zsh"
        task.environment = ["PATH": "/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/mysql/bin"]
        task.arguments = ["-c", args]
        let outputPipe = Pipe()
        task.standardOutput = outputPipe
        let outputHandle = outputPipe.fileHandleForReading
        outputHandle.readabilityHandler = { pipe in
            if let ouput = String(data: pipe.availableData, encoding: .utf8) {
                if !ouput.isEmpty {
                    log += ouput
                    //print("----> ouput: \(ouput) ")
                } else{
                    DispatchQueue.main.async {
                        onComplete()
                    }
                    
                    try?pipe.close()
                    task.waitUntilExit()
                }
                
            } else {
                print("Error decoding data: \(pipe.availableData)")
            }
        }
        task.launch()
    }
    
    
    func checkLocalBrew(onComplete:@escaping ()->Void){
        self.runCode(#"""cd "$(brew --repo)" && git remote -v"""#,onComplete:onComplete)
    }
    
    func nginxStart(onComplete:@escaping ()->Void){
        self.runCode(#"""brew services start nginx"""#,onComplete:onComplete)
    }
    
    func nginxStop(onComplete:@escaping ()->Void){
        self.runCode(#"""brew services stop nginx"""#,onComplete:onComplete)
    }
    
    func nginxRestart(onComplete:@escaping ()->Void){
        self.runCode(#"""brew services restart nginx"""#,onComplete:onComplete)
    }
    
    func brewServiceList(onComplete:@escaping ()->Void){
        self.runCode(#"""brew services list"""#,onComplete:onComplete)
    }
    
    func pingTest(onComplete:@escaping ()->Void){
        self.runCode(#"""ping -c 10 127.0.0.1"""#,onComplete:onComplete)
    }
}

struct MainView888: View {
    @State var log: String = "testing"
    
    var body: some View {
        Text(log)
            .onAppear {
               runCode()
            }
            .frame(width: 444, height: 444)
    }
    
    func runCode() {
        let task = Process()
        task.executableURL = URL(fileURLWithPath: "/sbin/ping")
        task.arguments = [ "-c", "100", "127.0.0.1" ]
        let outputPipe = Pipe()
        task.standardOutput = outputPipe
        let outputHandle = outputPipe.fileHandleForReading
        outputHandle.readabilityHandler = { pipe in
            if let ouput = String(data: pipe.availableData, encoding: .utf8) {
                if !ouput.isEmpty {
                    log += ouput
                    print("----> ouput: \(ouput)")
                }
            } else {
                print("Error decoding data: \(pipe.availableData)")
            }
        }
        task.launch()
    }
}
