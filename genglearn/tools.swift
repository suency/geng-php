//
//  tools.swift
//  genglearn
//
//  Created by geng on 2022/12/18.
//

import Foundation
import SwiftUI

struct fullLoading:View{
    @Binding var isDisplay:Bool
    var body: some View{
        ZStack{
            VStack{
                
            }.frame(width: 800,height: 500).opacity(0.2)
            ProgressView()
        }
        
    }
}

struct LoadingView: PreviewProvider {
    @State static var isLoading = false
    static var previews: some View {
        fullLoading(isDisplay:$isLoading)
    }
}

struct Tools {
    static func getBrewListData(_ testMystring:String)->[[String:String]]{
        
        let rows = testMystring.split(separator: "\n").map(String.init)
        
        let twoRows = rows.map{
            $0.split(separator: " ").map(String.init)
        }
        var finalResult:[[String:String]] = twoRows.map{
            Dictionary(uniqueKeysWithValues: zip(twoRows[0],$0))
        }
        
        if finalResult.count > 0 {
            finalResult.remove(at: 0)
            return finalResult
        } else {
            return [["Name":"FatalError"]]
        }
        
        
    }
}

extension String {
    
    func trim() -> String {
        var resultString = self.trimmingCharacters(in: CharacterSet.whitespaces)
        resultString = resultString.trimmingCharacters(in: CharacterSet.newlines)
        return resultString
    }

}
