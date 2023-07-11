//
//  ContentView.swift
//  Challenge100days
//
//  Created by koala panda on 2023/01/29.
//

import SwiftUI



struct ContentView: View {
    ///CoreDataに保存したデータ呼び出し用
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key:"date", ascending: true)]) var items: FetchedResults<DailyData>
    
    @AppStorage("longTermGoal") var longTermGoal: String = ""
    @AppStorage("shortTermGoal") var shortTermGoal: String = ""
    
    ///初回起動確認用
    @AppStorage("isFirst") var isFirst = true
    
    ///ページのタグ用の変数
    @State var selected = "One"
    
    
    var body: some View {
        
        if isFirst{
            ///初回起動時はチュートリアルを表示
            TutorialTopView()
        }else{
            ///２回目以降はこっち
            TabView(selection: $selected){
                
                ///達成用のビュー
                ActionView()
                    .tabItem{
                        Label("取り組む", systemImage: "figure.stairs")
                    }.tag("One")
                
                ///実績表示用のビュー
                ListAndCardView()
                    .tabItem{
                        Label("これまでの記録", systemImage: "list.clipboard")
                    }.tag("Two")
                
                SettingView()
                    .tabItem{
                        Label("設定", systemImage: "gearshape")
                    }.tag("Three")
                
            }
            
            .tint(Color(uiColor: UIColor.label))

//            .onAppear{
//                longTermGoal =
//                "Build strength and muscle mass"
//                //"運動の習慣を付けて、健康的な体型を目指す！"
//                shortTermGoal =
//                "Work 2 kilometer without stopping"
//                //"２キロ歩く"
//
//                ///起動時に今日が何日目になるか計算して保存（他のビューで編集するとズレるため）
//                //UserDefaults.standard.set((days.last?.num ?? 0) + 1, forKey: "todayIs")
//                for i in 1...25{
//                    if i == 4 || i == 9 || i == 12 || i == 13 {
//                        continue
//                    }else{
//                        ///申請用のサンプルデータ
//                        let day = DailyData(context: moc)
//                        day.id = UUID()
//                        day.date = Calendar.current.date(byAdding: .day, value: i, to: Date())!
//                        day.memo = ""
//
//                        if i == 1{
//                            day.memo = //"今日から開始。\n頑張って時間作って取り組むぞ！"
//                            "Started today.\nI'll do my best to make time to work on it!"
//                        }
////                        if i == 2{
////                            day.memo = "仕事の後、１時間ほど勉強できた。"
////                        }
////
////                        if i == 5{
////                            day.memo = "昨日は疲れてお休み。代わりに今日は寝る前まで集中した。"
////                        }
////
////                        if i == 7{
////                            day.memo = "仕事の後、１時間ほど勉強できた。"
////                        }
////
////                        if i == 8{
////                            day.memo = "新しい参考書が届いた！"
////                        }
////
////                        if i == 10{
////                            day.memo = "リスニングを集中的に頑張った。"
////                        }
////                        if i == 14{
////                            day.memo = "最近残業続きで休みがちだったけど、今日からまた再開。"
////                        }
////                        day.num = Int16(i)
////                        try? moc.save()
//                    }
//                }
//
//                var counter = Int16(0)
//                    for item in items{
//                        counter += 1
//                        item.num = counter
//                        try? moc.save()
//                }
//            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            ContentView()
                .environment(\.locale, Locale(identifier:"en"))
            ContentView()
                .environment(\.locale, Locale(identifier:"ja"))
        }
    }
}
