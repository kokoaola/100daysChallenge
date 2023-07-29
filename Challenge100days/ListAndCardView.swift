//
//  ListAndCardView.swift
//  Challenge100days
//
//  Created by koala panda on 2023/01/31./Users/koalapanda/Desktop/作ってるアプリ/Challenge100days/Challenge100days/CompleteView.swift
//

import SwiftUI


///ユーザーが記録を閲覧するためのルートのビュー
struct ListAndCardView: View {
    
    ///ViewModel用の変数
    @EnvironmentObject var notificationViewModel: NotificationViewModel
    @EnvironmentObject var coreDataViewModel: CoreDataViewModel
    @EnvironmentObject var userSettingViewModel: UserSettingViewModel
    
    ///アイテム新規追加用シート格納変数
    @State private var showSheet = false
    
    ///リストで表示が選択されたときのフラグ
    @State private var showList = true
    
    var body: some View {
        NavigationStack(){
            
            //画面全体はスクロールビュー
            ScrollView(.vertical, showsIndicators: false){
                
                //カード表示、リスト表示共通部分
                HStack(){
                    Text("開始日 : ") + Text("\(AppSetting.makeDate(day:coreDataViewModel.allData.first?.date ?? Date.now))")
                        .font(.footnote)
                    
                    Spacer()
                    
                    //カードとリストの表示を選択するピッカー
                    Picker("", selection: $showList){
                        Text("カード")
                            .tag(false)
                        Text("リスト")
                            .tag(true)
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 150)
                    .padding(.vertical, 5)
                    
                }
                
                //ピッカーの状態に応じてビューを表示
                if showList{
                    ListView()
                }else{
                    CardView()
                }
            }
            .environmentObject(notificationViewModel)
            .environmentObject(coreDataViewModel)
            .foregroundColor(Color(UIColor.label))
            .padding(.horizontal)
            
            //グラデーション背景の設定
            .modifier(UserSettingGradient(appColorNum: userSettingViewModel.userSelectedColor))
            
            //データの新規追加用のプラスボタン
            .toolbar{
                ToolbarItem{
                    Button(action: {
                        showSheet.toggle()
                    }, label: {
                        Image(systemName: "plus")
                    })
                }
            }
            
            //プラスボタンを押したら出てくるシート
            .sheet(isPresented: $showSheet, content: makeNewItemSheet.init)
            .environmentObject(notificationViewModel)
            .environmentObject(coreDataViewModel)
            .navigationTitle("100days Challenge")
            .navigationBarTitleDisplayMode(.automatic)
            
        }
    }
}



struct ListAndCardView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            ListAndCardView()
                .environment(\.locale, Locale(identifier:"en"))
            ListAndCardView()
                .environment(\.locale, Locale(identifier:"ja"))
        }
        .environmentObject(NotificationViewModel())
        .environmentObject(CoreDataViewModel())
        .environmentObject(UserSettingViewModel())
    }
}
