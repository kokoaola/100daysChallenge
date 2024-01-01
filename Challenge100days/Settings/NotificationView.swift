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
    @EnvironmentObject var globalStore: GlobalStore
    
    ///トーストの表示状態を格納するフラグ
    @Binding var showToast: Bool
    
    ///トースト内に表示する文章を格納する変数
    @Binding var toastText: String
    
    ///画面破棄用
    @Environment(\.dismiss) var dismiss
    
    ///バックグラウンド移行と復帰の環境値を監視する
    @Environment(\.scenePhase) var scenePhase
    
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
                        await notificationViewModel.setNotification(isFinishTodaysTask: globalStore.finishedTodaysTask)
                    }
                    //トーストを表示して画面破棄
                    toastText = "通知を設定しました。"
                    showToast = true
                    dismiss()
                    
                } label: {
                    LeftIconBigButton(color:.green, icon: nil, text: "決定")
                        .padding(.bottom)
                }
            }

        }
        .disabled(!notificationViewModel.isNotificationEnabled)
        .opacity(notificationViewModel.isNotificationEnabled ? 1.0 : 0.5)
        
        .onAppear{
            //タップ時に通知の許可を判定、許可されていれば画面遷移
            notificationViewModel.isUserNotificationEnabled()
        }
        //バックグラウンド復帰時に通知の状態を確認
        //これしないと通知OFFでも通知設定画面に遷移できてしまうため
        .onChange(of: scenePhase) { newPhase in
                notificationViewModel.isUserNotificationEnabled()
//            center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
//                if success {
//                    settingViewModel.isNotificationEnabled = true
//                }else {
//                    settingViewModel.isNotificationEnabled = false
//                }
//            }
        }
        //通知セルタップ時に通知がOFFになっている時のアラート
        .alert("通知が許可されていません", isPresented: $notificationViewModel.showNotificationAlert){
            Button("通知画面を開く") {
                DispatchQueue.main.async {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url, options: [:], completionHandler: {_ in
                            notificationViewModel.showNotificationAlert = false
                        })
                    }
                }
            }
            Button("戻る",role: .cancel){
                notificationViewModel.showNotificationAlert = false
                dismiss()
            }
        }message: {
            Text("設定画面から通知を許可してください")
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
