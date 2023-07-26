//
//  ContentView.swift
//  Challenge100days
//
//  Created by koala panda on 2023/01/29.
//

import SwiftUI



struct ContentView: View {
    
    
    @ObservedObject var notificationViewModel = NotificationViewModel()
    @ObservedObject var coreDataViewModel = CoreDataViewModel()
    @ObservedObject var userSettingViewModel = UserSettingViewModel()
    
    //    /CoreDataに保存したデータ呼び出し用
    //    @Environment(\.managedObjectContext) var moc
    //    @FetchRequest(sortDescriptors: [NSSortDescriptor(key:"date", ascending: true)]) var items: FetchedResults<DailyData>
    
    
    //    ///初回起動確認用
    //    @AppStorage("isFirst") var isFirst = true
    
    ///ページのタグ用の変数
    //    @State var selected = "One"
    
    var body: some View {
        
        //        ユーザーが初回のチュートリアルを終わらせていればタブを表示
        if userSettingViewModel.finishedTutorial{
            TabView(selection: $userSettingViewModel.userSelectedTag){
                
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
            .tint(.primary)
            .environmentObject(coreDataViewModel)
            .environmentObject(notificationViewModel)
            .environmentObject(userSettingViewModel)
            
        }else{
            //            初回起動時はチュートリアルを表示
            TutorialTopView()
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
        .environmentObject(NotificationViewModel())
        .environmentObject(CoreDataViewModel())
        .environmentObject(UserSettingViewModel())
    }
}
