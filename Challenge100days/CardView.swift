//
//  CardView.swift
//  Challenge100days
//
//  Created by koala panda on 2023/01/30.
//

import SwiftUI

struct CardView: View {
    ///CoreData用の変数
//    @Environment(\.managedObjectContext) var moc
//    @FetchRequest(sortDescriptors: [NSSortDescriptor(key:"date", ascending: true)]) var days: FetchedResults<DailyData>

    @EnvironmentObject var notificationViewModel :NotificationViewModel
    @EnvironmentObject var coreDataViewModel :CoreDataViewModel
    
    ///グリッドレイアウトの設定用変数
    let columns = Array(repeating: GridItem(.flexible()), count: 10)
    
    
    var body: some View {
        
        ///ビュー重ねる用のZStack
        ZStack(alignment: .top){
            
            
            ///背景の空白グリッド表示用のビュー
            LazyVGrid(columns: columns) {
                ForEach(1...100, id: \.self) { num in
                    VStack(spacing: -3){
                        
                        ///100マス目の王冠表示用
                        Image(systemName: "crown.fill")
                            .foregroundColor(num == 100 ? .yellow : .clear)
                        
                        ZStack{
                            ///空白のマスを１００個
                            Image(systemName:"app")
                                .font(.title.weight(.thin))
                                .foregroundColor(.gray)
                                .opacity(0.3)
                            
                            ///１０個ずつ番号をつける
                            Text((num % 10 == 0) ? "\(num)" : "")
                                .font(.footnote)
                                .foregroundColor(.gray)
                                .opacity(0.5)
                        }
                    }
                    .accessibilityHidden(true)
                }
            }//背面のグリッドビューここまで
            
            
            
            ///前面の塗りつぶしセル表示用ビュー（タップした時のリンク先は詳細ビュー）
            LazyVGrid(columns: columns) {
                
                ///CoreDataに保存されている全データを取り出す
                ForEach(coreDataViewModel.allData, id: \.self) { item in
//                    遷移先はDetailView
                    NavigationLink(destination: {
                        DetailView(item: item)
                    }){
                        
                        VStack(spacing: -3){
                            ///ダミー用の王冠（これがないと後ろのセルとずれちゃう）
                            Image(systemName: "crown.fill").foregroundColor(.clear)
                            
                            ZStack{
                                ///日数に応じて青いセルを表示する
                                Image(systemName:"app.fill")
                                    .font(.title.weight(.thin))
                                    .foregroundColor(.blue)
                                
                                
                                ///最終アイテム追加してから１日以内ならキラキラを表示
                                Image(systemName: "sparkles")
                                    .offset(x:8, y:-9)
                                    .foregroundColor(item == coreDataViewModel.allData.last && Calendar.current.isDate(Date.now, equalTo: item.date ?? Date.now, toGranularity: .day) ? .yellow : .clear)
                                
                                ///セルに番号を重ねる
                                Text("\(item.num)")
                                    .font(.footnote)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    
                    .accessibilityElement()
                    .accessibilityLabel("\(item.num)日目の記録")
                }
            }//全面のグリッドビューここまで
            .environmentObject(notificationViewModel)
            .environmentObject(coreDataViewModel)
        }
        
        .padding()
        .fixedSize(horizontal: false, vertical: true)
        .background(.thinMaterial)
        .cornerRadius(15)
        
    }
    
}



struct CardView_Previews: PreviewProvider {
//    static private var dataController = DataController()
    static var previews: some View {
        Group{
            CardView()
                .environment(\.locale, Locale(identifier:"en"))
            CardView()
                .environment(\.locale, Locale(identifier:"ja"))
        }.environmentObject(NotificationViewModel())
            .environmentObject(CoreDataViewModel())
    }
}


