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
        ///表示＆共有用の画像
        ZStack{
            VStack(spacing: 20){
                ///目標非表示設定がOFFになってれば目標を表示
                if userDefaultsStore.savedHideInfomation == false{
                    GoalView(longTermGoal: userDefaultsStore.savedLongTermGoal2, shortTermGoal: userDefaultsStore.savedShortTermGoal2)
                }else{
                    Spacer()
                }
                
                ///コメントが入る白い吹き出し
                SpeechBubbleView()
                    .overlay{
                        VStack{
                            Text(coreDataStore.finishedTodaysTask ? "本日のチャレンジは達成済みです。\nお疲れ様でした！" : "今日の取り組みが終わったら、\nボタンを押して完了しよう" )
                                .lineSpacing(10)
                                .foregroundColor(.black)
                            //今日のタスク完了済みならコンプリートウインドウ再表示ボタンを配置
                            if coreDataStore.finishedTodaysTask{
                                HStack{
                                    Button {
                                        bigButtonVM.showAnimation = false
                                        bigButtonVM.showCompleteWindew = true
                                    } label: {
                                        Text("ウインドウを再表示する")
                                            .font(.callout)
                                            .foregroundColor(.blue)
                                    }
                                    .frame(width: AppSetting.screenWidth * 0.8, alignment: .trailing)
                                }
                            }
                        }
                    }
                    .frame(width: AppSetting.screenWidth * 0.9, height: AppSetting.screenWidth * 0.3)
                
                
                ///Completeボタン:今日のミッションが未達成ならボタンを有効にして表示
                Button(action: {
                    //コンプリートウインドウを表示
                    bigButtonVM.showAnimation = true
                    withAnimation{
                        bigButtonVM.showCompleteWindew = true
                    }
                    
                    //CoreDataのデータを保存
                    bigButtonVM.saveTodaysChallenge(challengeDate: coreDataStore.dayNumber) {
                        coreDataStore.setAllData()
                    }
                    
                    // 通知設定している場合、本日の通知はスキップして再設定する
                    Task{
                        await notificationVM.setNotification(isFinishTodaysTask: true)
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
                CompleteSheet(showCompleteWindew: $bigButtonVM.showCompleteWindew, image: $image, showAnimation: bigButtonVM.showAnimation )
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
