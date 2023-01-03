///Users/geng/Desktop/work/xcode_project/genglearn/genglearn.xcodeproj
//  nginxParser.swift
//  genglearn
//
//  Created by geng on 2022/12/21.
//

import Foundation
import JavaScriptCore
import SwiftyJSON

struct nginxParser {
    static func conf_to_json(){
        let context: JSContext = JSContext()
        if let jsSourcePath = Bundle.main.path(forResource: "scpt/gengParser", ofType: "js") {
            do {
                
                let jsSourceContents = try String(contentsOfFile: jsSourcePath)
                context.evaluateScript(jsSourceContents)
                
                let parseJSON = context.objectForKeyedSubscript("conf_to_json")
                let result = parseJSON?.call(withArguments: [configData.basicNginx])
                
                let modif = nginxParser.change_config(result!.toString(),port: "12121", root: "/Users/geng/Desktop/gengphp1")
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
    
    static func change_config(_ jsonAr:String, port:String,root:String,host:String = "localhost") ->JSON?{
        let jsonString = jsonAr
        if let dataFromString = jsonString.data(using: .utf8, allowLossyConversion: false) {
            var json = try? JSON(data: dataFromString)
            json!["server"]["listen"] = JSON(stringLiteral: port)
            json!["server"]["root"] = JSON(stringLiteral: root)
            json!["server"]["server_name"] = JSON(stringLiteral: host)
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


