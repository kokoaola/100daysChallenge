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
                    Spacer()
                    VStack(alignment: .leading){
                        Text(days.isEmpty ? "開始日 : ----/--/-- " : "開始日 : \( makeDate(day:days.first?.date ?? Date.now))")
                        Text("ビジョン : \(shortTermGoal)")
                        Text("100日取り組んでいること : \(shortTermGoal)")
                    }.foregroundColor(Color(UIColor.label)).padding()
                    
                    
                    SpeechBubble2()
                        .rotation(Angle(degrees: 180))
                        .frame(width: AppSetting.screenWidth * 0.8, height: 80)
                        .foregroundColor(.white)
                        .padding()
                        .overlay{
                            Text(isComplete ? "本日の取り組みは達成済みです。\nお疲れ様でした！" : "今日の取り組みが終わったら、\nボタンを押して完了しよう" )
                                .foregroundColor(.black)
                        }
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
                            .opacity(isComplete ? 0.5 : 1.0)
                    })
                    .disabled(isComplete)
                    
                    HStack{
                        Spacer()
                        Button {
                            showCompleteWindew = true
                        } label: {
                            Image(systemName: "arrow.uturn.left")
                            Text("ウインドウを再表示する")
                        }
                        .foregroundColor(.primary)
                        .padding()
                        .opacity(showCompleteWindew || !isComplete ? 0 : 1.0)
                        .disabled(!isComplete)
                    }


                    Spacer()
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
            
//            .toolbar {
//                ToolbarItem{
//                    NavigationLink(destination: SettingView.init()) {
//                        Image(systemName: "gearshape")
//                    }
//                }
//            }
        }
    }
}

struct ActionView_Previews: PreviewProvider {
    static private var dataController = DataController()
    
    static var previews: some View {
        ActionView()
    }
}
