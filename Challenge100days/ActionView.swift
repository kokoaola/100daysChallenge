//
//  ActionView.swift
//  Challenge100days
//
//  Created by koala panda on 2023/01/29.
//

import SwiftUI



struct ActionView: View {
    @EnvironmentObject var notificationViewModel :NotificationViewModel
    @EnvironmentObject var coreDataViewModel :CoreDataViewModel
    
    @Environment(\.scenePhase) var scenePhase
    
    ///CoreDataに保存したデータ呼び出し用
    //    @Environment(\.managedObjectContext) var moc
    //    @FetchRequest(sortDescriptors: [NSSortDescriptor(key:"date", ascending: true)]) var days: FetchedResults<DailyData>
    
    ///今日のワークが達成されているかの確認用フラグ
//    @State var isComplete = false
    
    ///コンプリートウインドウ出現フラグ
    @State private var showCompleteWindew = false
    
    
    @AppStorage("colorkeyTop") var storedColorTop: Color = .blue
    @AppStorage("colorkeyBottom") var storedColorBottom: Color = .green
    
    @AppStorage("longTermGoal") var longTermGoal: String = ""
    @AppStorage("shortTermGoal") var shortTermGoal: String = ""
    
    @AppStorage("hideInfomation") var hideInfomation = false
    
    var startDate: String{
        makeDate(day: coreDataViewModel.allData.first?.date ?? Date.now)
        //makeDate(day:days.first?.date ?? Date.now)
    }
    
    var dayNumber: Int{
        coreDataViewModel.allData.count + 1
    }
    
    
    var body: some View {
        NavigationView{
            ZStack{
                
                ///今日のミッションが未達成ならボタンのビューを表示
                VStack(spacing: AppSetting.screenHeight / 50){
                    
                    if !hideInfomation{
                        VStack(alignment: .center, spacing: 0){
                            VStack{
                                Text("目指している姿  :  ")
                                    .fontWeight(.bold)
                                    .frame(width: AppSetting.screenWidth * 0.9, alignment: .leading)
                                
                                Text("\(longTermGoal)")
                                ///Text("Build strength and muscle mass")
                                ///Text("運動の習慣を付けて、健康的な体型を目指す！")
                                
                                    .frame(width: AppSetting.screenWidth * 0.9 , height: 50,alignment: .center)
                                    .padding(.bottom, 10)
                            }
                            .contentShape(Rectangle())
                            .accessibilityElement()
                            .accessibilityLabel("目指している姿、\(longTermGoal)")
                            
                            
                            VStack{
                                Text("100日取り組むこと : ")
                                    .fontWeight(.bold)
                                    .frame(width: AppSetting.screenWidth * 0.9, alignment: .leading)
                                Text("\(shortTermGoal)")
                                ///Text("Work 2 kilometer without stopping")
                                ///Text("２キロ歩く")
                                    .frame(width: AppSetting.screenWidth * 0.9, height: 50 ,alignment: .center)
                            }
                            .contentShape(Rectangle())
                            .accessibilityElement()
                            .accessibilityLabel("100日取り組むこと、\(shortTermGoal)")
                            
                            
                        }.font(.callout.weight(.medium))
                            .frame(width: AppSetting.screenWidth * 0.8)
                            .padding(.top, 90)
                            .foregroundColor(.primary)
                        
                    }else{
                        Spacer()
                    }
                    
                    ///白い吹き出し
                    SpeechBubble()
                        .rotation(Angle(degrees: 180))
                        .foregroundColor(.white)
                        .overlay{
                            VStack{
                                Text(notificationViewModel.checkTodaysTask(item: coreDataViewModel.allData.last) ? "本日のチャレンジは達成済みです。\nお疲れ様でした！" : "今日の取り組みが終わったら、\nボタンを押して完了しよう" )
                                    .lineSpacing(10)
                                    .padding(.vertical, 5)
                                
                                if notificationViewModel.checkTodaysTask(item: coreDataViewModel.allData.last){
                                    HStack{
                                        Spacer()
                                        Button {
                                            showCompleteWindew = true
                                        } label: {
                                            Text("ウインドウを再表示する")
                                                .font(.footnote)
                                                .foregroundColor(.blue)
                                        }
                                        .frame(width: AppSetting.screenWidth * 0.8, alignment: .trailing)
                                        .padding(.trailing)
                                    }
                                }
                            }
                            .foregroundColor(.black)
                        }
                        .frame(width: AppSetting.screenWidth * 0.9, height: AppSetting.screenWidth * 0.3)
                        .opacity(0.8)
                    
                    
                    
                    ///Completeボタンが押されたら本日分のDailyDataを保存
                    Button(action: {
                        withAnimation{
                            showCompleteWindew = true
                        }
                        
                        coreDataViewModel.saveData(date: Date(), memo: "")
                        
                        if notificationViewModel.isNotificationOn{
                            notificationViewModel.setNotification(item: coreDataViewModel.allData.last)
                        }
                    }, label: {
                        ///CompleteButton(num:52)
                        CompleteButton(num:notificationViewModel.checkTodaysTask(item: coreDataViewModel.allData.last) ? dayNumber - 1 : dayNumber)
                            .foregroundStyle(.primary)
                            .opacity(notificationViewModel.checkTodaysTask(item: coreDataViewModel.allData.last) ? 0.3 : 1.0)
                    })
                    
                    
                    .accessibilityLabel("\(notificationViewModel.checkTodaysTask(item: coreDataViewModel.allData.last) ? dayNumber - 1 : dayNumber)日目を完了する")
                    .padding(.top)
                    .disabled(notificationViewModel.checkTodaysTask(item: coreDataViewModel.allData.last))
                    
                    Spacer()
                }
                .accessibilityHidden(showCompleteWindew)
                
                
                ///ボタン押下後は完了のビューを重ねて表示
                if showCompleteWindew {
                    CompleteWindowView(showCompleteWindew: $showCompleteWindew)
                        .padding(.horizontal)
                        .transition(.scale)
                        .environmentObject(coreDataViewModel)
                }
            }
            
            
            .onAppear{
                if !coreDataViewModel.checkTodaysTask{
                    showCompleteWindew = false
                }
            }
            
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .userSettingGradient(colors: [storedColorTop, storedColorBottom])
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
    }
}
