//
//  ContentView.swift
//  Challenge100days
//
//  Created by koala panda on 2023/01/29.
//

import SwiftUI



struct ContentView: View {
    
    
    @State var notificationViewModel = NotificationViewModel()
    
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
            .environmentObject(notificationViewModel)
            .tint(Color(uiColor: UIColor.label))
            .onAppear{
//                notificationViewModel.getAll()
//                print("通知は：\(notificationViewModel.isNotificationOn)")
//                print("今日のタスクは\(notificationViewModel.checkTodaysTask(item: items.last))")
            }

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
        }.environmentObject(NotificationViewModel())
    }
}
