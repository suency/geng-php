//
//  ContentView.swift
//  genglearn
//
//  Created by geng on 2022/12/13.
//
import Foundation
import SwiftUI
import Regex

struct gengMenu: MenuStyle {
    func makeBody(configuration: Configuration) -> some View {
        Menu(configuration)
            
            //.background(Color("danger"))
    }
}

func runShellAndOutput(_ command: String) -> (Int32, String?) {
    let task = Process()
    task.launchPath = "/bin/zsh"
    task.environment = ["PATH": "/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/mysql/bin"]
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
    @State var showChecking = false
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
        ZStack{
            HStack(spacing: 0) {
                VStack(alignment: .center, spacing: 0) {
                    HStack {
                        Spacer()
                            .frame(width: 38)
                        Image("logo2").resizable()
                            .interpolation(.high)
                            .frame(width: 50, height: 50)
                        VStack(alignment: .leading) {
                            Text("GENG").font(.system(size: 18))
                            Text("PHP").font(.system(size: 18))
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
                    
                    Spacer()
                    HStack {
                        VStack {
                            Text("Version: 1.0.0")
                                .font(.system(size: 13))
                                .foregroundColor(Color("maintext"))
                            Text("")
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
                self.showChecking = true
            }.sheet(isPresented: $showChecking) {
                initChecking(isLoading: $showChecking)
            }
            .frame(width: 800, height: 500, alignment: .leading)
            .background(Color("appbg"))
            
            if serverObj.loading {
                VStack{
                    
                }.frame(width: 800,height: 500)
                    .background(Color.black)
                    .opacity(0.4)
                ProgressView()
            }
            
        }.environmentObject(serverObj)
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
    @State var checkingLogNginx: String = ""
    @State var checkingLogPhp: String = ""
    @EnvironmentObject var serverObj: ServerModel
    var body: some View {
        VStack(alignment: .center, spacing: 2) {
            HStack {
                Spacer()
                ProgressView()
                    .scaleEffect(0.7)
                Spacer()
            }
            HStack {
                Text("checking...")
                Text("Nginx").foregroundColor(Color("nginx"))
            }
            HStack {
                Text("checking...")
                Text("Php").foregroundColor(Color("info"))
            }
            HStack {
                Text("checking...")
                Text("Mysql").foregroundColor(Color("mysql"))
            }
            //Text("\(self.checkingLog)")
        }.frame(width: 160, height: 130)
            .background(Color("mainbg"))
            .cornerRadius(10)
            .onAppear {
                serverObj.nginx.installed = false
                serverObj.nginx.version = "No Version"
                serverObj.nginx.status = "None"
                
                serverObj.php.installed = false
                serverObj.php.version = ("None","None")
                serverObj.php.status = "None"
                
                //nginx
                runGengShell(log: self.$checkingLogNginx).brewServiceList {
                    let bData = Tools.getBrewListData(self.checkingLogNginx)
                    let serviceName = bData.filter {
                        $0["Name"] == "nginx"
                    }
                    
                    
                    if serviceName.isEmpty {
                        print("nginx not installed")
                        serverObj.nginx.installed = false
                        serverObj.nginx.version = "None"
                        serverObj.nginx.status = "None"
                    } else {
                        let testString2 = runShellAndOutput("nginx -v").1!

                        var replacingString = testString2.replacingOccurrences(of: ".+/", with: "", options: .regularExpression)
                        replacingString = replacingString.trim()

                        serverObj.nginx.version = replacingString
                        serverObj.nginx.installed = true
                        debugPrint(replacingString)

                        if serviceName[0]["Status"]! == "none" {
                            print("nginx not started")
                            serverObj.nginx.status = "Stopped"
                        }

                        if serviceName[0]["Status"]! == "started" {
                            serverObj.nginx.status = "Running"
                            print("nginx started")
                        }
                    }
                    self.isLoading = false
                }
                
                //php
                runGengShell(log: self.$checkingLogPhp).brewServiceList {
                    let bData = Tools.getBrewListData(self.checkingLogPhp)
                    let serviceName = bData.filter {
                        return $0["Name"]?.contains(pattern: "php") ?? false
                    }
                    
                    // for version lsit
                    let versionList = bData.filter {
                        return $0["Name"]?.contains(pattern: "php") ?? false
                    }.map{
                        return $0["Name"] ?? ""
                    }
                    
                    var combineVersionList = [[String:String]]()
                    for vitem in versionList {
                        let temp = runShellAndOutput("ls /usr/local/Cellar/\(vitem)").1!.trim()
                        combineVersionList.append([vitem:temp])
                    }
                    //let abc = combineVersionList[0].keys
                    //print(combineVersionList)
                    //print(Array(abc)[0])
                    //print("hehe")
                    
                    serverObj.php.versionBrewList = combineVersionList
                    if serviceName.isEmpty {
                        print("php not installed")
                        serverObj.php.installed = false
                        serverObj.php.version = ("None","None")
                        serverObj.php.status = "None"
                    } else {
                        let testString2 = runShellAndOutput("php -v").1!
                        
                        let ranges = testString2.match(pattern: #"[0-9]+\.[0-9]+\.[0-9]"#)

                        let found:[String] = ranges.map { String(testString2[$0]) }

                        serverObj.php.installed = true
                        
                        serverObj.php.version = (found[0],found[0])
                        
                        var foundStatus = false
                        
                        /*
                        print(combineVersionList)
                        print(combineVersionList.filter{
                            $0[sitem["Name"]!] != nil
                        }[0][sitem["Name"]!]!)
                         */
                        for sitem in serviceName {
                            if sitem["Status"]! == "started" {
                                print("\(sitem["Name"]!) started")
                                serverObj.php.status = "Running"
                                
                                
                                serverObj.php.version = (
                                    sitem["Name"]!,
                                    combineVersionList.filter{
                                        $0[sitem["Name"]!] != nil
                                    }[0][sitem["Name"]!]!
                                )
                                
                                foundStatus = true
                            }
                        }
                        

                        if !foundStatus {
                            serverObj.php.status = "Stopped"
                            print("php stopped")
                        }
                    }
                    self.isLoading = false
                }
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
