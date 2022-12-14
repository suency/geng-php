//
//  home.swift
//  genglearn
//
//  Created by geng on 2022/12/13.
//

import Foundation
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

@discardableResult
func shell(_ args: [String]) -> String {
    let task = Process()
    task.launchPath = "/usr/bin/env"
    task.arguments = args
    let pipe = Pipe()
    task.standardOutput = pipe
    task.launch()
    task.waitUntilExit()
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output: String = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
    return output;
}

struct home: View {
    @State var consoleInfo:[String] = ["Nginx started successfully!"]
    var body: some View {
        VStack {
            HStack {
                Text("Panel")
                    .foregroundColor(Color("maintext"))
                Spacer()
                Text("install").frame(width: 65, height: 20)
                    .onTapGesture(perform: {
                        print(shell(["pwd"]));
                        self.consoleInfo.append(shell(["pwd"]))
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
                    Text("Version").frame(width: 60, alignment: .leading)
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
                        Circle().fill(Color("healthy"))
                            .frame(width: 10, height: 10)
                        Text("Running").foregroundColor(Color("healthy"))
                    }.frame(width: 90, alignment: .leading)
                    HStack(spacing: 5) {
                        Text("1.22.1")
                        Triangle()
                            .fill(Color("info"))
                            .frame(width: 10, height: 10)
                    }.frame(width: 60, alignment: .leading)

                    HStack {
                        Text("stop").frame(width: 45, height: 20)
                            .foregroundColor(Color.white)
                            .background(Color("danger"))
                            .cornerRadius(5)
                        Text("restart").frame(width: 60, height: 20)
                            .foregroundColor(Color.white)
                            .background(Color("main4"))
                            .cornerRadius(5)
                        Text("Setting").frame(width: 65, height: 20)
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
                    }.frame(width: 60, alignment: .leading)

                    HStack {
                        Text("start").frame(width: 45, height: 20)
                            .foregroundColor(Color.white)
                            .background(Color("main4"))
                            .cornerRadius(5)
                        Text("restart").frame(width: 60, height: 20)
                            .foregroundColor(Color.white)
                            .background(Color("main4"))
                            .cornerRadius(5)
                        Text("Setting").frame(width: 65, height: 20)
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
            }.frame(width: 550, height: 28)
            VStack {
                ScrollView(showsIndicators: false){
                    VStack(spacing:3){
                        
                        ForEach(self.consoleInfo,id:\.self){
                            item in
                            Text(item)
                        }
                        
                    }.frame(width: 500, alignment: .topLeading)
                }.frame(width: 500, height: 105,alignment: .topLeading)
                
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
