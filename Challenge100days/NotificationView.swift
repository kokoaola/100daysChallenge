//
//  Notification.swift
//  Challenge100days
//
//  Created by koala panda on 2023/07/16.
//

import SwiftUI

struct NotificationView: View {
    @EnvironmentObject var notificationViewModel :NotificationViewModel
    
    ///CoreData用の変数
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key:"date", ascending: true)]) var items: FetchedResults<DailyData>
    ///画面破棄用
    @Environment(\.dismiss) var dismiss

    let week = Array(1...7)

    
    var body: some View {
        
        
        VStack{
            DatePicker("", selection: $notificationViewModel.userSettingNotificationTime, displayedComponents: .hourAndMinute)
                .datePickerStyle(.wheel)
                .labelsHidden()
                .frame(height: 150)
            
            List(selection: $notificationViewModel.userSettingNotificationDay){
                Section(header: Text("通知を出す曜日")){
                    ForEach(week, id: \.self) { item in
                        numToDate(num:item)
                    }
                }
            }

            .scrollContentBackground(.hidden)
            .environment(\.editMode, .constant(.active))
            .tint(.green)
            .alert(isPresented: $notificationViewModel.showAlert) {
                Alert(title: Text("通知を設定しました。"),
                      dismissButton: .default(Text("OK"),
                                              action: {dismiss()
                })) // ボタンがタップされた時の処理
            }
            
            Button {
                notificationViewModel.setNotification(item: items.last)
                notificationViewModel.showAlert = true
            } label: {
                okButton()
                    .foregroundColor(.green)
                    .padding(.bottom)
            }
        }

    }
    

    func numToDate(num: Int) -> some View{
        switch num{
        case 1:
            return Text("日曜")
        case 2:
            return Text("月曜")
        case 3:
            return Text("火曜")
        case 4:
            return Text("水曜")
        case 5:
            return Text("木曜")
        case 6:
            return Text("金曜")
        case 7:
            return Text("土曜")
        default:
            return Text("")
        }
    }
}


struct Notification_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            NotificationView()
                .environment(\.locale, Locale(identifier:"en"))
            
            NotificationView()
                .environment(\.locale, Locale(identifier:"ja"))
        }
        .environmentObject(NotificationViewModel())
    }
}
