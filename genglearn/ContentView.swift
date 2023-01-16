//
//  ContentView.swift
//  genglearn
//
//  Created by geng on 2022/12/13.
//
import Foundation
import Regex
import ShellOut
import SwiftUI
import AlertToast

struct gengMenu: MenuStyle {
    func makeBody(configuration: Configuration) -> some View {
        Menu(configuration)

        // .background(Color("danger"))
    }
}

func runShellAndOutput(_ command: String) -> (Int32, String?) {
    let task = Process()
    task.launchPath = "/bin/zsh"
    task.environment = ["PATH": "/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/sbin:/opt/Homebrew/bin"]
    task.arguments = ["-c", command]

    let pipe = Pipe()
    task.standardOutput = pipe
    task.standardError = pipe

    task.launch()

    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8)

    task.waitUntilExit()

    return (task.terminationStatus, output)
}

struct ContentView: View {
    @StateObject var serverObj = ServerModel()
    @StateObject var webObj = websiteModel()
    @State var showChecking = false
    @State var showCheckingBrew = false
    @State var gengToast = false
    @State var dummyLog: String = ""
    @State var menuList = [
        menuItem(imageName: "home", manuName: "home", selected: true, myview: AnyView(home())),
        menuItem(imageName: "web", manuName: "web", myview: AnyView(web())),
        menuItem(imageName: "nginx", manuName: "nginx", myview: AnyView(nginx())),
        menuItem(imageName: "mysql", manuName: "mysql", myview: AnyView(mysql())),
        menuItem(imageName: "php", manuName: "php", myview: AnyView(php())),
        menuItem(imageName: "redis", manuName: "redis", myview: AnyView(redis())),
    ]

    @State var currentIndex: Int = 0
    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                VStack(alignment: .center, spacing: 0) {
                    HStack {
                        Spacer()
                            .frame(width: 38)
                        Image("logo2").resizable()
                            .interpolation(.high)
                            .frame(width: 50, height: 50)
                        VStack(alignment: .leading) {
                            Text("GENG").font(.system(size: 18,weight: .semibold))
                            Text("PHP").font(.system(size: 18,weight: .semibold))
                        }

                        .foregroundColor(Color("danger"))

                        Spacer()
                    }
                    .padding([.bottom, .top], 30)
                    ForEach(menuList) { i in
                        i.onTapGesture(perform: {
                            for index in self.menuList.indices {
                                self.menuList[index].selected = false
                            }

                            for index in self.menuList.indices {
                                if self.menuList[index].manuName == i.manuName {
                                    self.menuList[index].selected = true
                                    self.currentIndex = index
                                }
                            }

                        })
                    }
                    
                    //let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
                    Spacer()
                    HStack {
                        VStack(spacing:2) {
                            Text("Version: \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)")
                                .font(.system(size: 13))
                                .foregroundColor(Color("maintext"))
                            Text("gengphp.com")
                                .font(.system(size: 13))
                                .foregroundColor(Color("maintext"))
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        }
                    }.padding(EdgeInsets(top: 0, leading: 0, bottom: 30, trailing: 0))
                }
                .frame(width: 180, height: 500)
                .background(Color("mainbg"))

                self.menuList[self.currentIndex].myview
            }

            .onAppear {
                DispatchQueue.main.async {
                    self.showChecking = true
                    self.gengToast = true
                    self.currentIndex = 0
                }
                
                
                serverObj.debugLog += "\n top \n"
            }.sheet(isPresented: $showChecking) {
                // checking sercices,nginx,php and mysql
                initChecking(isLoading: $showChecking, isLoadingBrew: $showCheckingBrew)

            }.sheet(isPresented: $showCheckingBrew) {
                // checking brew is installed
                gengModalBrew(log: self.$dummyLog, showInstall: self.$showCheckingBrew)
            }
            
            .frame(width: 800, height: 500, alignment: .leading)
            .background(Color("appbg"))

            if serverObj.loading {
                VStack {
                }.frame(width: 800, height: 500)
                    .background(Color.black)
                    .opacity(0.4)
                ProgressView().colorScheme(.dark)
            }
            
            //nginxConfig()
            // gengModalBrew(log: self.$dummyLog)
            // debug
            
            /*
            ScrollView {
                VStack {
                    Text(serverObj.debugLog).fixedSize()
                        .foregroundColor(.yellow)
                }
            }.frame(width: 260, height: 150, alignment: .topLeading).padding(10)
                .background(Color("main").opacity(0.6)).offset(x: -250, y: 130)
             */

        }
        .environmentObject(serverObj)
        .environmentObject(webObj)
    }
}

