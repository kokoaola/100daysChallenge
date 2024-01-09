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
    ///キーボードフォーカス用変数（Doneボタン表示のため）
    @FocusState var isInputActive: Bool
    
    ///アラート表示用
    @State private var showDeleteAlert = false

    
    var body: some View {
        
        List(){
            ///時間選択のセクション
            Section{
                DatePicker("通知を出す時間", selection: $notificationViewModel.userInputTime, displayedComponents: .hourAndMinute)
            }
            
            ///曜日選択のセクション
            Section(header:
                        HStack{
                Text("通知を出す曜日")
                if !notificationViewModel.isSelectedDaysValid{
                    Label("日付が選択されていません", systemImage: "exclamationmark.circle").foregroundColor(.red).padding(.leading)
                }
            }
            ){
                DaysButtonView(selectedDay: $notificationViewModel.userInputDays, isFormValid: $notificationViewModel.isSelectedDaysValid)
                    .padding()
            }
            
            ///テキストフィールドのセクション
            Section(header:
                        HStack{
                Text("通知の内容を変更（任意）")
                if !notificationViewModel.isTextFieldValid{
                    Label("\(AppSetting.maxLengthOfNotificationText)文字以内のみ設定可能です", systemImage: "exclamationmark.circle").foregroundColor(.red).padding(.leading)
                }
            }
            ){
                //テキストエディタ
                TextEditor(text: $notificationViewModel.userInputText)
                    .foregroundColor(Color.black)
                    .scrollContentBackground(Visibility.hidden)
                    .background(.gray)
                    .accessibilityLabel("通知の内容変更用のテキストフィールド")
                    .focused($isInputActive)
                    .frame(height: 100)
            }.listRowBackground(Color.gray)
            
            
            ///決定ボタン
            HStack{
                Spacer()
                LeftIconBigButton(color: notificationViewModel.isSelectedDaysValid && notificationViewModel.isTextFieldValid  ? .green : .gray, icon: nil, text: "決定")
                    .onTapGesture(perform: {
                        //通知設定をONにして保存
                        notificationViewModel.saveOnOff(isOn: true)
                        Task{
                            await notificationViewModel.setNotification(isFinishTodaysTask: coreDataStore.finishedTodaysTask)
                        }
                        //トーストを表示して画面破棄
                        toastText = "通知を設定しました。"
                        showToast = true
                        dismiss()
                    })
                //曜日が一つも選択されていない時とテキストフィールドの文字数が長すぎる時はボタンは無効
                    .opacity(notificationViewModel.isSelectedDaysValid && notificationViewModel.isTextFieldValid ? 1 : 0.5)
                    .foregroundColor(notificationViewModel.isSelectedDaysValid && notificationViewModel.isTextFieldValid  ? .green : .gray)
                    .disabled(!notificationViewModel.isSelectedDaysValid || !notificationViewModel.isTextFieldValid )
                Spacer()
            }
            .listRowBackground(Color.clear)
            
            
        }
        .foregroundColor(.primary)
        .modifier(UserSettingGradient())
        .scrollContentBackground(.hidden)
        //端末のアプリ通知設定がOFFならすべての操作を無効
        .disabled(!notificationViewModel.isNotificationEnabled)
        .opacity(notificationViewModel.isNotificationEnabled ? 1.0 : 0.5)
        .listStyle(.insetGrouped)
        
        //削除ボタン押下時のアラート
        .alert("通知を停止しますか？", isPresented: $showDeleteAlert){
            Button("停止する",role: .destructive){
                notificationViewModel.resetNotification()
                toastText = "通知を停止しました。"
                showToast = true
                dismiss()
            }
            Button("戻る",role: .cancel){}
        }message: {
            Text("保存された通知の設定は削除されます。")
        }
        
        
        ///ツールバーの設定
        .toolbar {
            //キーボード閉じるボタン
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("閉じる") {
                    isInputActive = false
                }
            }
            
            //左上の通知停止ボタン
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button("通知を停止",role: .destructive){
                    showDeleteAlert = true
                }
                //アプリ内で通知がOFFならボタンは無効
                .opacity(notificationViewModel.savedIsNotificationOn ? 1 : 0.5)
                .foregroundColor(notificationViewModel.savedIsNotificationOn ? .red : .gray)
                .disabled(!notificationViewModel.savedIsNotificationOn)
            }
        }
        
        
        
        ///ここから下は端末の通知設定確認用の処理
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
            Button("端末の通知画面を開く") {
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


//struct Notification_Previews: PreviewProvider {
//    @State static var showToast = false
//    @State static var toastText = ""
//    static var previews: some View {
//        Group{
//            NotificationScreen(showToast: $showToast, toastText: $toastText)
//                .environment(\.locale, Locale(identifier:"en"))
//            
//            NotificationScreen(showToast: $showToast, toastText: $toastText)
//                .environment(\.locale, Locale(identifier:"ja"))
//        }
//        .environmentObject(NotificationViewModel())
//        .environmentObject(CoreDataStore())
//    }
//}
