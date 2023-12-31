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
    @EnvironmentObject var globalStore: GlobalStore
    @StateObject var bigButtonVM: BigButtonViewModel
    
    ///表示＆共有用の画像
    @State var image: Image?
    
    var body: some View {
        ZStack{
            VStack(spacing: 20){
                ///目標非表示設定がOFFになってれば目標を表示
                if globalStore.hideInfomation == false{
                    GoalView(longTermGoal: bigButtonVM.longTermGoal, shortTermGoal: bigButtonVM.shortTermGoal)
                }else{
                    Spacer()
                }
                
                ///コメントが入る白い吹き出し
                SpeechBubbleView(finishedTodaysTask: globalStore.finishedTodaysTask, showCompleteWindew: $bigButtonVM.showCompleteWindew)
                
                ///Completeボタン:今日のミッションが未達成ならボタンを有効にして表示
                Button(action: {
                    withAnimation{
                        bigButtonVM.showCompleteWindew = true
                    }
                    //データを保存
                    bigButtonVM.saveTodaysChallenge(challengeDate: globalStore.dayNumber) { success in
                        if success {
                            Task{
                                // 通知設定している場合、本日の通知はスキップする
                                if notificationViewModel.isNotificationOn{
                                    await notificationViewModel.setNotification(isFinishTodaysTask: globalStore.finishedTodaysTask)
                                }
                                //配列を更新
                                globalStore.setAllData()
                            }
                        }
                    }
                }, label: {
                    //達成済みの場合ラベルは薄く表示
                    CompleteButton(num: globalStore.dayNumber)
                        .opacity(globalStore.finishedTodaysTask ? 0.3 : 1.0)
                })
                .disabled(globalStore.finishedTodaysTask)
                
                Spacer()
            }
            .accessibilityHidden(bigButtonVM.showCompleteWindew)
            
            
            //ボタン押下後は完了のビューを重ねて表示
            if bigButtonVM.showCompleteWindew {
                CompleteSheet(showCompleteWindew: $bigButtonVM.showCompleteWindew, image: $image)
                    .padding(.horizontal)
                    .transition(.scale)
            }
        }
        .onAppear{
            //コンプリートウインドウを非表示
            bigButtonVM.showCompleteWindew = false
            //あらかじめ当日分のイメージを作成してセット
            DispatchQueue.main.async {
                globalStore.setAllData()
                image = generateImageWithText(number: globalStore.dayNumber, day: Date.now)
            }
        }
        
        .frame(maxWidth: .infinity)
        //グラデーション背景の設定
        .modifier(UserSettingGradient(appColorNum: globalStore.userSelectedColor))
    }
}


//struct ActionView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group{
//            ActionView()
//                .environment(\.locale, Locale(identifier:"en"))
//            ActionView()
//                .environment(\.locale, Locale(identifier:"ja"))
//        }.environmentObject(NotificationViewModel())
//            .environmentObject(CoreDataViewModel())
//            .environmentObject(GlobalStore())
//            .environmentObject(Store())
//    }
//}
