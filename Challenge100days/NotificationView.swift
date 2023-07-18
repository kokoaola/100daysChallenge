//
//  Notification.swift
//  Challenge100days
//
//  Created by koala panda on 2023/07/16.
//

import SwiftUI
import UserNotifications



struct NotificationView: View {
    @State private var isNotificationEnabled = false
    let center = UNUserNotificationCenter.current()
    @State private var time = Date.now
    @State private var day: Set<String> = []
    @State private var notificationON = true
    @State private var ooo = 0
    
    @State private var week = ["月", "火", "水", "木", "金", "土", "日"]
    
    
    @State var datas = ["item1", "item2", "item3"]
    @State var itemsSelection:Set = ["月", "火", "水", "木", "金", "土", "日"]
    @State var itemSelection:String?
    
    var body: some View {
        
        VStack {
            //Toggle("通知を有効にする", isOn: $notificationON)
              //  .padding(.horizontal)

            
            Group{
                
                        //.offset(x:-30)
                    DatePicker("", selection: $time, displayedComponents: .hourAndMinute)
                    .datePickerStyle(.wheel)
//                        .padding(.horizontal, 20)
//                        .frame(height: 120)

                
                
//                Picker("AA", selection: $ooo){
//                    Text("毎日通知")
//                        .tag(0)
//                    Text("曜日で指定")
//                        .tag(1)
//                }
//                .pickerStyle(.segmented)
//                .padding(.horizontal, 20)
                
                
                Text("※その日のタスクが完了していない場合のみ、通知が送信されます")
                    .font(.caption)
                
                List(selection: $itemsSelection){
                    ForEach(week, id: \.self) { str in
                        Text("\(str)")
                    }
                }
                .scrollContentBackground(.hidden)
                .environment(\.editMode, .constant(.active))
                .tint(.green)
                
            }
            

            
            Button("決定") {
                
            }
            .buttonStyle(.borderedProminent)
            
        }
    }
    
    
    
    
    
    
    //                }
    //                .disabled(!notificationON)
    
    
    
    
    //        .onAppear{
    //            print("P")
    //            center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
    //                if let error = error {
    //                    print(error.localizedDescription)
    //                }
    //
    //                if success {
    //                    print("All set!")
    //                    isNotificationEnabled = true
    //                }else {
    //                    print("!")
    //                    isNotificationEnabled = false
    //                }
    //            }
    //
    //            center.getNotificationSettings { settings in
    //                if settings.authorizationStatus == .authorized {
    //                    // 通知が許可されています
    //                    isNotificationEnabled = true
    //                } else {
    ////                    // 通知が許可されていません
    ////                    if let url = URL(string: UIApplication.openSettingsURLString) {
    ////                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    ////                    }
    //                }
    //            }
    //        }
    
    //        Button {
    //            // Create the URL that deep links to your app's notification settings.
    //            if let url = URL(string: UIApplication.openNotificationSettingsURLString) {
    //                // Ask the system to open that URL.
    //                await UIApplication.shared.open(url)
    //            }
    //        } label: {
    //            Text("A")
    //        }
    
    
}


struct Notification_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
    }
}
