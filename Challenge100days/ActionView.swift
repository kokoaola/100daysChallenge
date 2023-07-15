//
//  ActionView.swift
//  Challenge100days
//
//  Created by koala panda on 2023/01/29.
//

import SwiftUI



struct ActionView: View {
    ///CoreDataに保存したデータ呼び出し用
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key:"date", ascending: true)]) var days: FetchedResults<DailyData>
    
    ///今日のワークが達成されているかの確認用フラグ
    @State var isComplete = false
    
    ///コンプリートウインドウ出現フラグ
    @State var showCompleteWindew = false
    
    
    @AppStorage("colorkeyTop") var storedColorTop: Color = .blue
    @AppStorage("colorkeyBottom") var storedColorBottom: Color = .green
    
    @AppStorage("longTermGoal") var longTermGoal: String = ""
    @AppStorage("shortTermGoal") var shortTermGoal: String = ""
    
    @AppStorage("hideInfomation") var hideInfomation = false
    
    var startDate: String{
        makeDate(day:days.first?.date ?? Date.now)
    }
    
    var dayNumber: Int{
        days.count + 1
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
                            // MARK: -
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
                            // MARK: -
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
                                Text(isComplete ? "本日のチャレンジは達成済みです。\nお疲れ様でした！" : "今日の取り組みが終わったら、\nボタンを押して完了しよう" )
                                    .lineSpacing(10)
                                    .padding(.vertical, 5)
                                
                                if isComplete{
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
                            isComplete = true
                            showCompleteWindew = true
                        }
                        let day = DailyData(context: moc)
                        day.id = UUID()
                        day.date = Date.now
                        day.memo = ""
                        day.num = Int16(dayNumber)
                        try? moc.save()
                    }, label: {
                        ///CompleteButton(num:52)
                        CompleteButton(num:isComplete ? dayNumber - 1 : dayNumber)
                            .foregroundStyle(.primary)
                            .opacity(isComplete ? 0.3 : 1.0)
                    })
                    
                    // MARK: -
                    .accessibilityLabel("\(isComplete ? dayNumber - 1 : dayNumber)日目を完了する")
                    .padding(.top)
                    .disabled(isComplete)
                    
                    Spacer()
                }
                .accessibilityHidden(showCompleteWindew)
                
                
                
                ///ボタン押下後は完了のビューを重ねて表示
                if showCompleteWindew{
                    CompleteView(showCompleteWindew: $showCompleteWindew)
                        .padding(.horizontal)
                        .transition(.scale)
                }
            }
            
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .userSettingGradient(colors: [storedColorTop, storedColorBottom])
            
            .onAppear{
                ///アプリ起動時に今日のミッションがすでに完了しているか確認
                let todaysData = days.filter{
                    ///CoreDataに保存されたデータの中に今日と同じ日付が存在するか確認
                    Calendar.current.isDate(Date.now, equalTo: $0.date ?? Date.now, toGranularity: .day)
                }
                
                ///もし同日が存在していたら完了フラグをTrueにする
                if todaysData.isEmpty{
                    isComplete = false
                }else{
                    isComplete = true
                }
            }
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
        }
    }
}
