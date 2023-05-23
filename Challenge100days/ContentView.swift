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

            .onAppear{
                
                ///起動時に今日が何日目になるか計算して保存（他のビューで編集するとズレるため）
                //UserDefaults.standard.set((days.last?.num ?? 0) + 1, forKey: "todayIs")
                ///申請用のサンプルデータ
                
                

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
