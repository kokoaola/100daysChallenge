//
//  ContentView.swift
//  Challenge100days
//
//  Created by koala panda on 2023/01/29.
//

import SwiftUI



struct ContentView: View {
    ///ViewModel用の変数
    @ObservedObject var notificationViewModel = NotificationViewModel()
    @ObservedObject var coreDataViewModel = CoreDataViewModel()
    @ObservedObject var userSettingViewModel = UserSettingViewModel()
    
    
    var body: some View {

        if userSettingViewModel.isFirst{
            //初回起動時はチュートリアルを表示
            TutorialTopView()
                .environmentObject(userSettingViewModel)
            
        }else{
            
            //ユーザーが初回のチュートリアルを終わらせていればタブを表示
            TabView(selection: $userSettingViewModel.userSelectedTag){
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
            .environmentObject(userSettingViewModel)

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
