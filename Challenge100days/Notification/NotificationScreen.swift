//
//  Notification.swift
//  Challenge100days
//
//  Created by koala panda on 2023/07/16.
//

import SwiftUI

///通知設定するビュー
struct NotificationScreen: View {
    ///ViewModel用の変数
    @EnvironmentObject var notificationViewModel :NotificationViewModel
    @EnvironmentObject var coreDataStore: CoreDataStore
    
    ///トーストの表示状態と表示する文章を格納する変数
    @Binding var showToast: Bool
    @Binding var toastText: String
    
    ///画面破棄用
    @Environment(\.dismiss) var dismiss
    ///バックグラウンド移行と復帰の環境値を監視する
    @Environment(\.scenePhase) var scenePhase
    
    ///アラート表示用
    @State private var showDeleteAlert = false
    ///通知時間を格納する変数
    @State private var selectedTime = Date()
    ///通知を送る曜日を格納する変数
    @State private var selectedDay = Weekday.allCases.reduce(into: [Weekday: Bool]()) { $0[$1] = true }
    ///ユーザーの選択が有効か
    @State var isFormValid = true
    
    var body: some View {
        
        ZStack{ //トースト表示用のZStack
            VStack{
                List(){
                    
                    ///通知を受信する時間選択用のピッカー
                    Section(){
                        DatePicker("通知を出す時間", selection: $selectedTime, displayedComponents: .hourAndMinute)
                    }
                    
                    ///曜日選択用のボタン
                    Section(header:
                                HStack{
                        Text("通知を出す曜日")
                        if !isFormValid{
                            Label("日付が選択されていません", systemImage: "exclamationmark.circle").foregroundColor(.red).padding(.leading)
                        }
                    }
                    ){
                        DaysButtonView(selectedDay: $selectedDay, isFormValid: $isFormValid)
                        .padding()
                    }
                }
                
                ///保存ボタン
                Button {
                    notificationViewModel.switchUserNotification(isOn: true)
                    Task{
                        await notificationViewModel.setNotification(isFinishTodaysTask: coreDataStore.finishedTodaysTask, time: selectedTime, days: selectedDay)
                    }
                    //トーストを表示して画面破棄
                    toastText = "通知を設定しました。"
                    showToast = true
                    dismiss()
                    
                } label: {
                    LeftIconBigButton(color:.green, icon: nil, text: "決定")
                        .padding(.bottom)
                }
                //曜日が一つも選択されていないとボタンは無効
                .opacity(isFormValid ? 1 : 0.5)
                .foregroundColor(isFormValid ? .green : .gray)
                .disabled(!isFormValid)
            }
        } //トースト表示用のZStackここまで
        .disabled(!notificationViewModel.isNotificationEnabled)
        .opacity(notificationViewModel.isNotificationEnabled ? 1.0 : 0.5)
        
    
        
        //削除ボタン押下時のアラート
        .alert("通知設定を削除しますか？", isPresented: $showDeleteAlert){
            Button("削除する",role: .destructive){
                notificationViewModel.resetNotification()
                toastText = "通知を削除しました。"
                showToast = true
                dismiss()
            }
            Button("戻る",role: .cancel){}
        }message: {
            Text("通知は今後送信されません。")
        }
        
        .toolbar{
            
            //表示している日の記録の削除用ごみ箱アイコン
            ToolbarItem(placement: .navigationBarTrailing){
                Button {
                    showDeleteAlert = true
                } label: {
                    Image(systemName: "trash")
                }
                .foregroundColor(.red)
                .padding(.trailing)
            }
        }
        
        ///ここから下は端末の通知設定確認用の処理
        .onAppear{
            //タップ時に通知の許可を判定、許可されていれば画面遷移
            notificationViewModel.isUserNotificationEnabled()
            selectedTime = notificationViewModel.userSettingNotificationTime
            selectedDay = notificationViewModel.userSettingNotificationDays
        }
        //バックグラウンド復帰時に通知の状態を確認(これしないと通知OFFでも通知設定画面に遷移できてしまうため)
        .onChange(of: scenePhase) { newPhase in
            notificationViewModel.isUserNotificationEnabled()
        }
        //通知セルタップ時に通知がOFFになっている時のアラート
        .alert("通知が許可されていません", isPresented: $notificationViewModel.showNotificationAlert){
            //設定画面に遷移
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
}


struct Notification_Previews: PreviewProvider {
    @State static var showToast = false
    @State static var toastText = ""
    static var previews: some View {
        Group{
            NotificationScreen(showToast: $showToast, toastText: $toastText)
                .environment(\.locale, Locale(identifier:"en"))
            
            NotificationScreen(showToast: $showToast, toastText: $toastText)
                .environment(\.locale, Locale(identifier:"ja"))
        }
        .environmentObject(NotificationViewModel())
        .environmentObject(CoreDataStore())
    }
}
