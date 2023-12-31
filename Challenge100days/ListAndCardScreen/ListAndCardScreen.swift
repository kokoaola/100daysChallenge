//
//  ListAndCardView.swift
//  Challenge100days
//
//  Created by koala panda on 2023/01/31
//

import SwiftUI
import CoreData


///ユーザーが記録を閲覧するためのルートのビュー
struct ListAndCardView: View {
    ///ViewModel用の変数
    @ObservedObject var listAndCardVM: ListAndCardViewModel
    @EnvironmentObject var globalStore: GlobalStore
    
    var body: some View {
        //画面全体はスクロールビュー
        ScrollView(.vertical, showsIndicators: false){
            //カードとリスト表示共通部分
            HStack(){
                Text("開始日 : ") + Text("\(AppSetting.makeDate(day: globalStore.allData.first?.wrappedDate ?? Date()))")
                    .font(.footnote)
                
                Spacer()
                
                ///カードとリストの表示を選択するピッカー
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
            
            ///ピッカーの状態に応じてビューを表示
            if listAndCardVM.showList{
                ListView(listAndCardVM: listAndCardVM)
            }else{
                CardView(listAndCardVM: listAndCardVM)
            }
        }
        .foregroundColor(Color(UIColor.label))
        .padding(.horizontal)
        //グラデーション背景の設定
        .modifier(UserSettingGradient(appColorNum: globalStore.userSelectedColor))
        
        //メモ追加ボタンが押下されたら、makeNewItemSheetを表示
        .sheet(isPresented : $listAndCardVM.showSheet , onDismiss : {
            //シートが閉じられた時には配列をビューに再セット（onAppearが適用されないため）
            withAnimation {
                listAndCardVM.setDailyData(allData: globalStore.allData)
            }
        }) {
            makeNewItemSheet()
        }
        
        //ビュー表示時に最新のリストをセットする
        .onAppear{
            print("LIST AND CARD", listAndCardVM.allData.count)
            withAnimation {
                listAndCardVM.setDailyData(allData: globalStore.allData)
            }
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
        .embedInNavigationStack()
    }
}



//struct ListAndCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group{
//            ListAndCardView()
//                .environment(\.locale, Locale(identifier:"en"))
//            ListAndCardView()
//                .environment(\.locale, Locale(identifier:"ja"))
//        }
//        .environmentObject(NotificationViewModel())
//        .environmentObject(CoreDataViewModel())
//        .environmentObject(Store())
//    }
//}
//struct ListAndCardView_Previews: PreviewProvider {
//    static private var dataController = PersistenceController.persistentContainer.viewContext
////    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
//
//    static var previews: some View {
//
//        ListAndCardView()
//            .environment(\.managedObjectContext, PersistenceController.persistentContainer.viewContext)
//            .environmentObject(GlobalStore())
//    }
//}


