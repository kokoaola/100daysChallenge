//
//  SettingView.swift
//  Challenge100days
//
//  Created by koala panda on 2023/02/15.
//

import SwiftUI
import UserNotifications

struct SettingView: View {
    @EnvironmentObject var notificationViewModel :NotificationViewModel
    @EnvironmentObject var userSettingViewModel:UserSettingViewModel
    @EnvironmentObject var coreDataViewModel:CoreDataViewModel
    
    ///CoreData用の変数
//    @Environment(\.managedObjectContext) var moc
//    @FetchRequest(sortDescriptors: [NSSortDescriptor(key:"date", ascending: true)]) var days: FetchedResults<DailyData>
    
//    @AppStorage("colorkeyTop") var storedColorTop: Color = .blue
//    @AppStorage("colorkeyBottom") var storedColorBottom: Color = .green
//    @AppStorage("isFirst") var isFirst = true
    
//    @AppStorage("colorNumber") var colorNumber = 0
    
    @AppStorage("hideInfomation") var hideInfomation = false
    @State var selectedColor = 0
    @State var showResetAlert = false
//    @State var isEdit = false
//    @State var isLong = false
    
    let center = UNUserNotificationCenter.current()
    
    ///長期目標再設定用
    ///アラート表示
    @State var showGoalEdittingAlert = false
    @State private var isLongTermGoal = false
//    @State var  showLongTermGoalEditedAlert = false
    ///編集中の文章の格納
//    @State var edittingLongTermGoal = ""
    ///現在の目標
//    @AppStorage("longTermGoal") var longTermGoal: String = ""
    
    ///アラート表示
//    @State var showShortTermGoalEditedAlert = false
    ///編集中の文章の格納
//    @State var currentShortTermGoal = ""
    ///現在の目標
//    @AppStorage("shortTermGoal") var shortTermGoal: String = ""
    
    @State private var isNotificationEnabled = false
    @State private var showNotificationAlert = false
    //scenePhaseと呼ばれる環境値を監視するための新しいプロパティを追加します。
    @Environment(\.scenePhase) var scenePhase
    
    
    var body: some View {
        NavigationStack{
            
            ZStack{

                VStack(spacing: 50) {
                    List{
//                        アプリ全体の色を変更するボタン
                        Section(){
                            Picker(selection: $selectedColor) {
                                Text("青").tag(0)
                                Text("オレンジ").tag(1)
                                Text("紫").tag(2)
                                Text("モノトーン").tag(3)
                            } label: {
                                Text("アプリの色を変更する")
                            }
                            
                            //                            トップ画面の目標を非表示にするボタン
                            Toggle("目標を隠す", isOn: $hideInfomation)
                                .tint(.green)
                                .accessibilityHint("トップ画面の目標を非表示にします")
                            
                            //                            バックアップ
                            ZStack{
                                Rectangle().foregroundColor(.clear)
                                
                                    .contentShape(Rectangle())
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
                                    NotificationView().environmentObject(NotificationViewModel())
                                } label: {
                                    Text("通知を設定する")
                                }

                            }

                        }
                        
                        Section{
                            
//                            長期目標変更用のボタン
                            Button("目標を変更する") {
                                withAnimation(.easeOut(duration: 0.1)) {
                                    isLongTermGoal = true
                                    withAnimation {
                                        showGoalEdittingAlert = true
                                    }
                                }
//                                edittingLongTermGoal = longTermGoal
                            }
                            
//                            短期目標変更用のボタン
                            Button("100日取り組む内容を変更する") {
                                withAnimation(.easeOut(duration: 0.1)) {
                                    isLongTermGoal = false
                                    withAnimation {
                                        showGoalEdittingAlert = true
                                    }
                                }
//                                currentShortTermGoal = shortTermGoal
                            }
                        }
                        
                        Section{
//                            バックアップ
                            NavigationLink {
                                BackUpView()
                            } label: {
                                Text("バックアップ")
                            }
                            
                            
                            NavigationLink {
                                WebView()
                            } label: {
                                Text("プライバシーポリシー")
                            }
                            
                            
                            NavigationLink {
                                AboutThisApp()
                            } label: {
                                Text("このアプリについて")
                            }
                            
                            
                            NavigationLink {
                                ContactWebView()
                            } label: {
                                Text("お問い合わせ")
                            }
                        }
                        .environmentObject(coreDataViewModel)
                        
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
                    .disabled(showGoalEdittingAlert)
                    .foregroundColor(Color(UIColor.label))
                    
                }
                
                .navigationTitle("設定")
                .navigationBarTitleDisplayMode(.inline)
                .navigationViewStyle(.stack)
//                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .scrollContentBackground(.hidden)
                .accessibilityHidden(showGoalEdittingAlert)
                .opacity(showGoalEdittingAlert ? 0.3 : 1.0)
                .modifier(UserSettingGradient(appColorNum: userSettingViewModel.userSelectedColor))
//                .userSettingGradient(colors: [storedColorTop, storedColorBottom])
                
                if showGoalEdittingAlert{
                        EditGoal(showAlert: $showGoalEdittingAlert, isLong: isLongTermGoal)
                        .transition(.slide)
                        .environmentObject(userSettingViewModel)
                }
//                else if showShortTermGoalEditedAlert{
//                        EditGoal(showAlert: $showShortTermGoalEditedAlert, isLong: false)
//                }
            }
        }

        
        .onChange(of: selectedColor) { newValue in
            userSettingViewModel.userSelectedColor = newValue
            userSettingViewModel.saveUserSettingAppColor(colorNum: newValue)
        }
        
        
        .onChange(of: scenePhase) { newPhase in
            center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                
                if success {
//                    print("All set!")
                    isNotificationEnabled = true
                }else {
//                    print("!")
                    isNotificationEnabled = false
                }
            }
        }
        
        .onAppear{
            selectedColor = userSettingViewModel.userSelectedColor
        }
        
        ///削除ボタン押下時のアラート
        .alert("リセットしますか？", isPresented: $showResetAlert){
            Button("リセットする",role: .destructive){
//                isFirst = true
//                longTermGoal = ""
//                shortTermGoal = ""
                delete()
                notificationViewModel.resetNotification()
                userSettingViewModel.resetUserSetting()
            }
            Button("戻る",role: .cancel){}
        }message: {
            Text("この動作は取り消せません。")
        }
        
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
    
    
    
    ///削除用の関数
    func delete(){
//        for item in days{
//            moc.delete(item)
//            try? moc.save()
//        }
//        UserDefaults.standard.set(1, forKey: "todayIs")
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
        .environmentObject(UserSettingViewModel())
    }
}
