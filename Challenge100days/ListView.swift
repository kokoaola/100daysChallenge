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
    @EnvironmentObject var notificationViewModel :NotificationViewModel
    
    var body: some View {
        
        ///データが一件も存在しない時の表示
        if items.isEmpty{
            
            VStack{
                Spacer()
                Text("まだデータがありません")
                    .foregroundColor(Color(UIColor.label))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    .background(.thinMaterial)
                    .cornerRadius(15)
                    
                Spacer()
            }
            //.frame(height: AppSetting.screenWidth)
                
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
                                    .background(.blue)
                                    .cornerRadius(15)
                                
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
                                Text(item.date ?? Date(), format:.dateTime.day().month().year())
//                                Text(makeDate(day: item.date ?? Date()))
                                    .foregroundColor(.secondary)
                                    .frame(maxWidth: .infinity,alignment: .bottomTrailing)
                                
                            }.frame(maxWidth: .infinity,maxHeight: .infinity)
                                .font(.footnote)
                            
                            
                            ///右の矢印
                            Image(systemName: "chevron.forward")
                                .fontWeight(.thin)
                                .foregroundColor(.gray)
                            
                        }
                        .accessibilityElement()
                        .accessibilityLabel("\(item.num)日目の記録、\(item.date ?? Date(), format:.dateTime.day().month().year())")
                        .accessibilityAddTraits(.isLink)
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
            .environmentObject(notificationViewModel)
            .fixedSize(horizontal: false, vertical: true)
            .padding()
            .background(.thinMaterial)
            .cornerRadius(15)
        }
        
    }
}

func makeDate(day: Date)-> String{
    let df = DateFormatter()
    df.locale = Locale(identifier: "ja-Jp")
    df.dateStyle = .short
    return df.string(from: day)
}

func makeAccessibilityDate(day: Date) -> String {
    let df = DateFormatter()
    df.locale = Locale(identifier: "ja_JP")
    df.dateFormat = "yyyy年M月d日"
    return df.string(from: day)
}


struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            ListView()
                .environment(\.locale, Locale(identifier:"en"))
            ListView()
                .environment(\.locale, Locale(identifier:"ja"))
        }.environmentObject(NotificationViewModel())
    }
}
