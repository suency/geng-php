//
//  home.swift
//  genglearn
//
//  Created by geng on 2022/12/13.
//

import Foundation
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
                Text(logoContent)
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
    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 12) {
                installItem(logo: "nginx", logoContent: "nginx", logoColor: "nginx", hoverText: "install", installAction: {})
                installItem(logo: "php", logoContent: "Php", logoColor: "php", hoverText: "install", installAction: {})
                installItem(logo: "mysql", logoContent: "Mysql", logoColor: "mysql", hoverText: "install", installAction: {})
                installItem(logo: "apache", logoContent: "Apache", logoColor: "apache", hoverText: "install", installAction: {})
            }
            HStack(spacing: 12) {
                installItem(logo: "brew", logoContent: "brewOri", logoColor: "brew", hoverText: "install", installAction: {})
                installItem(logo: "brew", logoContent: "brewMir", logoColor: "mirror", hoverText: "install", installAction: {})
                installItem(logo: "origin", logoContent: "Origin", logoColor: "main4", hoverText: "change", installAction: {})
                installItem(logo: "mirror", logoContent: "Mirror", logoColor: "mirror", hoverText: "change", installAction: {})
            }
            Text("Close")
                .frame(width: 100, height: 30)
                .contentShape(Rectangle())
                .onTapGesture(perform: {
                    self.showInstall = false
                })
                .background(Color("main4"))
                .cornerRadius(10)
        }
        .frame(width: 300, height: 200)
        .background(Color("mainbg"))
    }
}

struct showInstallPreview: PreviewProvider {
    @State static var showInstall = false
    static var previews: some View {
        VStack {
            HStack {
                installModel(showInstall: $showInstall)
            }
        }
    }
}

struct home: View {
    // @State var consoleInfo: [String] = []
    @State var consoleInfoPipe: String = ""
    @State var showInstall = false
    @State var showFullScreenLoading = false
    @EnvironmentObject var serverObj:ServerModel
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
                        
                        //runGengShell(log: self.$consoleInfoPipe).checkLocalBrew()
                        //runGengShell(log: self.$consoleInfoPipe).nginxStart()
                        //runGengShell(log: self.$consoleInfoPipe).pingTest()
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
                                installModel(showInstall: $showInstall)
                            }
                        }
                        .frame(width: 300, height: 200)
                        .background(Color("mainbg"))
                    })
                    .foregroundColor(Color.white)
                    .background(Color("main4"))
                    .cornerRadius(5)

            }.frame(width: 550, height: 28)
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

                HStack {
                    Text("Nginx")
                        .frame(width: 60, alignment: .leading)
                    HStack {
                        Image("tick").resizable()
                            .interpolation(.high)
                            .frame(width: 13, height: 10)
                    }
                    .frame(width: 60, alignment: .leading)

                    HStack(spacing: 5) {
                        
                        if serverObj.nginx.status == "Running" {
                            Circle().fill(Color("healthy"))
                                .frame(width: 10, height: 10)
                            Text("Running").foregroundColor(Color("healthy"))
                        }
                        
                        if serverObj.nginx.status == "Stopped" {
                            Circle().fill(Color("danger"))
                                .frame(width: 10, height: 10)
                            Text("Stopped").foregroundColor(Color("danger"))
                        }
                        
                    }.frame(width: 90, alignment: .leading)
                    HStack(spacing: 5) {
                        Text(serverObj.nginx.version)
                        Triangle()
                            .fill(Color("info"))
                            .frame(width: 10, height: 10)
                    }.frame(width: 75, alignment: .leading)

                    HStack {
                        if serverObj.nginx.status == "Running" {
                            Text("stop").frame(width: 45, height: 22)
                                .contentShape(Rectangle())
                                .onTapGesture{
                                    serverObj.loading = true
                                    runGengShell(log: self.$consoleInfoPipe).nginxStop{
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
                                .onTapGesture{
                                    serverObj.loading = true
                                    runGengShell(log: self.$consoleInfoPipe).nginxStart{
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
                            .foregroundColor(Color.white)
                            .background(Color("main4"))
                            .cornerRadius(5)
                        Text("Setting").frame(width: 65, height: 22)
                            .foregroundColor(Color.white)
                            .background(Color("info"))
                            .cornerRadius(5)

                    }.frame(width: 180, alignment: .leading)
                }
                .frame(width: 550, height: 20)
                .foregroundColor(Color.white)

                HStack {
                    Text("Php")
                        .frame(width: 60, alignment: .leading)
                    HStack {
                        Image("cross").resizable()
                            .interpolation(.high)
                            .frame(width: 11, height: 11)
                    }
                    .frame(width: 60, alignment: .leading)

                    HStack(spacing: 5) {
                        Circle().fill(Color("danger"))
                            .frame(width: 10, height: 10)
                        Text("Stopped").foregroundColor(Color("danger"))
                    }.frame(width: 90, alignment: .leading)
                    HStack(spacing: 5) {
                        Text("8.0.25")
                        Triangle()
                            .fill(Color("info"))
                            .frame(width: 10, height: 10)
                    }.frame(width: 75, alignment: .leading)

                    HStack {
                        Text("start").frame(width: 45, height: 22)
                            .foregroundColor(Color.white)
                            .background(Color("main4"))
                            .cornerRadius(5)
                        Text("restart").frame(width: 60, height: 22)
                            .foregroundColor(Color.white)
                            .background(Color("main4"))
                            .cornerRadius(5)
                        Text("Setting").frame(width: 65, height: 22)
                            .foregroundColor(Color.white)
                            .background(Color("info"))
                            .cornerRadius(5)

                    }.frame(width: 180, alignment: .leading)
                }
                .frame(width: 550, height: 20)
                .foregroundColor(Color.white)
                Spacer()
                Spacer()
                    .frame(width: 550, height: 1)
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
                            Text(self.consoleInfoPipe)

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
