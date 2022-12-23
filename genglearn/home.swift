//
//  home.swift
//  genglearn
//
//  Created by geng on 2022/12/13.
//

import Foundation
import Regex
import ShellOut
import SwiftShell
import SwiftUI

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))

        return path
    }
}

struct installItem: View {
    @State var hoverDisplay = false
    var logo: String
    var logoContent: String
    var logoColor: String
    var hoverText: String

    var installAction: () -> Void
    var body: some View {
        ZStack {
            VStack(spacing: 1) {
                Image(logo).resizable()
                    .interpolation(.high)
                    .frame(width: 25, height: 25)
                Text(logoContent).foregroundColor(.white)
            }
            .frame(width: 55, height: 55)
            .background(Color(logoColor))
            .cornerRadius(10)
            .onHover(perform: {
                h in
                hoverDisplay = h
            })

            if self.hoverDisplay {
                VStack(spacing: 1) {
                    Text(hoverText).fontWeight(.medium)
                }
                .frame(width: 55, height: 55)
                .contentShape(Rectangle())
                .onTapGesture(perform: {
                    installAction()
                })
                .background(Color.black.opacity(0.8))
                .cornerRadius(10)
            }
        }
    }
}

struct installModel: View {
    @Binding var showInstall: Bool
    @Binding var log: String
    var body: some View {
        VStack(spacing: 10) {
            Text("Note: You should install brewTap if you want to install php < 8! Because Brew does not support php < 8")
                .foregroundColor(.white)
                .padding(10)
            
            HStack(spacing: 12) {
                installItem(logo: "nginx", logoContent: "Nginx", logoColor: "nginx", hoverText: "install") {
                    let filepath = Bundle.main.path(forResource: "scpt/nginx", ofType: "scpt")
                    runGengShellApple(log: self.$log).runCode(filepath!) {
                        print("ok")
                    }
                }

                installItem(logo: "php", logoContent: "Php8", logoColor: "php", hoverText: "install") {
                    let filepath = Bundle.main.path(forResource: "scpt/php", ofType: "scpt")
                    runGengShellApple(log: self.$log).runCode(filepath!) {
                        print("ok")
                    }
                }
                
                installItem(logo: "php", logoContent: "Php7", logoColor: "php", hoverText: "install") {
                    let filepath = Bundle.main.path(forResource: "scpt/php7", ofType: "scpt")
                    runGengShellApple(log: self.$log).runCode(filepath!) {
                        print("ok")
                    }
                }

                installItem(logo: "mysql", logoContent: "Mysql", logoColor: "mysql", hoverText: "install") {
                    let filepath = Bundle.main.path(forResource: "scpt/mysql", ofType: "scpt")
                    runGengShellApple(log: self.$log).runCode(filepath!) {
                        print("ok")
                    }
                }

                // installItem(logo: "apache", logoContent: "Apache", logoColor: "apache", hoverText: "install", installAction: {})
            }
            HStack(spacing: 12) {
                installItem(logo: "php", logoContent: "Php5", logoColor: "php", hoverText: "install") {
                    let filepath = Bundle.main.path(forResource: "scpt/php5", ofType: "scpt")
                    runGengShellApple(log: self.$log).runCode(filepath!) {
                        print("ok")
                    }
                }
                
                installItem(logo: "brew", logoContent: "BrewCN", logoColor: "mirror", hoverText: "安装") {
                    let filepath = Bundle.main.path(forResource: "scpt/brew_cn", ofType: "scpt")
                    runGengShellApple(log: self.$log).runCode(filepath!) {
                        print("ok")
                    }
                }
                
                installItem(logo: "brew", logoContent: "BrewEN", logoColor: "brew", hoverText: "install") {
                    let filepath = Bundle.main.path(forResource: "scpt/brew", ofType: "scpt")
                    runGengShellApple(log: self.$log).runCode(filepath!) {
                        print("ok")
                    }
                }
                
                installItem(logo: "brew", logoContent: "BrewTap", logoColor: "brew", hoverText: "install") {
                    let filepath = Bundle.main.path(forResource: "scpt/brew", ofType: "scpt")
                    runGengShellApple(log: self.$log).runCode(filepath!) {
                        print("ok")
                    }
                }
            }
            Text("Close and Restart")
                .foregroundColor(.white)
                .frame(width: 150, height: 30)
                .contentShape(Rectangle())
                .onTapGesture(perform: {
                    self.showInstall = false
                    let filepath = Bundle.main.path(forResource: "scpt/restart", ofType: "scpt")
                    runGengShellApple(log: self.$log).runCode(filepath!) {
                        print("ok")
                    }
                })
                .background(Color("main4"))
                .cornerRadius(10)
        }
        .frame(width: 350, height: 260)
        .background(Color("mainbg"))
    }
}

