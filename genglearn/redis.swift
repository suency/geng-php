//
//  redis.swift
//  genglearn
//
//  Created by geng on 2022/12/13.
//

import Foundation
import SwiftUI

struct redis:View{
    var body: some View{
        VStack{

            VStack{
                Text("redis control panel is in developing")
                    .foregroundColor(Color("maintext"))
            }
            .frame(width: 560,height: 140)
            .background(Color("mainbg"))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 4)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            
        }.padding(EdgeInsets(top: 50, leading: 50, bottom: 30, trailing: 50))
        .frame(width: 620,height: 500)
    }
}
