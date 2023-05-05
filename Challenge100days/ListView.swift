//
//  ListView.swift
//  Challenge100days
//
//  Created by koala panda on 2023/01/31.
//

import SwiftUI
import CoreData

struct ListView: View {
    ///CoreData用の変数
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key:"date", ascending: false)]) var items: FetchedResults<DailyData>
    
    var body: some View {
        
        ///データが一件も存在しない時の表示
        if items.isEmpty{
            VStack{
                Text("まだデータがありません")
                    .foregroundColor(Color(UIColor.label))
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding()
            .background(.thinMaterial)
            .cornerRadius(15)
            
        }else{
            
            VStack(spacing: 5){
                
                ///CoreDataに保存されている全データを取り出す
                ForEach(items) { item in
                    
                    
                    ///タップするとDetailを表示
                    NavigationLink(destination: {
                        
                        DetailView(item: item)
                        
                    }){
                        
                        HStack(alignment: .center){
                            ZStack{
                                ///青いセルに番号を重ねて左端に表示
                                Text("\(item.num)")
                                    .font(.title2) .foregroundColor(.white)
                                    .frame(width: AppSetting.screenWidth * 0.12, height: AppSetting.screenWidth * 0.12)
                                    .background(.blue).cornerRadius(15)
                                
                                ///最終アイテム追加してから１日以内ならキラキラを表示
                                Image(systemName: "sparkles")
                                    .offset(x:14, y:-14)
                                    .foregroundColor(Calendar.current.isDate(Date.now, equalTo: item.date ?? Date.now, toGranularity: .day) ? .yellow : .clear)
                            }
                            .padding(.trailing, 5)
                            
                            ///メモの内容を表示（プレビュー用のため改行はスペースに変換）
                            VStack{
                                Text(item.memo?.replacingOccurrences(of: "\n", with: " ") ?? "")
                                
                                    .lineSpacing(1)
                                    .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .topLeading)
                                    .multilineTextAlignment(.leading)
                                    .foregroundColor(Color(UIColor.label))
                                
                                ///日付を右下に配置
                                Text(makeDate(day: item.date ?? Date()))
                                    .foregroundColor(.secondary)
                                    .frame(maxWidth: .infinity,alignment: .bottomTrailing)
                                
                            }.frame(maxWidth: .infinity,maxHeight: .infinity)
                                .font(.footnote)
                            
                            
                            ///右の矢印
                            Image(systemName: "chevron.forward")
                                .fontWeight(.thin)
                                .foregroundColor(.gray)
                            
                        }
                        ///１行あたり縦が最大150pxまで大きくなれる
                        .frame(maxHeight: 150)
                        .fixedSize(horizontal: false, vertical: true)
                        
                    }
                    
                    ///ラインの表示
                    if (items.firstIndex(of: item) ?? items.count) + 1 < items.count{
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

struct ListView_Previews: PreviewProvider {
    static private var dataController = DataController()
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    
    static var previews: some View {
        ListView()
    }
}

func makeDate(day: Date)-> String{
    let df = DateFormatter()
    df.locale = Locale(identifier: "ja-Jp")
    df.dateStyle = .short
    return df.string(from: day)
}


