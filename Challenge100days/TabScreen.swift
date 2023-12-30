//
//  ContentView.swift
//  Challenge100days
//
//  Created by koala panda on 2023/01/29.
//

import SwiftUI



struct TabScreen: View {
    ///ViewModel用の変数
    @StateObject var listAndCardVM = ListAndCardViewModel()
    @EnvironmentObject var globalStore: GlobalStore
    @StateObject var bigButtonVM = BigButtonViewModel()
    
    var body: some View {

        if listAndCardVM.isFirst{
            //初回起動時はチュートリアルを表示
            TutorialScreen()
        }else{
            
            //ユーザーが初回のチュートリアルを終わらせていればタブを表示
            TabView{
                //達成用のビュー
                ActionView(bigButtonVM: bigButtonVM)
                    .tabItem{
                        Label("取り組む", systemImage: "figure.stairs")
                    }
                
                //実績表示用のビュー
                ListAndCardView(listAndCardVM: listAndCardVM)
                    .tabItem{
                        Label("これまでの記録", systemImage: "list.clipboard")
                    }
                
                //設定用のビュー
//                SettingView()
//                    .tabItem{
//                        Label("設定", systemImage: "gearshape")
//                    }.tag("Three")
                
            }
            .environmentObject(globalStore)
            .tint(.primary)
            
            ///起動時にリストに配列をセットしておく
            .onAppear{
                DispatchQueue.main.async {
                    globalStore.setAllData()
//                    bigButtonVM.setDayNumber(num: globalStore.dayNumber)
                    listAndCardVM.setDailyData(allData: globalStore.allData)
                }
            }
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
        .environmentObject(GlobalStore())
    }
}
