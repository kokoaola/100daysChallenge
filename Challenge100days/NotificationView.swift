//
//  Notification.swift
//  Challenge100days
//
//  Created by koala panda on 2023/07/16.
//

import SwiftUI
import UserNotifications



struct NotificationView: View {
    let center = UNUserNotificationCenter.current()
    @State private var time = Date.now
    @State private var day: Set<String> = []
    ///画面破棄用
    @Environment(\.dismiss) var dismiss
    @State private var week = ["月", "火", "水", "木", "金", "土", "日"]
    
    
    @State var datas = ["item1", "item2", "item3"]
    @State var itemsSelection:Set = ["月", "火", "水", "木", "金", "土", "日"]
    @State var itemSelection:String?
    
    var body: some View {
        
        VStack{
            DatePicker("", selection: $time, displayedComponents: .hourAndMinute)
                .datePickerStyle(.wheel)
                .labelsHidden()
                .frame(height: 150)
            
            List(selection: $itemsSelection){
                Section(header: Text("通知を出す曜日")){
                    ForEach(week, id: \.self) { str in
                        Text("\(str)")
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .environment(\.editMode, .constant(.active))
            .tint(.green)
            
            
            Button {
                dismiss()
            } label: {
                okButton()
                    .foregroundColor(.green)
                    .padding(.bottom)
            }
        }
    }
    
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
