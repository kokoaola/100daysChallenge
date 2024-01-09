//
//  ListView.swift
//  Challenge100days
//
//  Created by koala panda on 2023/01/31.
//

import SwiftUI


///リスト形式で表示するビュー
struct ListView: View {
    ///ViewModel用の変数
    @ObservedObject var listAndCardVM: ListAndCardViewModel
    
    var body: some View {
        
        ///データが一件も存在しない時の表示
        if listAndCardVM.allData.isEmpty{
            NoDataView()
            
        ///データが存在するときの表示
        }else{
            VStack(spacing: 5){
                //CoreDataに保存されている全データを取り出す
                ForEach(listAndCardVM.allData.reversed(), id:\.self) { item in

                    //セルをタップするとDetailViewに遷移
                    NavigationLink(destination: {
                        DetailScreen(item: item){ items in
                            //DetailViewの削除ボタンが押された時の処理のクロージャ
                            listAndCardVM.setDailyData(allData: items)
                        }
                    }){
                        ///itemを渡すと再描写が反映されない
                        ListLowView(num: item.wrappedNum, date: item.wrappedDate, memo: item.wrappedMemo)
                    }

                    //ラインの表示
                    if item != listAndCardVM.allData.first{
                        Divider()
                            .padding(.vertical, 5)
                    }
                }
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding()
            .background(.thinMaterial)
            .cornerRadius(15)
        }
        
    }
}



//struct ListView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group{
//            ListView()
//                .environment(\.locale, Locale(identifier:"en"))
//            ListView()
//                .environment(\.locale, Locale(identifier:"ja"))
//        }.environmentObject(NotificationViewModel())
//            .environmentObject(CoreDataViewModel())
//    }
//}
