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
    @EnvironmentObject var store: Store
    
    ///コンプリートウインドウを表示するかどうかのフラグ
    @State private var showCompleteWindew = false
    
    ///ユーザーデフォルトに目標表示設定を格納する変数
    @AppStorage("hideInfomation") var hideInfomation = false
    
    ///今日が何日目か格納する変数
    @State private var dayNumber: Int?
    
    ///吹き出し文言の内容を変更する変数
    @State private var showAfterFinishString = false
    
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
                    
                    
                    //Completeボタン:今日のミッションが未達成ならボタンを有効にして表示
                    Button(action: {
                        withAnimation{
                            showCompleteWindew = true
                            store.showAnimation = true
                        }
                        //データを保存
                        coreDataViewModel.saveData(date: Date(), memo: "")
                        
                        Task{
                            //通知設定している場合、本日の通知はスキップする
                            if notificationViewModel.isNotificationOn{
                                await notificationViewModel.setNotification(item: coreDataViewModel.allData.last)
                            }
                        }

                    }, label: {
                        //達成済みの場合ラベルは薄く表示
                        CompleteButton(num:dayNumber ?? 1)
                            .opacity(showAfterFinishString ? 0.3 : 1.0)
                    })
                    
                    .disabled(showAfterFinishString)
                    
                    Spacer()
                }
                .accessibilityHidden(showCompleteWindew)
                
                
                //ボタン押下後は完了のビューを重ねて表示
                if showCompleteWindew {
                    CompleteWindowView(showCompleteWindew: $showCompleteWindew, closed: $showAfterFinishString, dayNumber: dayNumber ?? 1)                    
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
                if !coreDataViewModel.checkTodaysTask{
                    showCompleteWindew = false
                    dayNumber = Int(coreDataViewModel.allData.last?.num ?? 0) + 1
                    showAfterFinishString = false
                }else{
                    //タスク達成済みなら表示する番号は総データ数と同じ、吹き出し文言はボタン押下後のものにする
                    dayNumber = Int(coreDataViewModel.allData.last?.num ?? 0)
                    showAfterFinishString = true
                }
            }
            
            .frame(maxWidth: .infinity)
            
            //グラデーション背景の設定
            .modifier(UserSettingGradient(appColorNum: store.userSelectedColor))
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
            .environmentObject(Store())
    }
}
