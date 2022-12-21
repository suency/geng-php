///Users/geng/Desktop/work/xcode_project/genglearn/genglearn.xcodeproj
//  nginxParser.swift
//  genglearn
//
//  Created by geng on 2022/12/21.
//

import Foundation
import JavaScriptCore

let context: JSContext = JSContext()
   let result1: JSValue = context.evaluateScript("1 + 3")

struct server {
    var listen = 9898
    var server_name = "server_name"
}

var serverTest = [
    "server": [
        "listen":["9898"],
        "server_name":["localhost"],
        "location": [
            "args":["~","\\.php$"],
            "root":["/Users/geng/Desktop/work/test2"],
            "index":["index.html","index.htm","index.php"],
            "autoindex":["on"],
            "proxy_buffer_size":["128k"],
            "proxy_buffers":["4","256k"],
            "proxy_busy_buffers_size":["256k"]
        ],
        "location": [
            "args":["/wu/"],
            "root":["/Users/geng/Desktop/work/test3"],
            "index":["index.html","index.htm","index.php"]
        ]
    ]
]

var result = ""
func testNginx(){
    result = """
server: {

}

"""
    
    print(result1)
}
