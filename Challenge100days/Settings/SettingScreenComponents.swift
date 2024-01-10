//
//  SettingScreenComponents.swift
//  Challenge100days
//
//  Created by koala panda on 2024/01/10.
//

import SwiftUI

struct NotificationRow: View {
    var time: String = ""
    var date: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("通知を設定する")
            
            HStack{
                Text("現在の設定 : ")
                Text(LocalizedStringKey(time))
            }.font(.callout).foregroundColor(.gray)
            
            Text("[\(date)]").font(.callout).foregroundColor(.gray)
        }
    }
}