struct showInstallPreview: PreviewProvider {
    @State static var showInstall = false
    @State static var log = ""
    static var previews: some View {
        VStack {
            HStack {
                installModel(showInstall: $showInstall, log: $log)
            }
        }
    }
}

struct home: View {
    // @State var consoleInfo: [String] = []
    @State var consoleInfoPipe: String = ""
    @State var showInstall = false
    @State var showFullScreenLoading = false
    @State var phpVersionShow = false
    @EnvironmentObject var serverObj: ServerModel
    var topID = UUID()
    var bottomID = UUID()
    var body: some View {
        VStack {
            HStack {
                Text("Panel")
                    .foregroundColor(Color("maintext"))
                Spacer()

                Text("Test").frame(width: 65, height: 25)
                    .contentShape(Rectangle())
                    .onTapGesture(perform: {
                        //let filepath = Bundle.main.path(forResource: "scpt/brew_cn", ofType: "scpt")
                        //runGengShellApple(log: self.$consoleInfoPipe).runCode(filepath!) {
                          //  print("ok")
                        //}

                        // runGengShell(log: self.$consoleInfoPipe).checkLocalBrew()
                        // runGengShell(log: self.$consoleInfoPipe).nginxStart()
                        // runGengShell(log: self.$consoleInfoPipe).pingTest()
                    })
                    .foregroundColor(Color.white)
                    .background(Color("main4"))
                    .cornerRadius(5)
                    .opacity(0)
                
                Text("Fix Brew").frame(width: 85, height: 25)
                    .contentShape(Rectangle())
                    .onTapGesture(perform: {
                        let brewHome = serverObj.chipModel.contains(pattern: "x86") ? serverObj.x86BrewHome : serverObj.armBrewHome
                        let fixCode = "git config --global --add safe.directory \(brewHome)/Homebrew/Library/Taps/homebrew/homebrew-core;git config --global --add safe.directory \(brewHome)/Homebrew/Library/Taps/homebrew/homebrew-cask"
                        serverObj.loading = true
                        runGengShell(log: self.$consoleInfoPipe).runCode(fixCode) {
                            serverObj.loading = false
                            print("fixed")
                        }
                    })
                    .foregroundColor(Color.white)
                    .background(Color("main4"))
                    .cornerRadius(5)
                
                Text("Install").frame(width: 65, height: 25)
                    .contentShape(Rectangle())
                    .onTapGesture(perform: {
                        self.showInstall = true
                    }).sheet(isPresented: $showInstall, content: {
                        VStack {
                            HStack {
                                installModel(showInstall: $showInstall, log: $consoleInfoPipe)
                            }
                        }
                        .frame(width: 350, height: 260)
                        .background(Color("mainbg"))
                    })
                    .foregroundColor(Color.white)
                    .background(Color("main4"))
                    .cornerRadius(5)

            }.frame(width: 550, height: 28)
                .padding([.bottom],8)
            VStack(spacing: 15) {
                Spacer()
                    .frame(width: 550, height: 8)
                HStack {
                    Text("Name")
                        .frame(width: 60, alignment: .leading)
                    Text("Installed")
                        .frame(width: 60, alignment: .leading)
                    Text("Status").frame(width: 90, alignment: .leading)
                    Text("Version").frame(width: 75, alignment: .leading)
                    Text("Operations").frame(width: 180, alignment: .leading)
                }
                .frame(width: 550, height: 15)
                .foregroundColor(Color("maintext"))

                // nginx
                HStack {
                    Text("Nginx")
                        .frame(width: 60, alignment: .leading)
                    HStack {
                        if serverObj.nginx.installed {
                            Image("tick").resizable()
                                .interpolation(.high)
                                .frame(width: 13, height: 10)
                        } else {
                            Image("cross").resizable()
                                .interpolation(.high)
                                .frame(width: 11, height: 11)
                        }
                    }
                    .frame(width: 60, alignment: .leading)

                    HStack(spacing: 5) {
                        if serverObj.nginx.status == "Running" {
                            Circle().fill(Color("healthy"))
                                .frame(width: 10, height: 10)
                            Text("Running").foregroundColor(Color("healthy"))
                        } else if serverObj.nginx.status == "Stopped" {
                            Circle().fill(Color("danger"))
                                .frame(width: 10, height: 10)
                            Text("Stopped").foregroundColor(Color("danger"))
                        } else if serverObj.nginx.status == "Error" {
                            Circle().fill(Color("danger"))
                                .frame(width: 10, height: 10)
                            Text("Error").foregroundColor(Color("danger"))
                        } else {
                            Circle().fill(Color("danger"))
                                .frame(width: 10, height: 10)
                            Text("Not Intalled").foregroundColor(Color("danger"))
                        }

                    }.frame(width: 90, alignment: .leading)
                    HStack(spacing: 5) {
                        Text(serverObj.nginx.version)
                        // Triangle().fill(Color("info")).frame(width: 10, height: 10)
                    }.frame(width: 75, alignment: .leading)

                    HStack {
                        if serverObj.nginx.installed {
                            if serverObj.nginx.status == "Running" {
                                Text("stop").frame(width: 45, height: 22)
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        serverObj.loading = true
                                        runGengShell(log: self.$consoleInfoPipe).nginxStop {
                                            serverObj.nginx.status = "Stopped"
                                            serverObj.loading = false
                                            print("stopped")
                                        }
                                    }
                                    .foregroundColor(Color.white)
                                    .background(Color("danger"))
                                    .cornerRadius(5)
                            }

                            if serverObj.nginx.status == "Stopped" {
                                Text("start").frame(width: 45, height: 22)
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        serverObj.loading = true
                                        runGengShell(log: self.$consoleInfoPipe).nginxStart {
                                            serverObj.nginx.status = "Running"
                                            serverObj.loading = false
                                            print("started")
                                        }
                                    }
                                    .foregroundColor(Color.white)
                                    .background(Color("main4"))
                                    .cornerRadius(5)
                            }

                            Text("restart").frame(width: 60, height: 22)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    serverObj.loading = true
                                    runGengShell(log: self.$consoleInfoPipe).nginxStop {
                                        serverObj.nginx.status = "Stopped"
                                        runGengShell(log: self.$consoleInfoPipe).nginxStart {
                                            serverObj.nginx.status = "Running"
                                            serverObj.loading = false
                                        }
                                    }
                                }
                                .foregroundColor(Color.white)
                                .background(Color("main4"))
                                .cornerRadius(5)
                            Text("Setting").frame(width: 65, height: 22)
                                .foregroundColor(Color.white)
                                .background(Color("info"))
                                .cornerRadius(5)
                        }

                    }.frame(width: 180, alignment: .leading)
                }
                .frame(width: 550, height: 20)
                .foregroundColor(Color.white)

