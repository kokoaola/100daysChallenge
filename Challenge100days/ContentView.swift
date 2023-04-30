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
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key:"date", ascending: true)]) var days: FetchedResults<DailyData>
    
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
                        Label("アクション", systemImage: "figure.stairs")
                    }.tag("One")
                
                ///実績表示用のビュー
                ListAndCardView()
                    .tabItem{
                        Label("実績をみる", systemImage: "trophy")
                    }.tag("Two")
                
            }
            
            
            .onAppear{
                
                ///起動時に今日が何日目になるか計算して保存（他のビューで編集するとズレるため）
                UserDefaults.standard.set((days.last?.num ?? 0) + 1, forKey: "todayIs")

            }
            
        }
        

        
    }
}

struct ContentView_Previews: PreviewProvider {
    static private var dataController = DataController()
    
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, dataController.container.viewContext)
    }
}
