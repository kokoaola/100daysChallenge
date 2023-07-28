//
//  ActionView.swift
//  Challenge100days
//
//  Created by koala panda on 2023/01/29.
//

import SwiftUI


///タスク達成時にコンプリートボタンを押すためのビュー
struct ActionView: View {
    
    ///ViewModel用の変数
    @EnvironmentObject var notificationViewModel: NotificationViewModel
    @EnvironmentObject var coreDataViewModel: CoreDataViewModel
    @EnvironmentObject var userSettingViewModel: UserSettingViewModel
    
    ///コンプリートウインドウを表示するかどうかのフラグ
    @State private var showCompleteWindew = false
    
    ///ユーザーデフォルトに目標表示設定を格納する変数
    @AppStorage("hideInfomation") var hideInfomation = false
    
    ///今日が何日目か計算する変数
    var dayNumber: Int{
        coreDataViewModel.allData.count + 1
    }
    
    
    var body: some View {
        NavigationView{
            ZStack{
                
                VStack(spacing: 20){
                    //目標非表示設定がOFFになってれば目標を表示
                    if hideInfomation == false{
                        VStack(alignment: .center, spacing: 10){
                            VStack{
                                //長期目標の表示
                                Text("目指している姿  :  ")
                                    .fontWeight(.bold)
                                    .frame(width: AppSetting.screenWidth * 0.9, alignment: .leading)
                                
                                Text("\(userSettingViewModel.longTermGoal)")
                            }
                            .contentShape(Rectangle())
                            .accessibilityElement()
                            .accessibilityLabel("目指している姿、\(userSettingViewModel.longTermGoal)")
                            
                            //短期目標の表示
                            VStack{
                                Text("100日取り組むこと : ")
                                    .fontWeight(.bold)
                                    .frame(width: AppSetting.screenWidth * 0.9, alignment: .leading)
                                Text("\(userSettingViewModel.shortTermGoal)")
                            }
                            .contentShape(Rectangle())
                            .accessibilityElement()
                            .accessibilityLabel("100日取り組むこと、\(userSettingViewModel.shortTermGoal)")
                        }.font(.callout.weight(.medium))
                            .frame(width: AppSetting.screenWidth * 0.8)
                            .padding(.top, 90)
                            .foregroundColor(.primary)
                    }else{
                        Spacer()
                    }
                    
                    
                    //コメントが入る白い吹き出し
                    SpeechBubbleView()
                        .offset(x:0, y:-10)
                        .overlay{
                            VStack{
                                Text(notificationViewModel.checkTodaysTask(item: coreDataViewModel.allData.last) ? "本日のチャレンジは達成済みです。\nお疲れ様でした！" : "今日の取り組みが終わったら、\nボタンを押して完了しよう" )
                                    .lineSpacing(10)

                                //今日のタスク完了済みならコンプリートウインドウ再表示ボタンを配置
                                if notificationViewModel.checkTodaysTask(item: coreDataViewModel.allData.last){
                                    HStack{
                                        Button {
                                            showCompleteWindew = true
                                        } label: {
                                            Text("ウインドウを再表示する")
                                                .font(.callout)
                                                .foregroundColor(.blue)
                                        }
                                        .frame(width: AppSetting.screenWidth * 0.8, alignment: .trailing)
                                    }
                                }
                            }
                            .frame(width: AppSetting.screenWidth * 0.9, height: AppSetting.screenWidth * 0.3)
                            .foregroundColor(.black)

                        }
                    
                    
                    //Completeボタン:今日のミッションが未達成ならボタンを有効にして表示
                    Button(action: {
                        withAnimation{
                            showCompleteWindew = true
                        }
                        //データを保存
                            coreDataViewModel.saveData(date: Date(), memo: "")
                    
                        Task{
                            await coreDataViewModel.assignNumbers()
                        }
                        
                        //通知設定している場合、本日の通知はスキップする
                        if notificationViewModel.isNotificationOn{
                            notificationViewModel.setNotification(item: coreDataViewModel.allData.last)
                        }
                    }, label: {
                        //達成済みの場合ラベルは薄く表示
                        CompleteButton(num:notificationViewModel.checkTodaysTask(item: coreDataViewModel.allData.last) ? dayNumber - 1 : dayNumber)
                            .opacity(notificationViewModel.checkTodaysTask(item: coreDataViewModel.allData.last) ? 0.3 : 1.0)
                    })
                    
                    
                    .accessibilityLabel("\(notificationViewModel.checkTodaysTask(item: coreDataViewModel.allData.last) ? dayNumber - 1 : dayNumber)日目を完了する")
                    .padding(.top)
                    .disabled(notificationViewModel.checkTodaysTask(item: coreDataViewModel.allData.last))
                    
                    Spacer()
                }
                .accessibilityHidden(showCompleteWindew)
                
                
                //ボタン押下後は完了のビューを重ねて表示
                if showCompleteWindew {
                    CompleteWindowView(showCompleteWindew: $showCompleteWindew)
                        .padding(.horizontal)
                        .transition(.scale)
                        .environmentObject(coreDataViewModel)
                }
            }
            
            //アプリを開いた日のタスクが未達成の場合、コンプリートウインドウを非表示
            .onAppear{
                if !coreDataViewModel.checkTodaysTask{
                    showCompleteWindew = false
                }
            }
            
            .frame(maxWidth: .infinity)
            
            //グラデーション背景の設定
            .modifier(UserSettingGradient(appColorNum: userSettingViewModel.userSelectedColor))
        }
        .navigationViewStyle(.stack)
    }
}


struct ActionView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            ActionView()
                .environment(\.locale, Locale(identifier:"en"))
            ActionView()
                .environment(\.locale, Locale(identifier:"ja"))
        }.environmentObject(NotificationViewModel())
            .environmentObject(CoreDataViewModel())
            .environmentObject(UserSettingViewModel())
    }
}
