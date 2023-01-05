//
//  gengModel.swift
//  genglearn
//
//  Created by geng on 2022/12/18.
//

import Foundation
import SwiftUI

class ServerModel: ObservableObject {
    @Published var nginx = nginxObj()
    @Published var php = phpObj()
    @Published var mysql = mysqlObj()
    @Published var loading = false
    @Published var chipModel = "x86"
    @Published var armCellar = "/opt/Homebrew/Cellar"
    @Published var x86Cellar = "/usr/local/Cellar"
    @Published var armBrewHome = "/opt"
    @Published var x86BrewHome = "/usr/local"
    @Published var debugLog = "debug:\n"
}

struct nginxObj {
    var installed = false
    var status = "None"
    var version = "1.22.1"
}

struct phpObj {
    var installed = false
    var status = "None"
    var version = ("php","8.0.25")
    var versionBrewList = [[String:String]]()
}

struct mysqlObj {
    var installed = false
    var status = "None"
    var version = "8.0.1"
}


class websiteModel: ObservableObject {
    //@Published var data = [["port": "12698", "hostname": "localhost", "rootDir": "","id":UUID().uuidString]]
    @Published var data:[webItem] = []
    
}

struct webItem:Hashable, Identifiable {
    var port:String = "8686"
    var hostname:String = "localhost"
    var rootDir:String = "\(homePath)/Desktop/gengphp"
    var id:String = UUID().uuidString
}
