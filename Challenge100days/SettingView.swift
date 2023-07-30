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
    @EnvironmentObject var notificationViewModel :NotificationViewModel
    @EnvironmentObject var userSettingViewModel:UserSettingViewModel
    @EnvironmentObject var coreDataViewModel:CoreDataViewModel
    
    ///目標隠すかどうかのフラグ
    @AppStorage("hideInfomation") var hideInfomation = false
    
    ///カラー設定ピッカー用の変数
    @State private var selectedColor = 0
    
    ///全データ削除の確認アラート表示用の変数
    @State private var showResetAlert = false
    
    ///動作完了時にのトーストポップアップ用変数
    @State private var showToast = false
    @State private var toastText = ""
    
    ///通知確認用の変数
    let center = UNUserNotificationCenter.current()
    
    ///通知状態の格納用変数
    @State private var isNotificationEnabled = false
    
    ///通知をお願いするアラート表示用のフラグ（設定画面への遷移ボタン）
    @State private var showNotificationAlert = false
    
    ///目標再設定アラート表示用変数
    @State var showGoalEdittingAlert = false
    
    ///長期目標か短期目標かのフラグ
    @State private var isLongTermGoal = false
    
    ///バックグラウンド移行と復帰の環境値を監視する
    @Environment(\.scenePhase) var scenePhase
    
    
    var body: some View {
        NavigationStack{
            
            ZStack{
                
                VStack(spacing: 50) {
                    List{
                        
                        //アプリ全体の色を変更するセル
                        Section(){
                            Picker(selection: $selectedColor) {
                                Text("青").tag(0)
                                Text("オレンジ").tag(1)
                                Text("紫").tag(2)
                                Text("モノトーン").tag(3)
                            } label: {
                                Text("アプリの色を変更する")
                            }
                            
                            // トップ画面の目標を非表示にするセル
                            Toggle("目標を隠す", isOn: $hideInfomation)
                                .tint(.green)
                                .accessibilityHint("トップ画面の目標を非表示にします")
                            
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
                                                showNotificationAlert = true
                                                isNotificationEnabled = false
                                            }
                                        }
                                    }
                                    .disabled(isNotificationEnabled)
                                
                                NavigationLink {
                                    NotificationView(showToast: $showToast, toastText: $toastText)
                                } label: {
                                    Text("通知を設定する")
                                }
                                
                            }
                            
                        }
                        
                        Section{
                            //長期目標変更用のセル
                            Button("目標を変更する") {
                                showToast = false
                                withAnimation(.easeOut(duration: 0.1)) {
                                    isLongTermGoal = true
                                    withAnimation {
                                        showGoalEdittingAlert = true
                                    }
                                }
                            }
                            
                            //短期目標変更用のセル
                            Button("100日取り組む内容を変更する") {
                                showToast = false
                                withAnimation(.easeOut(duration: 0.1)) {
                                    isLongTermGoal = false
                                    withAnimation {
                                        showGoalEdittingAlert = true
                                    }
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
                                WebView()
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
                                showResetAlert = true
                            }
                        }
                    }
                    //アラート表示中はリスト無効、背景透ける
                    .disabled(showGoalEdittingAlert)
                    .accessibilityHidden(showGoalEdittingAlert)
                    .opacity(showGoalEdittingAlert ? 0.3 : 1.0)
                    .animation(nil, value: showGoalEdittingAlert)
                    .foregroundColor(Color(UIColor.label))
                }
                
                //ナビゲーションの設定
                .navigationTitle("設定")
                .navigationBarTitleDisplayMode(.inline)
                .navigationViewStyle(.stack)
                .scrollContentBackground(.hidden)
                //背景グラデーション設定
                .modifier(UserSettingGradient(appColorNum: userSettingViewModel.userSelectedColor))
                
                //目標編集セルタップ後に出現するテキストフィールド付きアラート
                if showGoalEdittingAlert{
                    EditGoal(showAlert: $showGoalEdittingAlert,showToast: $showToast,toastText: $toastText, isLong: isLongTermGoal)
                        .transition(.slide)
                }
                
                //完了時に表示されるトーストポップアップ
                ToastView(show: $showToast, text: toastText)
            }
            .environmentObject(coreDataViewModel)
            .environmentObject(notificationViewModel)
            .environmentObject(userSettingViewModel)
        }
        
        //ピッカーが選択される毎に背景色を変更
        .onChange(of: selectedColor) { newValue in
            userSettingViewModel.userSelectedColor = newValue
            userSettingViewModel.saveUserSettingAppColor(colorNum: newValue)
        }
        
        
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
        .alert("リセットしますか？", isPresented: $showResetAlert){
            Button("リセットする",role: .destructive){
                notificationViewModel.resetNotification()
                userSettingViewModel.resetUserSetting()
                coreDataViewModel.deleteAllData()
            }
            Button("戻る",role: .cancel){}
        }message: {
            Text("この動作は取り消せません。")
        }
        
        //通知セルタップ時に通知がOFFになっている時のアラート
        .alert("通知が許可されていません", isPresented: $showNotificationAlert){
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




struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            SettingView()
                .environment(\.locale, Locale(identifier:"en"))
            
            SettingView()
                .environment(\.locale, Locale(identifier:"ja"))
        }
        .environmentObject(CoreDataViewModel())
        .environmentObject(UserSettingViewModel())
        .environmentObject(NotificationViewModel())
    }
}
