//
//  ListAndCardView.swift
//  Challenge100days
//
//  Created by koala panda on 2023/01/31
//

import SwiftUI


///ユーザーが記録を閲覧するためのルートのビュー
struct ListAndCardView: View {
    @Environment(\.managedObjectContext) var veiwContext
    
    ///ViewModel用の変数
    @StateObject var listAndCardVM = ListAndCardViewModel()
    @EnvironmentObject var store: GlobalStore
    
    var body: some View {
        NavigationStack(){
            
            //画面全体はスクロールビュー
            ScrollView(.vertical, showsIndicators: false){
                //カード表示、リスト表示共通部分
                HStack(){
                    Text("開始日 : ") + Text("\(AppSetting.makeDate(day: store.allData.first?.date ?? Date.now))")
                        .font(.footnote)
                    
                    Spacer()
                    
                    //カードとリストの表示を選択するピッカー
                    Picker("", selection: $listAndCardVM.showList){
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
                if listAndCardVM.showList{
                    ListView()
                }else{
                    CardView()
                }
            }
            .foregroundColor(Color(UIColor.label))
            .padding(.horizontal)
            
            //グラデーション背景の設定
            .modifier(UserSettingGradient(appColorNum: listAndCardVM.userSelectedColor))
            
            
            
            //メモ追加ボタンが押下されたら、makeNewItemSheetを表示
            .sheet(isPresented: $listAndCardVM.showSheet) {
                makeNewItemSheet()
            }
            
            //データの新規追加用のプラスボタン
            .toolbar{
                ToolbarItem{
                    Button(action: {
                        listAndCardVM.showSheet = true
                    }, label: {
                        Image(systemName: "plus")
                            .foregroundColor(.primary)
                            .padding(10)
                            .fontWeight(.bold)
                            .background(.thickMaterial)
                            .cornerRadius(10)
                    })
                }
            }


            .navigationTitle("100Days Challenge")
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
        .environmentObject(Store())
    }
}
