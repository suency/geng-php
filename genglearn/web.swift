//
//  web.swift
//  genglearn
//
//  Created by geng on 2022/12/13.
//

import Foundation
import SwiftUI

struct web: View {
    @EnvironmentObject var serverObj: ServerModel
    @EnvironmentObject var websiteObj: websiteModel
    @State var consoleInfoPipe: String = ""


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
                        print("hehe")
                        nginxParser.conf_to_json()
                    }
                    .foregroundColor(Color.white)
                    .background(Color("main4"))
                    .cornerRadius(5)

                Text("Add").frame(width: 65, height: 25)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        let randInt = Int.random(in: 8080..<65500)
                        
                        let newItem = webItem(port: "\(randInt)",rootDir: "\(homePath)/gengphp")
                        self.websiteObj.data.append(newItem)
                        
                    }
                    .foregroundColor(Color.white)
                    .background(Color("main4"))
                    .cornerRadius(5)
                Text("Save").frame(width: 65, height: 25)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        print(self.websiteObj.data)
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
    }

    func selectDir() {
        let dialog = NSOpenPanel()

        dialog.title = "Choose a file| Our Code World"
        dialog.showsResizeIndicator = true
        dialog.showsHiddenFiles = false
        dialog.allowsMultipleSelection = false
        dialog.canChooseDirectories = false

        if dialog.runModal() == NSApplication.ModalResponse.OK {
            let result = dialog.url // Pathname of the file

            if result != nil {
                let path: String = result!.path

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