struct menuItem: Identifiable, View {
    var id = UUID()
    var imageName: String
    var manuName: String
    var selected: Bool
    var myview: AnyView
    var body: some View {
        HStack {
            Spacer()
                .frame(width: 40)
            Image(imageName).resizable()
                .interpolation(.high)
                .frame(width: 20, height: 20)
            Text(manuName)
                .foregroundColor(Color.white)
                .font(.system(size: 16))
            Spacer()
        }
        .frame(width: 150, height: 47)

        .background(self.selected ? Color("main4") : Color.clear)
        .contentShape(Rectangle())
        .cornerRadius(12)
    }

    init(id: UUID = UUID(), imageName: String, manuName: String, selected: Bool = false, myview: AnyView) {
        self.id = id
        self.imageName = imageName
        self.manuName = manuName
        self.selected = selected
        self.myview = myview
    }
}

struct initChecking: View {
    @Binding var isLoading: Bool
    @Binding var isLoadingBrew: Bool
    @State var checkingLogNginx: String = ""
    @State var checkingLogMysql: String = ""
    @State var checkingLogPhp: String = ""
    @State var checkingBrew: String = ""
    @EnvironmentObject var serverObj: ServerModel
    var body: some View {
        VStack(alignment: .center, spacing: 2) {
            HStack {
                Spacer()
                ProgressView().colorScheme(.dark)
                    .scaleEffect(0.7)
                Spacer()
            }
            HStack {
                Text("checking...").foregroundColor(Color.white)
                Text("Nginx").foregroundColor(Color("nginx"))
            }
            HStack {
                Text("checking...").foregroundColor(Color.white)
                Text("Php").foregroundColor(Color("info"))
            }
            HStack {
                Text("checking...").foregroundColor(Color.white)
                Text("Mysql").foregroundColor(Color("mysql"))
            }
            // Text("\(self.checkingLog)")
        }.frame(width: 160, height: 130)
            .background(Color("mainbg"))
            .cornerRadius(10)
            .onAppear {
                serverObj.debugLog += "\n appear \n"
                // print("appear")
                serverObj.nginx.installed = false
                serverObj.nginx.version = "None"
                serverObj.nginx.status = "Not Intalled"

                serverObj.php.installed = false
                serverObj.php.version = ("None", "None")
                serverObj.php.status = "Not Intalled"

                serverObj.mysql.installed = false
                serverObj.mysql.version = "None"
                serverObj.mysql.status = "Not Intalled"

                // detect chip model
                serverObj.chipModel = (runShellAndOutput("uname -m").1 ?? "x86").trim()

                // checking brew
                runGengShell(log: self.$checkingBrew).runCode("brew -v") {
                    if self.checkingBrew.contains(pattern: "command not found") {
                        self.isLoading = false
                        serverObj.debugLog = self.checkingBrew
                        self.isLoadingBrew = true
                        print("brew not installed")
                    }
                    // brew is installed
                    else {
                        // nginx
                        runGengShell(log: self.$checkingLogNginx).brewServiceList {
                            let bData = Tools.getBrewListData(self.checkingLogNginx)
                            serverObj.debugLog += "nginx: \n" + self.checkingLogNginx + "\n"

                            let serviceName = bData.filter {
                                $0["Name"] == "nginx"
                            }

                            if serviceName.isEmpty {
                                print("nginx not installed")
                                serverObj.nginx.installed = false
                                serverObj.nginx.version = "None"
                                serverObj.nginx.status = "None"
                            } else {
                                let testString2 = runShellAndOutput("nginx -v").1 ?? ""

                                var replacingString = testString2.replacingOccurrences(of: ".+/", with: "", options: .regularExpression)
                                replacingString = replacingString.trim()

                                serverObj.nginx.version = replacingString
                                serverObj.nginx.installed = true

                                let statusContent = serviceName[0]["Status"] ?? "error"

                                if statusContent == "none" {
                                    // print("nginx not started")
                                    serverObj.nginx.status = "Stopped"
                                }

                                if statusContent == "started" {
                                    serverObj.nginx.status = "Running"
                                    // print("nginx started")
                                }

                                if statusContent == "error" {
                                    serverObj.nginx.status = "Error"
                                    // print("nginx started")
                                }
                            }
                            self.isLoading = false
                        }

                        // mysql
                        runGengShell(log: self.$checkingLogMysql).brewServiceList {
                            let bData = Tools.getBrewListData(self.checkingLogMysql)

                            serverObj.debugLog += "mysql: \n" + self.checkingLogNginx
                            let serviceName = bData.filter {
                                $0["Name"] == "mysql"
                            }

                            // print("bData",serviceName.isEmpty)
                            if serviceName.isEmpty {
                                print("mysql not installed")
                                serverObj.mysql.installed = false
                                serverObj.mysql.version = "None"
                                serverObj.mysql.status = "None"
                            } else {
                                let replacingString = (runShellAndOutput("mysql -V").1 ?? "").trim()
                                let ranges = replacingString.match(pattern: #"[0-9]+\.[0-9]+\.[0-9]"#)
                                let found: [String] = ranges.map { String(replacingString[$0]) }

                                let statusContent = serviceName[0]["Status"] ?? "error"
                                serverObj.mysql.version = found[0]
                                serverObj.mysql.installed = true
                                // debugPrint("serviceName",serviceName)

                                if statusContent == "none" {
                                    // print("mysql not started")
                                    serverObj.mysql.status = "Stopped"
                                }

                                if statusContent == "started" {
                                    serverObj.mysql.status = "Running"
                                    // print("mysql started")
                                }

                                if statusContent == "error" {
                                    serverObj.mysql.status = "Error"
                                    // print("mysql started")
                                }
                            }
                            self.isLoading = false
                        }

                        // php
                        runGengShell(log: self.$checkingLogPhp).brewServiceList {
                            let bData = Tools.getBrewListData(self.checkingLogPhp)

                            serverObj.debugLog += "php dedug: \n" + self.checkingLogPhp + "\n"

                            let serviceName = bData.filter {
                                $0["Name"]?.contains(pattern: "php") ?? false
                            }

                            // for version list
                            let versionList = bData.filter {
                                $0["Name"]?.contains(pattern: "php") ?? false
                            }.map {
                                $0["Name"] ?? ""
                            }

                            //print("versionList",versionList)
                            var combineVersionList = [[String: String]]()
                            for vitem in versionList {
                                var temp = ""
                                // let temp = runShellAndOutput("ls /usr/local/Cellar/\(vitem)").1!.trim()
                                if serverObj.chipModel.contains(pattern: "x86") {
                                    temp = (runShellAndOutput("ls \(serverObj.x86Cellar)/\(vitem)").1 ?? "").trim()
                                } else {
                                    temp = (runShellAndOutput("ls \(serverObj.armCellar)/\(vitem)").1 ?? "").trim()
                                }

                                combineVersionList.append([vitem: temp])
                                serverObj.debugLog += "temp: \n" + temp + "\n"
                            }

                            serverObj.php.versionBrewList = combineVersionList
                            
                            //print("combineVersionList",combineVersionList)

                            if serviceName.isEmpty {
                                // print("php not installed")
                                serverObj.php.installed = false
                                serverObj.php.version = ("None", "None")
                                serverObj.php.status = "None"
                            } else {
                                let testString2 = runShellAndOutput("php -v").1 ?? ""

                                serverObj.debugLog += "php -v: \n" + testString2 + "\n"

                                let ranges = testString2.match(pattern: #"[0-9]+\.[0-9]+\.[0-9_]"#)

                                let found: [String] = ranges.map { String(testString2[$0]) }
                                serverObj.php.installed = true

                                // ["php@7.4": "7.4.33"]
                                let findVersion = Dollar.find(combineVersionList) {
                                    Array($0.values)[0].contains(pattern: found[0])
                                }

                                serverObj.php.version = (Dollar.keys(findVersion ?? ["php": "8.2.0"])[0], found[0])
                                
                                //print("serverObj.php.version",serverObj.php.version)
                                var foundStatus = false
                                for sitem in serviceName {
                                    if sitem["Status"]! == "started" {
                                        serverObj.php.status = "Running"
                                        serverObj.php.version = (
                                            sitem["Name"]!,
                                            combineVersionList.filter {
                                                $0[sitem["Name"]!] != nil
                                            }[0][sitem["Name"]!]!
                                        )

                                        foundStatus = true
                                    }
                                }

                                if !foundStatus {
                                    serverObj.php.status = "Stopped"
                                }
                            }
                            self.isLoading = false
                        }
                    }
                }

                /*
                 let filePath = "/usr/local/etc/nginx/servers/geng_nginx.conf"
                 if !FileManager.default.fileExists(atPath: filePath){
                     _ = try? shellOut(to: .createFile(named: filePath, contents: "hhhh"))
                 }
                  */

                // print(serverObj.chipModel.contains("x86"))
                //testNginx()
            }
    }
}

/*

 struct showCheckingPreview: PreviewProvider {
     @State static var isLoading = false
     @StateObject static var serverObj = ServerModel()
     static var previews: some View {
         VStack{
             initChecking(isLoading: $isLoading)
         }.environmentObject(serverObj)

     }
 }
  */

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
