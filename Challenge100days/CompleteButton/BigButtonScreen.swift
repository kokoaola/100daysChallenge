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
    @StateObject private var bigButtonVM = BigButtonViewModel()
    @EnvironmentObject var grobalStore: GrobalStore
    @EnvironmentObject var coreDataViewModel: CoreDataViewModel
    
    var body: some View {
            ZStack{
                VStack(spacing: 20){
                    //目標非表示設定がOFFになってれば目標を表示
                    if bigButtonVM.hideInfomation == false{
                        TermsView(longTermGoal: bigButtonVM.longTermGoal, shortTermGoal: bigButtonVM.shortTermGoal)
                    }else{
                        Spacer()
                    }
                    
                    //コメントが入る白い吹き出し
                    SpeechBubbleView(finishedTodaysTask: grobalStore.finishedTodaysTask, showCompleteWindew: $bigButtonVM.showCompleteWindew)
                    
                    
                    ///Completeボタン:今日のミッションが未達成ならボタンを有効にして表示
                    Button(action: {
                        withAnimation{
                            bigButtonVM.showCompleteWindew = true
                            bigButtonVM.showAnimation = true
                        }
                        
                        //データを保存
                        bigButtonVM.saveTodaysChallenge(challengeDate: grobalStore.dayNumber) { error in
                            Task{
                                //通知設定している場合、本日の通知はスキップする
                                if notificationViewModel.isNotificationOn{
                                    await notificationViewModel.setNotification(item: grobalStore.allData.last)
                                }
                                grobalStore.setAllData()
                            }
                        }
                    }, label: {
                        //達成済みの場合ラベルは薄く表示
                        CompleteButton(num: grobalStore.dayNumber)
                            .opacity(grobalStore.finishedTodaysTask ? 0.3 : 1.0)
                    })
                    
                    .disabled(grobalStore.finishedTodaysTask)
                    
                    Spacer()
                }
                .accessibilityHidden(bigButtonVM.showCompleteWindew)
                
                
                //ボタン押下後は完了のビューを重ねて表示
                if bigButtonVM.showCompleteWindew {
                    CompleteSheet(showCompleteWindew: $bigButtonVM.showCompleteWindew, dayNumber: grobalStore.dayNumber, showAnimation: !grobalStore.finishedTodaysTask)
                        .padding(.horizontal)
                        .transition(.scale)
                        .environmentObject(coreDataViewModel)

                    
                        //子ビューのキーボード閉じるボタンの実装
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer()  // 右寄せにする
                                Button("閉じる") {
                                    AppSetting.colseKeyBoard()
                                }
                                .foregroundColor(.primary)
                            }
                        }
                }
            }

            
            //アプリを開いた日のタスクが未達成の場合、コンプリートウインドウを非表示、表示する番号は総データ数＋1、吹き出し文言はボタン押下前のものにする
            .onAppear{
                bigButtonVM.showCompleteWindew = false
                grobalStore.setAllData()
                
//                if !coreDataViewModel.checkTodaysTask{
//                    grobalStore.dayNumber = Int(coreDataViewModel.allData.last?.num ?? 0) + 1
//                    showAfterFinishString = false
//                }else{
//                    //タスク達成済みなら表示する番号は総データ数と同じ、吹き出し文言はボタン押下後のものにする
//                    grobalStore.dayNumber = Int(coreDataViewModel.allData.last?.num ?? 0)
//                    showAfterFinishString = true
//                }
            }
            
            .frame(maxWidth: .infinity)
            
            //グラデーション背景の設定
            .modifier(UserSettingGradient(appColorNum: bigButtonVM.userSelectedColor))
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
            .environmentObject(GrobalStore())
            .environmentObject(Store())
    }
}
