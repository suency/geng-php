//
//  cmd.swift
//  genglearn
//
//  Created by geng on 2022/12/18.
//

import Foundation
import SwiftUI

struct runGengShellApple {
    @Binding var log:String
    func runCode(_ args: String,onComplete:@escaping ()->Void) {
        let task = Process()
        task.launchPath = "/usr/bin/osascript"
        //task.launchPath = "/bin/zsh"
        task.environment = ["PATH": "/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/sbin:/opt/Homebrew/bin"]
        task.arguments = [args]
        //task.arguments = ["/Users/geng/Desktop/others/first.scpt"]
        //task.arguments = ["-c", args]
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


struct runGengShell {
    @Binding var log:String
    func runCode(_ args: String,onComplete:@escaping ()->Void) {
        let task = Process()
        task.launchPath = "/bin/zsh"
        task.environment = ["PATH": "/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/sbin:/opt/Homebrew/bin"]
        task.arguments = ["-c", args]
        let outputPipe = Pipe()
        task.standardOutput = outputPipe
        task.standardError = outputPipe
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
    
    //nginx
    func nginxStart(onComplete:@escaping ()->Void){
        self.runCode(#"""brew services start nginx"""#,onComplete:onComplete)
    }
    
    func nginxStop(onComplete:@escaping ()->Void){
        self.runCode(#"""brew services stop nginx"""#,onComplete:onComplete)
    }
    
    func nginxRestart(onComplete:@escaping ()->Void){
        self.runCode(#"""brew services restart nginx"""#,onComplete:onComplete)
    }
    
    //mysql
    func mysqlStart(onComplete:@escaping ()->Void){
        self.runCode(#"""brew services start mysql"""#,onComplete:onComplete)
    }
    
    func mysqlStop(onComplete:@escaping ()->Void){
        self.runCode(#"""brew services stop mysql"""#,onComplete:onComplete)
    }
    
    func mysqlRestart(onComplete:@escaping ()->Void){
        self.runCode(#"""brew services restart mysql"""#,onComplete:onComplete)
    }
    
    //php
    func phpStart(onComplete:@escaping ()->Void){
        self.runCode(#"""brew services start php"""#,onComplete:onComplete)
    }
    
    func phpStop(onComplete:@escaping ()->Void){
        self.runCode(#"""brew services stop php"""#,onComplete:onComplete)
    }
    
    func phpRestart(onComplete:@escaping ()->Void){
        self.runCode(#"""brew services restart php"""#,onComplete:onComplete)
    }
    
    func phpSwitch(currentVersion:(String,String),targetVersion:(String,String),onComplete:@escaping ()->Void){
        
        print("currentVersion",currentVersion)
        print("targetVersion",targetVersion)
        
        self.runCode("brew services stop \(currentVersion.0) && brew services start \(targetVersion.0) && brew unlink \(currentVersion.0) && brew link \(targetVersion.0)",onComplete:onComplete)
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
