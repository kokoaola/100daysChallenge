//
//  Notification.swift
//  Challenge100days
//
//  Created by koala panda on 2023/07/16.
//

import SwiftUI

///通知設定するビュー
struct NotificationView: View {
    ///ViewModel用の変数
    @EnvironmentObject var notificationViewModel :NotificationViewModel
    @EnvironmentObject var coreDataViewModel :CoreDataViewModel
    
    ///トーストの表示状態を格納するフラグ
    @Binding var showToast: Bool
    
    ///トースト内に表示する文章を格納する変数
    @Binding var toastText: String
    
    ///画面破棄用
    @Environment(\.dismiss) var dismiss
    
    ///一週間分の要素を生成
    let week = Array(1...7)
    
    
    var body: some View {
        
        ZStack{
            VStack{
                //通知を受信する時間選択用のピッカー
                DatePicker("", selection: $notificationViewModel.userSettingNotificationTime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                    .frame(height: 150)
                
                //通知を受信する曜日選択用のリスト
                List(selection: $notificationViewModel.userSettingNotificationDay){
                    Section(header: Text("通知を出す曜日")){
                        ForEach(week, id: \.self) { item in
                            numToDate(num:item)
                        }
                    }
                }
                .scrollDisabled(true)
                .scrollContentBackground(.hidden)
                .environment(\.editMode, .constant(.active))
                .tint(.green)
                
                //保存ボタン
                Button {
                    Task{
                        await notificationViewModel.setNotification(item: coreDataViewModel.allData.last)
                    }
                    //トーストを表示して画面破棄
                    toastText = "通知を設定しました。"
                    showToast = true
                    dismiss()
                    
                } label: {
                    LeftIconBigButton(icon: nil, text: "決定")
                        .foregroundColor(.green)
                        .padding(.bottom)
                }
            }

        }
    }
    
    //日本語表示用のメソッド
    private func numToDate(num: Int) -> some View{
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
    @State static var showToast = false
    @State static var toastText = ""
    static var previews: some View {
        Group{
            NotificationView(showToast: $showToast, toastText: $toastText)
                .environment(\.locale, Locale(identifier:"en"))
            
            NotificationView(showToast: $showToast, toastText: $toastText)
                .environment(\.locale, Locale(identifier:"ja"))
        }
        .environmentObject(NotificationViewModel())
        .environmentObject(CoreDataViewModel())
    }
}
