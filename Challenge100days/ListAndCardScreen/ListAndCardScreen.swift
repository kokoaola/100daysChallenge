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
    @EnvironmentObject var coreDataStore: CoreDataStore
    
    var body: some View {
        //画面全体はスクロールビュー
        ScrollView(.vertical, showsIndicators: false){
            //カードとリスト表示共通部分
            HStack(){
                Text("開始日 : ") + Text("\(AppSetting.makeDate(day: coreDataStore.allData.first?.wrappedDate ?? Date()))")
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
            
            ///ピッカーの状態に応じて表示するビューを切り替える
            if listAndCardVM.showList{
                ListView(listAndCardVM: listAndCardVM)
            }else{
                CardView(listAndCardVM: listAndCardVM)
            }
        }
        .foregroundColor(Color(UIColor.label))
        .padding(.horizontal)
        //グラデーション背景の設定
        .modifier(UserSettingGradient())
        
        //メモ追加ボタンが押下されたら、makeNewItemSheetを表示
        .sheet(isPresented : $listAndCardVM.showSheet , onDismiss : {
            //シートが閉じられた時の処理のクロージャ
            withAnimation {
                //配列をビューに再セット（onAppearが適用されないため）
                listAndCardVM.setDailyData(allData: coreDataStore.allData)
            }
        }) {
            makeNewItemSheet()
        }
        
        //ビュー表示時に最新のリストをセットする
        .onAppear{
            //DetailScreenから戻った時は処理をスキップ（DetailScreenの画面破棄時に同じ処理をしているため）
            if coreDataStore.isReturningFromDetailScreen{
                return
            }else{
                withAnimation {
                    listAndCardVM.setDailyData(allData: coreDataStore.allData)
                }
            }
        }
        
        //データの新規追加用のプラスボタン
        .toolbar{
            ToolbarItem{
                Button(action: {
                    listAndCardVM.showSheet = true
                }, label: {
                    PlusButtonView()
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