                // php
                HStack {
                    Text("Php")
                        .frame(width: 60, alignment: .leading)
                    HStack {
                        if serverObj.php.installed {
                            Image("tick").resizable()
                                .interpolation(.high)
                                .frame(width: 13, height: 10)
                        } else {
                            Image("cross").resizable()
                                .interpolation(.high)
                                .frame(width: 11, height: 11)
                        }
                    }
                    .frame(width: 60, alignment: .leading)

                    HStack(spacing: 5) {
                        if serverObj.php.status == "Running" {
                            Circle().fill(Color("healthy"))
                                .frame(width: 10, height: 10)
                            Text("Running").foregroundColor(Color("healthy"))
                        } else if serverObj.php.status == "Stopped" {
                            Circle().fill(Color("danger"))
                                .frame(width: 10, height: 10)
                            Text("Stopped").foregroundColor(Color("danger"))
                        } else if serverObj.php.status == "Error" {
                            Circle().fill(Color("danger"))
                                .frame(width: 10, height: 10)
                            Text("Error").foregroundColor(Color("danger"))
                        } else {
                            Circle().fill(Color("danger"))
                                .frame(width: 10, height: 10)
                            Text("Not Intalled").foregroundColor(Color("danger"))
                        }

                    }.frame(width: 90, alignment: .leading)
                    HStack(spacing: 5) {
                        // Text(serverObj.php.version)

                        Menu(serverObj.php.version.1) {
                            ForEach(serverObj.php.versionBrewList, id: \.self) { i in

                                // key for brew php,php@7.4
                                // value for display 7.4.2, 8.0.2

                                let key = Array(i.keys)[0]
                                let value = Array(i.values)[0]
                                Button("\(value)") {
                                    serverObj.loading = true
                                    runGengShell(log: self.$consoleInfoPipe).phpSwitch(currentVersion: serverObj.php.version, targetVersion: (key, value)) {
                                        serverObj.php.status = "Running"
                                        serverObj.php.version = (key, value)
                                        serverObj.loading = false
                                    }
                                }
                            }
                        }
                        .menuStyle(gengMenu())
                        .frame(width: 65)
                        .cornerRadius(3)

                    }.frame(width: 75, alignment: .leading)

                    HStack {
                        if serverObj.php.installed {
                            if serverObj.php.status == "Running" {
                                Text("stop").frame(width: 45, height: 22)
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        serverObj.loading = true
             
                                        runGengShell(log: self.$consoleInfoPipe).runCode("brew services stop \(serverObj.php.version.0)") {
                                            serverObj.php.status = "Stopped"
                                            serverObj.loading = false
                                            print("\(serverObj.php.version.0) stopped")
                                        }
                                    }
                                    .foregroundColor(Color.white)
                                    .background(Color("danger"))
                                    .cornerRadius(5)
                            }

                            if serverObj.php.status == "Stopped" {
                                Text("start").frame(width: 45, height: 22)
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        serverObj.loading = true
                                        runGengShell(log: self.$consoleInfoPipe).phpStart {
                                            serverObj.php.status = "Running"
                                            serverObj.loading = false
                                            print("started")
                                        }
                                    }
                                    .foregroundColor(Color.white)
                                    .background(Color("main4"))
                                    .cornerRadius(5)
                            }

                            Text("restart").frame(width: 60, height: 22)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    serverObj.loading = true
                                    runGengShell(log: self.$consoleInfoPipe).phpStop {
                                        serverObj.php.status = "Stopped"
                                        runGengShell(log: self.$consoleInfoPipe).phpStart {
                                            serverObj.php.status = "Running"
                                            serverObj.loading = false
                                        }
                                    }
                                }
                                .foregroundColor(Color.white)
                                .background(Color("main4"))
                                .cornerRadius(5)
                            Text("Setting").frame(width: 65, height: 22)
                                .foregroundColor(Color.white)
                                .background(Color("info"))
                                .cornerRadius(5)
                        }

                    }.frame(width: 180, alignment: .leading)
                }
                .frame(width: 550, height: 20)
                .foregroundColor(Color.white)

                // mysql
                HStack {
                    Text("Mysql")
                        .frame(width: 60, alignment: .leading)
                    HStack {
                        if serverObj.mysql.installed {
                            Image("tick").resizable()
                                .interpolation(.high)
                                .frame(width: 13, height: 10)
                        } else {
                            Image("cross").resizable()
                                .interpolation(.high)
                                .frame(width: 11, height: 11)
                        }
                    }
                    .frame(width: 60, alignment: .leading)

                    HStack(spacing: 5) {
                        if serverObj.mysql.status == "Running" {
                            Circle().fill(Color("healthy"))
                                .frame(width: 10, height: 10)
                            Text("Running").foregroundColor(Color("healthy"))
                        } else if serverObj.mysql.status == "Stopped" {
                            Circle().fill(Color("danger"))
                                .frame(width: 10, height: 10)
                            Text("Stopped").foregroundColor(Color("danger"))
                        }else if serverObj.mysql.status == "Error" {
                            Circle().fill(Color("danger"))
                                .frame(width: 10, height: 10)
                            Text("Error").foregroundColor(Color("danger"))
                        } else {
                            Circle().fill(Color("danger"))
                                .frame(width: 10, height: 10)
                            Text("Not Intalled").foregroundColor(Color("danger"))
                        }

                    }.frame(width: 90, alignment: .leading)
                    HStack(spacing: 5) {
                        Text(serverObj.mysql.version)
                        // Triangle().fill(Color("info")).frame(width: 10, height: 10)
                    }.frame(width: 75, alignment: .leading)

                    HStack {
                        if serverObj.mysql.installed {
                            if serverObj.mysql.status == "Running" {
                                Text("stop").frame(width: 45, height: 22)
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        serverObj.loading = true
                                        runGengShell(log: self.$consoleInfoPipe).mysqlStop {
                                            serverObj.mysql.status = "Stopped"
                                            serverObj.loading = false
                                            print("stopped")
                                        }
                                    }
                                    .foregroundColor(Color.white)
                                    .background(Color("danger"))
                                    .cornerRadius(5)
                            }

                            if serverObj.mysql.status == "Stopped" {
                                Text("start").frame(width: 45, height: 22)
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        serverObj.loading = true
                                        runGengShell(log: self.$consoleInfoPipe).mysqlStart {
                                            serverObj.mysql.status = "Running"
                                            serverObj.loading = false
                                            print("started")
                                        }
                                    }
                                    .foregroundColor(Color.white)
                                    .background(Color("main4"))
                                    .cornerRadius(5)
                            }

                            Text("restart").frame(width: 60, height: 22)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    serverObj.loading = true
                                    runGengShell(log: self.$consoleInfoPipe).mysqlStop {
                                        serverObj.mysql.status = "Stopped"
                                        runGengShell(log: self.$consoleInfoPipe).mysqlStart {
                                            serverObj.mysql.status = "Running"
                                            serverObj.loading = false
                                        }
                                    }
                                }
                                .foregroundColor(Color.white)
                                .background(Color("main4"))
                                .cornerRadius(5)
                            Text("Setting").frame(width: 65, height: 22)
                                .foregroundColor(Color.white)
                                .background(Color("info"))
                                .cornerRadius(5)
                        }

                    }.frame(width: 180, alignment: .leading)
                }
                .frame(width: 550, height: 20)
                .foregroundColor(Color.white)
                Spacer()
                Spacer()
                    .frame(width: 550, height: 1)

                // end
            }
            .frame(width: 550, height: 200)
            .background(Color("mainbg"))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 4)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 15, trailing: 0))

            HStack {
                Text("Log")
                    .foregroundColor(Color("maintext"))
                Spacer()
                Text("Clear").frame(width: 65, height: 25)
                    .contentShape(Rectangle())
                    .onTapGesture(
                        perform: {
                            self.consoleInfoPipe = ""
                        }
                    )
                    .foregroundColor(Color.white)
                    .background(Color("main4"))
                    .cornerRadius(5)

            }.frame(width: 550, height: 28)
            VStack {
                ScrollViewReader { proxy in
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 3) {
                            Text(self.consoleInfoPipe).foregroundColor(Color.white)

                            Spacer().frame(width: 1, height: 1).id(bottomID)
                        }
                        .onChange(of: self.consoleInfoPipe, perform: {
                            _ in

                            let rowCount = self.consoleInfoPipe.filter { $0 == "\n" }.count
                            if rowCount > 6 {
                                proxy.scrollTo(bottomID, anchor: .top)
                            }
                        })
                        .frame(width: 500, alignment: .topLeading)
                    }.frame(width: 500, height: 105, alignment: .topLeading)
                }
            }
            .frame(width: 550, height: 140)
            .background(Color("mainbg"))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 4)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))

        }.padding(EdgeInsets(top: 40, leading: 50, bottom: 30, trailing: 50))
            .frame(width: 620, height: 500)
    }
}
