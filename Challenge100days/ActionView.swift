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
                    VStack(alignment: .leading){
                        Text("100日チャレンジ中 : \(shortTermGoal)")
                        Text(days.isEmpty ? "開始日 : ----/--/-- " : "開始日 : \( makeDate(day:days.first?.date ?? Date.now))")
                    }.foregroundColor(Color(UIColor.label)).padding()
                    
                    ///Completeボタンが押されたら本日分のDailyDataを保存
                    Button(action: {
                        
                        
                        if !isComplete{
                            withAnimation{
                                isComplete = true
                            }
                            
                            let day = DailyData(context: moc)
                            day.id = UUID()
                            day.date = Date.now
                            day.memo = ""
                            day.num = Int16(dayNumber)
                            try? moc.save()
                            
                        }

                    
                    }, label: {
                        CompleteButton(num: dayNumber)
                            .foregroundStyle(.primary)
                    })
                }


                
                ///ボタン押下後は完了のビューを重ねて表示
                if isComplete{
                    CompleteView(isComplete: $isComplete)
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
