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
                        Text("\(numToDate(num:item))")
                    }
                }
            }

            .scrollContentBackground(.hidden)
            .environment(\.editMode, .constant(.active))
            .tint(.green)
            
            
            Button {
                notificationViewModel.setNotification(item: items.last)
                print("通知は：\(notificationViewModel.isNotificationOn)")
                print("今日のタスクは\(notificationViewModel.checkTodaysTask(item: items.last))")
                    dismiss()
            } label: {
                okButton()
                    .foregroundColor(.green)
                    .padding(.bottom)
            }
        }

    }
    
    
    func numToDate(num: Int) -> String{
        switch num{
        case 1:
            return "日曜"
        case 2:
            return "月曜"
        case 3:
            return "火曜"
        case 4:
            return "水曜"
        case 5:
            return "木曜"
        case 6:
            return "金曜"
        case 7:
            return "土曜"
        default:
            return ""
        }
    }
}


struct Notification_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView().environmentObject(NotificationViewModel())
    }
}
