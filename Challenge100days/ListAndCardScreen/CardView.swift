//
//  CardView.swift
//  Challenge100days
//
//  Created by koala panda on 2023/01/30.
//

import SwiftUI


///カード形式で表示するビュー
struct CardView: View {
    ///ViewModel用の変数
    @ObservedObject var listAndCardVM: ListAndCardViewModel
    ///グリッドレイアウトの設定用変数
    let columns = Array(repeating: GridItem(.flexible()), count: 10)
    
    
    var body: some View {
        //ビュー重ねる用のZStack
        ZStack(alignment: .top){
            ///背景の空白グリッド表示用のビュー
            LazyVGrid(columns: columns) {
                ForEach(1...100, id: \.self) { num in
                    CardBackComponents(num: num)
                }
            }//背面のビューここまで
            
            ///前面の青いセルのビュー（タップした時のリンク先は詳細ビュー）
            LazyVGrid(columns: columns) {
                
                //CoreDataに保存されている全データを取り出す
                ForEach(listAndCardVM.allData, id: \.self) { item in
                    //遷移先はDetailView
                    NavigationLink(destination: {
                        DetailScreen(item: item){ items in
                            //DetailViewの削除ボタンが押された時の処理のクロージャ
                            listAndCardVM.setDailyData(allData: items)
                        }
                    }){
                        CardFrontComponents(num: item.wrappedNum, date: item.wrappedDate)
                    }
                    .accessibilityElement()
                    .accessibilityLabel("\(item.num)日目の記録")
                }
            }//全面のビューここまで
        }
        .padding()
        .fixedSize(horizontal: false, vertical: true)
        .background(.thinMaterial)
        .cornerRadius(15)
    }
}



//struct CardView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group{
//            CardView()
//                .environment(\.locale, Locale(identifier:"en"))
//            CardView()
//                .environment(\.locale, Locale(identifier:"ja"))
//        }.environmentObject(NotificationViewModel())
//            .environmentObject(CoreDataViewModel())
//    }
//}


