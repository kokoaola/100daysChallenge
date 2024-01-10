//
//  SettingScreenComponents.swift
//  Challenge100days
//
//  Created by koala panda on 2024/01/10.
//

import SwiftUI

struct NotificationRow: View {
    var notification: NotificationObject
    var isOn: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("通知を設定する")
            
            HStack{
                Text("現在の設定 : ")
                if isOn{
                    Text(notification.formattedTime)
                }else{
                    Text(LocalizedStringKey("なし"))
                }
            }.font(.callout).foregroundColor(.gray)
            
            if isOn{
                Text("[\(notification.formattedDate)]").font(.callout).foregroundColor(.gray)
            }
        }
    }
}
