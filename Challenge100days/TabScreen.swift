//
//  ContentView.swift
//  Challenge100days
//
//  Created by koala panda on 2023/01/29.
//

import SwiftUI



struct TabScreen: View {
    ///ViewModel用の変数
    @ObservedObject var notificationViewModel = NotificationViewModel()
    @ObservedObject var coreDataViewModel = CoreDataViewModel()
    @ObservedObject var grobalStore = GrobalStore()
    @ObservedObject var store = Store()
    @StateObject private var tutorialVM = TutorialViewModel()
    
    var body: some View {

        if tutorialVM.isFirst{
            //初回起動時はチュートリアルを表示
            TutorialScreen(tutorialVM: tutorialVM)
        }else{
            
            //ユーザーが初回のチュートリアルを終わらせていればタブを表示
            TabView(selection: $store.userSelectedTag){
                //達成用のビュー
                ActionView()
                    .tabItem{
                        Label("取り組む", systemImage: "figure.stairs")
                    }.tag("One")
                
                //実績表示用のビュー
                ListAndCardView()
                    .tabItem{
                        Label("これまでの記録", systemImage: "list.clipboard")
                    }.tag("Two")
                
                //設定用のビュー
                SettingView()
                    .tabItem{
                        Label("設定", systemImage: "gearshape")
                    }.tag("Three")
                
            }
            .tint(.primary)
            .environmentObject(coreDataViewModel)
            .environmentObject(notificationViewModel)
            .environmentObject(grobalStore)
            .environmentObject(store)
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            TabScreen()
                .environment(\.locale, Locale(identifier:"en"))
            TabScreen()
                .environment(\.locale, Locale(identifier:"ja"))
        }
        .environmentObject(NotificationViewModel())
        .environmentObject(CoreDataViewModel())
        .environmentObject(Store())
        .environmentObject(GrobalStore())
    }
}
