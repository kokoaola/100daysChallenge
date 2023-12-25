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
    @EnvironmentObject var notificationViewModel :NotificationViewModel
    @EnvironmentObject var coreDataViewModel :CoreDataViewModel
    
    
    var body: some View {
        
        ///データが一件も存在しない時の表示
        if coreDataViewModel.allData.isEmpty{
            Text("まだデータがありません")
                .foregroundColor(Color(UIColor.label))
                .frame(maxWidth: .infinity, alignment: .center)
                .padding()
                .background(.thinMaterial)
                .cornerRadius(15)
        }else{
            
            VStack(spacing: 5){
                
                //CoreDataに保存されている全データを取り出す
                ForEach(coreDataViewModel.allData.reversed()) { item in
                    
                    //セルをタップするとDetailViewを表示
                    NavigationLink(destination: {
                        DetailView(item: item)
                    }){
                        
                        //セル部分のレイアウト
                        HStack(alignment: .center){
                            ZStack{
                                
                                //青い四角に番号を重ねて左端に表示
                                Text("\(item.num)")
                                    .font(.title2) .foregroundColor(.white)
                                    .frame(width: AppSetting.screenWidth * 0.12, height: AppSetting.screenWidth * 0.12)
                                    .background(.blue)
                                    .cornerRadius(15)
                                
                                //最終アイテム追加してから１日以内なら、日付にキラキラを重ねて表示
                                Image(systemName: "sparkles")
                                    .offset(x:14, y:-14)
                                    .foregroundColor(Calendar.current.isDate(Date.now, equalTo: item.date ?? Date.now, toGranularity: .day) ? .yellow : .clear)
                            }
                            .padding(.trailing, 5)
                            
                            //メモの内容を表示
                            VStack{
                                Text(item.memo?.replacingOccurrences(of: "\n", with: " ") ?? "")
                                //プレビュー用しやすいように改行はスペースに変換
                                    .lineSpacing(1)
                                    .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .topLeading)
                                    .multilineTextAlignment(.leading)
                                    .foregroundColor(Color(UIColor.label))
                                
                                //日付を右下に配置
                                Text(item.date ?? Date(), format:.dateTime.day().month().year())
                                    .foregroundColor(.secondary)
                                    .frame(maxWidth: .infinity,alignment: .bottomTrailing)
                                
                            }.frame(maxWidth: .infinity,maxHeight: .infinity)
                                .font(.footnote)
                            
                            //右の矢印
                            Image(systemName: "chevron.forward")
                                .fontWeight(.thin)
                                .foregroundColor(.gray)
                            
                        }
                        .accessibilityElement()
                        .accessibilityLabel("\(item.num)日目の記録、\(item.date ?? Date(), format:.dateTime.day().month().year())")
                        .accessibilityAddTraits(.isLink)
                        
                        //セルの高さは最大150pxまで大きくなれる
                        .frame(maxHeight: 150)
                        .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    //ラインの表示
                    if item != coreDataViewModel.allData.first{
                        Divider()
                            .padding(.vertical, 5)
                    }
                }
            }
            .environmentObject(notificationViewModel)
            .fixedSize(horizontal: false, vertical: true)
            .padding()
            .background(.thinMaterial)
            .cornerRadius(15)
        }
        
    }
}



struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            ListView()
                .environment(\.locale, Locale(identifier:"en"))
            ListView()
                .environment(\.locale, Locale(identifier:"ja"))
        }.environmentObject(NotificationViewModel())
            .environmentObject(CoreDataViewModel())
    }
}
