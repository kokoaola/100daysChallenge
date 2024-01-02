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
    
    
    var body: some View {
        
        ZStack{ //トースト表示用のZStack
            VStack{
                List(){
                    Section(header: Text("通知を出す時間")){
                        //通知を受信する時間選択用のピッカー
                        DatePicker("", selection: $notificationViewModel.userSettingNotificationTime, displayedComponents: .hourAndMinute)
                            .datePickerStyle(.wheel)
                            .labelsHidden()
                            .frame(height: 150)
                            .padding(.bottom)
                    }
                    
                    Section(header: Text("通知を出す曜日")){
                        VStack{
                            // 1から4個目の曜日
                            HStack {
                                ForEach(Weekday.allCases.prefix(5), id: \.self) { weekday in
                                    Text(weekday.name)
                                        .onTapGesture {
                                            notificationViewModel.userSettingNotificationDays[weekday]?.toggle()
                                            notificationViewModel.checkAndUpdateSelectAll()

                                        }
                                        .padding(8)
                                        .foregroundColor(.white)
                                        .background(notificationViewModel.userSettingNotificationDays[weekday] ?? false ? .blue : .gray.opacity(0.4))
                                        .cornerRadius(20)
                                }
                            }
                            
                            // 2から7個目の曜日
                            HStack {
                                ForEach(Weekday.allCases.suffix(2), id: \.self) { weekday in
                                    Text(weekday.name)
                                        .onTapGesture {
                                            notificationViewModel.userSettingNotificationDays[weekday]?.toggle()
                                            notificationViewModel.checkAndUpdateSelectAll()
                                        }
                                        .padding(8)
                                        .foregroundColor(.white)
                                        .background(notificationViewModel.userSettingNotificationDays[weekday] ?? false ? .blue : .gray.opacity(0.4))
                                        .cornerRadius(20)
                                }
                                Text(notificationViewModel.selectAllDays ? "すべて解除" : "すべて選択")
                                    .onTapGesture {
                                        if notificationViewModel.selectAllDays{
                                            notificationViewModel.selectAllDays = false
                                            for item in Weekday.allCases{
                                                notificationViewModel.userSettingNotificationDays[item]? = false
                                            }
                                        }else{
                                            notificationViewModel.selectAllDays = true
                                            for item in Weekday.allCases{
                                                notificationViewModel.userSettingNotificationDays[item]? = true
                                            }
                                        }
                                    }
                                    .foregroundColor(notificationViewModel.selectAllDays ? .blue : .gray)
                                    .padding(.leading)
                            }
                        }
                        .padding()
                    }
                }
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
            
            
        } //トースト表示用のZStackここまで
        .disabled(!notificationViewModel.isNotificationEnabled)
        .opacity(notificationViewModel.isNotificationEnabled ? 1.0 : 0.5)
        
        
        ///端末の通知設定確認用の処理
        .onAppear{
            //タップ時に通知の許可を判定、許可されていれば画面遷移
            notificationViewModel.isUserNotificationEnabled()
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
            NotificationView(showToast: $showToast, toastText: $toastText)
                .environment(\.locale, Locale(identifier:"en"))
            
            NotificationView(showToast: $showToast, toastText: $toastText)
                .environment(\.locale, Locale(identifier:"ja"))
        }
        .environmentObject(NotificationViewModel())
        .environmentObject(GlobalStore())
    }
}
