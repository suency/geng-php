///Users/geng/Desktop/work/xcode_project/genglearn/genglearn.xcodeproj
//  nginxParser.swift
//  genglearn
//
//  Created by geng on 2022/12/21.
//

import Foundation
import JavaScriptCore
import SwiftyJSON
import SwiftUI
import ShellOut

struct nginxParser {
    var chipModel:String
    
    func json_to_conf(json:String) -> String{
        let context: JSContext = JSContext()
        if let jsSourcePath = Bundle.main.path(forResource: "scpt/gengParser", ofType: "js"){
            
            do {
                let jsSourceContents = try String(contentsOfFile: jsSourcePath)
                context.evaluateScript(jsSourceContents)
                
                let parseConf = context.objectForKeyedSubscript("json_to_conf")
                let result2 = parseConf?.call(withArguments: [json])
                return result2!.toString()
            } catch let err {
                print(err)
            }
            
        }
        return ""
        
    }
    
    func conf_to_json() -> String{
        let context: JSContext = JSContext()
        if let jsSourcePath = Bundle.main.path(forResource: "scpt/gengParser", ofType: "js") {
            do {
                
                let jsSourceContents = try String(contentsOfFile: jsSourcePath)
                context.evaluateScript(jsSourceContents)
              
                let configPath = self.chipModel.contains(pattern: "x86") ? "/usr/local/etc/nginx/servers/geng_nginx.conf" : "/opt/homebrew/etc/nginx/servers/geng_nginx.conf"
                // file does not exist, create and add basic content
                
                if !FileManager.default.fileExists(atPath: configPath){
                    writeFileGeng(source: URL(string: configPath)!, content: configData.basicNginx)
                } else {
                    //writeFileGeng(source: URL(string: configPath)!, content: result2!.toString(),startOrEnd:"append")
                    let configContent = try shellOut(to: .readFile(at: configPath))
                    
                    
                    let parseJSON = context.objectForKeyedSubscript("conf_to_json")
                    let result = parseJSON?.call(withArguments: [configContent])
                    
                    
                    //let modif = self.change_config(result!.toString(),port: "12121", root: "/Users/geng/Desktop/gengphp1",index:0)
                    //let parseConf = context.objectForKeyedSubscript("json_to_conf")
                    //let result2 = parseConf?.call(withArguments: [modif!.rawString()!])
                    //print(result!)
                    return result!.toString()
                    
                }

            }
            catch {
                //print(error.localizedDescription)
            }
        }
        return "undefined"
    }
    
    func conf_to_json_basic() -> String{
        let context: JSContext = JSContext()
        if let jsSourcePath = Bundle.main.path(forResource: "scpt/gengParser", ofType: "js") {
            do {
                
                let jsSourceContents = try String(contentsOfFile: jsSourcePath)
                context.evaluateScript(jsSourceContents)
              
                let parseJSON = context.objectForKeyedSubscript("conf_to_json")
                let result = parseJSON?.call(withArguments: [configData.basicNginx])
                
                //print(result!.toString()!)
                return result!.toString()
            }
            catch {
                print(error.localizedDescription)
            }
        }
        return "undefined"
    }
    
    func change_config(_ jsonAr:String, port:String,root:String,index:Int, host:String = "localhost") ->JSON?{
        let jsonString = jsonAr
        if let dataFromString = jsonString.data(using: .utf8, allowLossyConversion: false) {
            var json = try? JSON(data: dataFromString)
            json!["server"][index]["listen"] = JSON(stringLiteral: port)
            json!["server"][index]["root"] = JSON(stringLiteral: root)
            json!["server"][index]["server_name"] = JSON(stringLiteral: host)
            return json
        }else{
            return JSON()
        }
       
    }
}

func testNginx(){
    let context: JSContext = JSContext()
    if let jsSourcePath = Bundle.main.path(forResource: "scpt/gengParser", ofType: "js") {
        do {
            
            let jsSourceContents = try String(contentsOfFile: jsSourcePath)
            context.evaluateScript(jsSourceContents)
            
            let parseJSON = context.objectForKeyedSubscript("conf_to_json")
            let result = parseJSON?.call(withArguments: ["the message"])

            let modif = testSwiftJson(result!.toString())
            
            let parseConf = context.objectForKeyedSubscript("json_to_conf")
            let result2 = parseConf?.call(withArguments: [modif!.rawString()!])
            print("modif",modif!)
            print("ll",result2!)
        }
        catch {
            print(error.localizedDescription)
        }
    }
}

func testSwiftJson(_ jsonAr:String) ->JSON?{
    let jsonString = jsonAr
    if let dataFromString = jsonString.data(using: .utf8, allowLossyConversion: false) {
        var json = try? JSON(data: dataFromString)
        json!["server"]["server_name"] = "diaobi"
        //print(json!)
        return json
    }else{
        return JSON()
    }
   
}


