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
                VStack{
                    
                    
                    VStack(alignment: .leading, spacing: 15.0){
                        Text(days.isEmpty ? "開始日  :  ----/--/-- " : "開始日 : \( makeDate(day:days.first?.date ?? Date.now))")
                        Text("目指す姿  :  \(longTermGoal)")
                        Text("100日取り組むこと : \(shortTermGoal)")
                    }
                    //.font(.footnote)
                        
                    .frame(width: AppSetting.screenWidth * 0.8, height: 130 ,alignment: .center)
                    .foregroundColor(Color(UIColor.label))
                        .padding()
                        
                    
                    SpeechBubble2()
                        .rotation(Angle(degrees: 180))
                        .foregroundColor(.white)
                        .padding()
                        .overlay{
                            VStack{
                                Text(isComplete ? "本日のチャレンジは達成済みです。\nお疲れ様でした！" : "今日の取り組みが終わったら、\nボタンを押して完了しよう" )
                                    .foregroundColor(.black)
                                if isComplete{
                                    HStack{
                                        
                                        Button {
                                            showCompleteWindew = true
                                        } label: {
                                            Text("ウインドウを再表示する")
                                        }
                                        .foregroundColor(.blue)
                                        //.padding(8)
                                        .padding(.top, 10)
                                        .padding(.trailing, -80)
                                        //.opacity(showCompleteWindew || !isComplete ? 0 : 0.8)
                                        .disabled(!isComplete)
                                    }
                                }
                            }
                        }
                        .frame(width: AppSetting.screenWidth * 0.9, height: 150)
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
                        CompleteButton(num:isComplete ? dayNumber - 1 : dayNumber)
                            .foregroundStyle(.primary)
                            .opacity(isComplete ? 0.3 : 1.0)
                    })
                    .disabled(isComplete)
                    //Spacer()
//                    HStack{
//                        Spacer()
//                        Button {
//                            showCompleteWindew = true
//                        } label: {
//                            Image(systemName: "arrow.uturn.left")
//                            Text("ウインドウを再表示")
//                        }
//                        .foregroundColor(.primary)
//                        .padding(8)
//                        .background(Color(UIColor.systemBackground).opacity(0.4))
//                        .cornerRadius(5)
//                        //.padding()
//                        //.opacity(showCompleteWindew || !isComplete ? 0 : 0.8)
//                        .disabled(!isComplete)
//                    }
//                    .frame(width: AppSetting.screenWidth * 0.8, height: 80)

                    Spacer()
                }


                
                ///ボタン押下後は完了のビューを重ねて表示
                if showCompleteWindew{
                    CompleteView(showCompleteWindew: $showCompleteWindew)
                        .padding()
                        .transition(.scale)
                }
            }
            
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.secondary)
            .foregroundStyle(
                .linearGradient(
                    colors: [storedColorTop, storedColorBottom],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            
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
            .navigationTitle("100days Challenge")
        }
    }
}

struct ActionView_Previews: PreviewProvider {
    static private var dataController = DataController()
    
    static var previews: some View {
        ActionView()
    }
}
