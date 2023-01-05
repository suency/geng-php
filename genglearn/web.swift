//
//  web.swift
//  genglearn
//
//  Created by geng on 2022/12/13.
//

import Foundation
import SwiftUI
import SwiftyJSON

struct web: View {
    @EnvironmentObject var serverObj: ServerModel
    @EnvironmentObject var websiteObj: websiteModel
    @State var consoleInfoPipe: String = ""
    @State var submitData :JSON = ["server":[]]

    func initConfig() {
        let resJson = nginxParser(chipModel: serverObj.chipModel).conf_to_json()

        // if json is ok
        if resJson != "undefined" {
            if let dataFromString = resJson.data(using: .utf8, allowLossyConversion: false) {
                let json = try? JSON(data: dataFromString)

                websiteObj.data = []
                // add existing websites

                for item in json!["server"] {
                    let newItem = webItem(port: item.1["listen"].string!, rootDir: item.1["root"].string!)
                    websiteObj.data.append(newItem)
                }
            }

        } else {
            // error undefined
            // print(resJson)
        }
    }

    var body: some View {
        VStack {
            HStack {
                Text("Websites")
                    .foregroundColor(Color("maintext"))
                Spacer()
                Spacer()
                Text("Reset").frame(width: 65, height: 25)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        initConfig()
                    }
                    .foregroundColor(Color.white)
                    .background(Color("main4"))
                    .cornerRadius(5)

                Text("Add").frame(width: 65, height: 25)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        let randInt = Int.random(in: 8080 ..< 65500)

                        let newItem = webItem(port: "\(randInt)", rootDir: "\(homePath)/Desktop/gengphp")
                        self.websiteObj.data.append(newItem)
                    }
                    .foregroundColor(Color.white)
                    .background(Color("main4"))
                    .cornerRadius(5)
                Text("Save").frame(width: 65, height: 25)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        print(nginxParser(chipModel: serverObj.chipModel).json_to_conf(json: submitData.rawString()!))
                    }
                    .foregroundColor(Color.white)
                    .background(Color("nginx"))
                    .cornerRadius(5)
            }

            ScrollView(showsIndicators: false) {
                VStack {
                    HStack {
                        Text("Manage Websites:")
                            .foregroundColor(Color("maintext"))
                        Spacer()
                    }
                    Form {
                        ForEach(self.websiteObj.data.indices, id: \.self) { index in
                            HStack {
                                TextField("", text: $websiteObj.data[index].port)

                                    .placeholder(when: websiteObj.data[index].port.isEmpty) {
                                        Text("Port").foregroundColor(Color("maintext"))
                                    }
                                    .padding(EdgeInsets(top: 8, leading: 2, bottom: 8, trailing: 8))
                                    .foregroundColor(Color("healthy"))
                                    .frame(width: 60)
                                    .background(Color("inputbg"))
                                    .cornerRadius(5)
                                    .textFieldStyle(PlainTextFieldStyle())

                                TextField("", text: $websiteObj.data[index].hostname)
                                    .disabled(true)

                                    .padding(EdgeInsets(top: 8, leading: 2, bottom: 8, trailing: 8))
                                    .foregroundColor(Color("healthy"))
                                    .frame(width: 100)
                                    .background(Color("inputbg"))
                                    .cornerRadius(5)
                                    .textFieldStyle(PlainTextFieldStyle())

                                TextField("", text: $websiteObj.data[index].rootDir)

                                    .padding(EdgeInsets(top: 8, leading: 2, bottom: 8, trailing: 8))
                                    .foregroundColor(Color("healthy"))
                                    .background(Color("inputbg"))
                                    .cornerRadius(5)
                                    .textFieldStyle(PlainTextFieldStyle())

                                Text("Select").frame(width: 55, height: 31)
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        selectDir(index:index)
                                    }
                                    .foregroundColor(Color.white)
                                    .background(Color("main4"))
                                    .cornerRadius(5)

                                Text("Delete").frame(width: 55, height: 31)
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        print("hehe")
                                    }
                                    .foregroundColor(Color.white)
                                    .background(Color("danger"))
                                    .cornerRadius(5)
                            }
                        }
                        /*
                         ForEach(Array(self.webObj.enumerated()), id: \.element) { index, element in
                             HStack {

                                 TextField("", text: binding(for: "port", index: index))
                                     .placeholder(when: webObj[index]["port"]!.isEmpty) {
                                         Text("Port").foregroundColor(Color("maintext"))
                                     }
                                     .padding(EdgeInsets(top: 8, leading: 2, bottom: 8, trailing: 8))
                                     .foregroundColor(Color("healthy"))
                                     .frame(width: 60)
                                     .background(Color("inputbg"))
                                     .cornerRadius(5)
                                     .textFieldStyle(PlainTextFieldStyle())

                                 TextField("", text: binding(for: "hostname", index: index))
                                     .placeholder(when: webObj[index]["hostname"]!.isEmpty) {
                                         Text("localhost").foregroundColor(Color("maintext"))
                                     }.disabled(true)

                                     .padding(EdgeInsets(top: 8, leading: 2, bottom: 8, trailing: 8))
                                     .foregroundColor(Color("healthy"))
                                     .frame(width: 100)
                                     .background(Color("inputbg"))
                                     .cornerRadius(5)
                                     .textFieldStyle(PlainTextFieldStyle())

                                 TextField("", text: binding(for: "rootDir", index: index))

                                     .placeholder(when: webObj[index]["rootDir"]!.isEmpty) {
                                         Text("Select your root dicectory").foregroundColor(Color("maintext"))
                                     }
                                     .padding(EdgeInsets(top: 8, leading: 2, bottom: 8, trailing: 8))
                                     .foregroundColor(Color("healthy"))
                                     .background(Color("inputbg"))
                                     .cornerRadius(5)
                                     .textFieldStyle(PlainTextFieldStyle())

                                 Text("Select").frame(width: 55, height: 31)
                                     .contentShape(Rectangle())
                                     .onTapGesture {
                                         selectDir()
                                     }
                                     .foregroundColor(Color.white)
                                     .background(Color("main4"))
                                     .cornerRadius(5)

                                 Text("Delete").frame(width: 55, height: 31)
                                     .contentShape(Rectangle())
                                     .onTapGesture {
                                         print("hehe")
                                     }
                                     .foregroundColor(Color.white)
                                     .background(Color("danger"))
                                     .cornerRadius(5)
                             }
                         }

                         */
                    }
                    .onChange(of: websiteObj.data) { _ in
                        let basicNginx = nginxParser(chipModel: serverObj.chipModel).conf_to_json_basic()
                        // var finalRusult = JSON(basicNginx)
                        var finalJson :JSON = ["server":[]]

                        if let dataFromString = basicNginx.data(using: .utf8, allowLossyConversion: false) {
                            var json = try? JSON(data: dataFromString)
                            for item in websiteObj.data {
                                
                                json!["server"][0]["listen"] = JSON(stringLiteral: item.port)
                                
                                json!["server"][0]["root"] = JSON(stringLiteral: item.rootDir)
                                
                                json!["server"][0]["server_name"] = JSON(stringLiteral: item.hostname)
                                
                                finalJson["server"].arrayObject = finalJson["server"].arrayObject! + json!["server"].arrayObject!
                                
                            }
                        }
                        
                        submitData = finalJson
                        //print(submitData)
                    }
                }
                .padding(20)
                .frame(width: 560, height: 440, alignment: .topLeading)
                .background(Color("mainbg"))
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 4)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            }

        }.padding(EdgeInsets(top: 50, leading: 50, bottom: 30, trailing: 50))
            .frame(width: 620, height: 500)
            .onAppear {
                self.initConfig()
            }
    }

    func selectDir(index:Int) {
        let dialog = NSOpenPanel()

        dialog.title = "Choose a Directory"
        dialog.showsResizeIndicator = true
        dialog.showsHiddenFiles = false
        dialog.allowsMultipleSelection = false
        dialog.canChooseDirectories = true
        dialog.canChooseFiles = false

        if dialog.runModal() == NSApplication.ModalResponse.OK {
            let result = dialog.url // Pathname of the file

            if result != nil {
                let path: String = result!.path
                
                self.websiteObj.data[index].rootDir = path
                print(path)
                // path contains the file path e.g
                // /Users/ourcodeworld/Desktop/file.txt
            }

        } else {
            // User clicked on "Cancel"
            return
        }
    }
}
