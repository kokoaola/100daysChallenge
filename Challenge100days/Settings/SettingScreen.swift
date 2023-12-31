//
//  SettingView.swift
//  Challenge100days
//
//  Created by koala panda on 2023/02/15.
//

import SwiftUI
import UserNotifications


///設定画面のビュー
struct SettingView: View {
    ///ViewModel用の変数
    @EnvironmentObject var globalStore: GlobalStore
    @ObservedObject var settingViewModel = SettingViewModel()
    
    @ObservedObject var notificationViewModel = NotificationViewModel()
    @ObservedObject var coreDataViewModel = CoreDataViewModel()
    
    ///通知確認用の変数
    let center = UNUserNotificationCenter.current()
    
    ///通知状態の格納用変数
    @State private var isNotificationEnabled = false
    
    ///バックグラウンド移行と復帰の環境値を監視する
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        NavigationStack{
            
            ZStack{
                
                VStack(spacing: 50) {
                    List{
                        
                        //アプリ全体の色を変更するセル
                        Section(){
                            ///背景色変更用ピッカー
                            Picker(selection: $settingViewModel.userSelectedColor) {
                                Text("青").tag(0)
                                Text("オレンジ").tag(1)
                                Text("紫").tag(2)
                                Text("モノトーン").tag(3)
                            } label: {
                                Text("アプリの色を変更する")
                            }
                            //ピッカーが選択される毎に背景色を変更
                            .onChange(of: settingViewModel.userSelectedColor) { newColor in
                                globalStore.saveSettingColor(newColor)
                            }
                            
                            
                            ///トップ画面の目標を非表示にするスイッチ
                            Toggle("目標を隠す", isOn: $settingViewModel.hideInfomation)
                                .tint(.green)
                                .accessibilityHint("トップ画面の目標を非表示にします")
                            //設定を保存
                                .onChange(of: settingViewModel.hideInfomation) { newSetting in
                                    globalStore.switchHideInfomation(settingViewModel.hideInfomation)
                                }
                            
                            // 通知設定用のセル
                            ZStack{
                                Rectangle().foregroundColor(.clear)
                                    .contentShape(Rectangle())
                                //タップ時に通知の許可を判定、許可されていれば画面遷移
                                    .onTapGesture {
                                        center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                                            if let error = error {
                                                print(error.localizedDescription)
                                            }
                                            
                                            if success {
                                                //通知OK
                                                isNotificationEnabled = true
                                            }else {
                                                //通知NG
                                                settingViewModel.showNotificationAlert = true
                                                isNotificationEnabled = false
                                            }
                                        }
                                    }
                                    .disabled(isNotificationEnabled)
                                
                                NavigationLink {
                                    NotificationView(showToast: $settingViewModel.showToast, toastText: $settingViewModel.toastText)
                                } label: {
                                    Text("通知を設定する")
                                }
                                
                            }
                            
                        }
                        
                        Section{
                            //長期目標変更用のセル
                            Button("目標を変更する") {
                                settingViewModel.showToast = false
                                settingViewModel.isLongTermGoal = true
                                withAnimation {
                                    settingViewModel.showGoalEdittingAlert = true
                                }
                            }
                            
                            //短期目標変更用のセル
                            Button("100日取り組む内容を変更する") {
                                settingViewModel.showToast = false
                                settingViewModel.isLongTermGoal = false
                                withAnimation {
                                    settingViewModel.showGoalEdittingAlert = true
                                }
                            }
                        }
                        
                        Section{
                            //バックアップデータ取得用のセル
                            NavigationLink {
                                BackUpView()
                            } label: {
                                Text("バックアップ")
                            }
                            
                            //プライバシーポリシーページ遷移用のセル
                            NavigationLink {
                                PrivacyPolicyWebView()
                            } label: {
                                Text("プライバシーポリシー")
                            }
                            
                            //アプリ解説ページ遷移用のセル
                            NavigationLink {
                                AboutThisApp()
                            } label: {
                                Text("このアプリについて")
                            }
                            
                            //お問い合わせページ遷移用のセル
                            NavigationLink {
                                ContactWebView()
                            } label: {
                                Text("お問い合わせ")
                            }
                        }
                        
                        //全データ消去用のセル
                        Section{
                            HStack{
                                Spacer()
                                Text("リセット")
                                    .foregroundColor(.red)
                                Spacer()
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                settingViewModel.showResetAlert = true
                            }
                        }
                    }
                    //アラート表示中はリスト無効、背景透ける
                    .disabled(settingViewModel.showGoalEdittingAlert)
                    .accessibilityHidden(settingViewModel.showGoalEdittingAlert)
                    .opacity(settingViewModel.showGoalEdittingAlert ? 0.3 : 1.0)
                    .animation(nil, value: settingViewModel.showGoalEdittingAlert)
                    .foregroundColor(Color(UIColor.label))
                }
                
                //ナビゲーションの設定
                .navigationTitle("設定")
                .navigationBarTitleDisplayMode(.inline)
                .navigationViewStyle(.stack)
                .scrollContentBackground(.hidden)
                //背景グラデーション設定
                .modifier(UserSettingGradient(appColorNum: settingViewModel.userSelectedColor))
                
                //目標編集セルタップ後に出現するテキストフィールド付きアラート
                if settingViewModel.showGoalEdittingAlert{
                    EditGoal(showAlert: $settingViewModel.showGoalEdittingAlert,showToast: $settingViewModel.showToast,toastText: $settingViewModel.toastText, isLong: settingViewModel.isLongTermGoal)
                        .transition(.opacity)
                }
                
                //完了時に表示されるトーストポップアップ
                ToastView(show: $settingViewModel.showToast, text: settingViewModel.toastText)
            }
            .environmentObject(coreDataViewModel)
            .environmentObject(notificationViewModel)
            .environmentObject(globalStore)
        }
        

        
        
        //アニメーションの設定
        .animation(settingViewModel.showGoalEdittingAlert ? .easeInOut(duration: 0.05) : nil, value: settingViewModel.showGoalEdittingAlert)
        
        
        //バックグラウンド復帰時に通知の状態を確認
        //これしないと通知OFFでも通知設定画面に遷移できてしまうため
        .onChange(of: scenePhase) { newPhase in
            center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                if success {
                    isNotificationEnabled = true
                }else {
                    isNotificationEnabled = false
                }
            }
        }
        
        //リセットボタン押下時のアラート
        .alert("リセットしますか？", isPresented: $settingViewModel.showResetAlert){
            Button("リセットする",role: .destructive){
                notificationViewModel.resetNotification()
//                store.resetUserSetting()
                coreDataViewModel.deleteAllData()
            }
            Button("戻る",role: .cancel){}
        }message: {
            Text("この動作は取り消せません。")
        }
        
        //通知セルタップ時に通知がOFFになっている時のアラート
        .alert("通知が許可されていません", isPresented: $settingViewModel.showNotificationAlert){
            Button("通知画面を開く") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
            Button("戻る",role: .cancel){}
        }message: {
            Text("設定画面から通知を許可してください")
        }
    }
}




//struct SettingView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group{
//            SettingView()
//                .environment(\.locale, Locale(identifier:"en"))
//            
//            SettingView()
//                .environment(\.locale, Locale(identifier:"ja"))
//        }
//        .environmentObject(CoreDataViewModel())
//        .environmentObject(Store())
//        .environmentObject(NotificationViewModel())
//    }
//}
