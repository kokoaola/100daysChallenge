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
    @EnvironmentObject var coreDataStore: CoreDataStore
    @EnvironmentObject var userDefaultsStore: UserDefaultsStore
    @ObservedObject var bigButtonVM: BigButtonViewModel
    @EnvironmentObject var notificationVM: NotificationViewModel
    
    ///表示＆共有用の画像
    @State var image: Image?
    
    var body: some View {
        ZStack{
            VStack(spacing: 20){
                ///目標非表示設定がOFFになってれば目標を表示
                if userDefaultsStore.savedHideInfomation == false{
                    GoalView(longTermGoal: userDefaultsStore.savedLongTermGoal2, shortTermGoal: userDefaultsStore.savedShortTermGoal2)
                }else{
                    Spacer()
                }
                
                ///コメントが入る白い吹き出し
                SpeechBubbleView(finishedTodaysTask: coreDataStore.finishedTodaysTask, showCompleteWindew: $bigButtonVM.showCompleteWindew)
                
                ///Completeボタン:今日のミッションが未達成ならボタンを有効にして表示
                Button(action: {
                    withAnimation{
                        bigButtonVM.showCompleteWindew = true
                    }
                    
                    //データを保存
                    bigButtonVM.saveTodaysChallenge(challengeDate: coreDataStore.dayNumber) {
                        //配列を更新
                        coreDataStore.setAllData()
                    }
                    Task{
                        // 通知設定している場合、本日の通知はスキップして再設定する
                        if notificationVM.savedIsNotificationOn{
                            await notificationVM.setNotification(isFinishTodaysTask: true)
                        }
                    }
                }, label: {
                    //達成済みの場合ラベルは薄く表示
                    CompleteButton(num: coreDataStore.dayNumber)
                        .opacity(coreDataStore.finishedTodaysTask ? 0.3 : 1.0)
                })
                .disabled(coreDataStore.finishedTodaysTask)
                
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
                coreDataStore.setAllData()
                image = generateImageWithText(number: coreDataStore.dayNumber, day: Date.now)
            }
        }
        
        .frame(maxWidth: .infinity)
        //グラデーション背景の設定
        .modifier(UserSettingGradient())
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
