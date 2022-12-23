//
//  gengComponents.swift
//  genglearn
//
//  Created by geng on 2022/12/23.
//

import Foundation
import SwiftUI

struct gengModalBrew:View {
    @Binding var log:String
    @Binding var showInstall:Bool
    @EnvironmentObject var serverObj: ServerModel
    var body: some View {
        VStack(spacing: 8){
            Text("You have not installed brew")
            Text("Please install first, CN is for China")
            HStack(spacing: 15) {
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
                
            }
            HStack{
                Text("Cancel")
                    .foregroundColor(.white)
                    .frame(width: 55, height: 25)
                    .contentShape(Rectangle())
                    .onTapGesture(perform: {
                        self.showInstall = false
                    })
                    .background(Color("main4"))
                    .cornerRadius(5)
                
                Text("Restart")
                    .foregroundColor(.white)
                    .frame(width: 70, height: 25)
                    .contentShape(Rectangle())
                    .onTapGesture(perform: {
                        self.showInstall = false
                        let filepath = Bundle.main.path(forResource: "scpt/restart", ofType: "scpt")
                        runGengShellApple(log: self.$log).runCode(filepath!) {
                            print("ok")
                        }
                    })
                    .background(Color("main4"))
                    .cornerRadius(5)
                
                Text("Fix Brew").frame(width: 80, height: 25)
                    .contentShape(Rectangle())
                    .onTapGesture(perform: {
                        let brewHome = serverObj.chipModel.contains(pattern: "x86") ? serverObj.x86BrewHome : serverObj.armBrewHome
                        let fixCode = "git config --global --add safe.directory \(brewHome)/Homebrew/Library/Taps/homebrew/homebrew-core;git config --global --add safe.directory \(brewHome)/Homebrew/Library/Taps/homebrew/homebrew-cask"
                        serverObj.loading = true
                        runGengShell(log: self.$log).runCode(fixCode) {
                            serverObj.loading = false
                            print("fixed")
                        }
                    })
                    .foregroundColor(Color.white)
                    .background(Color("main4"))
                    .cornerRadius(5)
            }
            
        }
        .foregroundColor(.white)
        .frame(width: 250,height: 180)
        .background(Color("mainbg"))
        .cornerRadius(10)
    }
}
