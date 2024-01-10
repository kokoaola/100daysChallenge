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
    @EnvironmentObject var coreDataStore: CoreDataStore
    @EnvironmentObject var userDefaultsStore: UserDefaultsStore
    @StateObject var settingViewModel = SettingViewModel()
    @EnvironmentObject var notificationViewModel: NotificationViewModel
    
    var body: some View {
        NavigationStack{
            
            ZStack{
                
                VStack(spacing: 50) {
                    List{
                        
                        ///背景色変更用ピッカーのセクション
                        Section{
                            Picker(selection: $userDefaultsStore.userInputColor) {
                                Text("青").tag(0)
                                Text("オレンジ").tag(1)
                                Text("紫").tag(2)
                                Text("モノトーン").tag(3)
                            } label: {
                                Text("アプリの色を変更する")
                            }
                            //ピッカーが選択される毎に背景色を変更
                            .onChange(of: userDefaultsStore.userInputColor) { newValue in
                                //アプリの色を保存
                                userDefaultsStore.saveSettingColor()
                            }
                        }
                        
                        
                        ///通知設定のセクション
                        Section{
                            NavigationLink {
                                NotificationScreen(showToast: $settingViewModel.showToast, toastText: $settingViewModel.toastText)
                            } label: {
                                NotificationRow(notification: notificationViewModel.notification, isOn: notificationViewModel.savedIsNotificationOn)
//                                Text("通知を設定する\n") + Text("現在の設定 : ").font(.callout).foregroundColor(.gray) + Text(LocalizedStringKey(notificationViewModel.showNotificationTime())).font(.callout).foregroundColor(.gray) + Text("\n") + Text("[\(notificationViewModel.shownotificationDate())]").font(.callout).foregroundColor(.gray)
                            }
                        }
                        
                        
                        ///目標設定のセクション
                        Section{
                            //トップ画面の目標を非表示にするスイッチ
                            Toggle("目標を隠す", isOn: $userDefaultsStore.userInputHideInfomation)
                                .tint(.green)
                                .accessibilityHint("トップ画面の目標を非表示にします")
                                //設定を保存
                                .onChange(of: userDefaultsStore.userInputHideInfomation) { newSetting in
                                    userDefaultsStore.saveHideInfomation()
                                }
                            
                            //長期目標変更用のセル
                            Button("目標を変更する") {
                                settingViewModel.editLongTermGoal = true
                                withAnimation {
                                    settingViewModel.showGoalEdittingAlert = true
                                }
                            }
                            
                            //短期目標変更用のセル
                            Button("100日取り組む内容を変更する") {
                                settingViewModel.editLongTermGoal = false
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
                                settingViewModel.showResetAlert.toggle()
                            }
                        }
                    }
                    .foregroundColor(Color(UIColor.label))
                    //アラート表示中のリスト無効、背景透ける設定
                    .disabled(settingViewModel.showGoalEdittingAlert)
                    .accessibilityHidden(settingViewModel.showGoalEdittingAlert)
                    .opacity(settingViewModel.showGoalEdittingAlert ? 0.3 : 1.0)
                    .animation(nil, value: settingViewModel.showGoalEdittingAlert)
                }
                
                //ナビゲーションの設定
                .navigationTitle("設定")
                .navigationBarTitleDisplayMode(.inline)
                .navigationViewStyle(.stack)
                .scrollContentBackground(.hidden)
                //背景グラデーション設定
                .modifier(UserSettingGradient())
                
                ///目標編集セルタップ時に出現するテキストフィールド付きアラート
                if settingViewModel.showGoalEdittingAlert{
                    if settingViewModel.editLongTermGoal{
                        EditLongGoal(settingViewModel: settingViewModel)
                    }else{
                        EditShortGoal(settingViewModel: settingViewModel)
                    }
                }

                
                ///完了時に表示されるトーストポップアップ
                ToastView(show: $settingViewModel.showToast, text: settingViewModel.toastText)
                
            }
            .environmentObject(notificationViewModel)
            .environmentObject(coreDataStore)
            ///リセットボタン押下時のアラート
            .alert("リセットしますか？", isPresented: $settingViewModel.showResetAlert){
                Button("リセットする",role: .destructive){
                    notificationViewModel.resetNotification()
                    userDefaultsStore.resetUserDefaultsSetting()
                    coreDataStore.deleteAllData()
                }
                Button("戻る",role: .cancel){}
            }message: {
                Text("この動作は取り消せません。")
            }
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

