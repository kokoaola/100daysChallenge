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
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key:"date", ascending: true)]) var items: FetchedResults<DailyData>
    
    var body: some View {

        
        VStack(spacing: 5){
            
            ///CoreDataに保存されている全データを取り出す
            ForEach(items) { item in
                
                ///タップするとDetailを表示
                NavigationLink(destination: {
                    DetailView(item: item)
                }){
                    
                    HStack{

                           ZStack{
                            
                            ///青いセルに番号を重ねて左端に表示
                            Text("\(item.num)")
                                .font(.title2) .foregroundColor(.white)
                                .frame(width: AppSetting.screenWidth * 0.12, height: AppSetting.screenWidth * 0.12)
                                .background(.blue).cornerRadius(15)
                                .padding(.trailing)
                                .frame(maxHeight: .infinity, alignment: .top)
                            
                            ///最終アイテム追加してから１日以内ならキラキラを表示
                            Image(systemName: "sparkles")
                                .offset(x:8, y:-9)
                                .foregroundColor(item == items.last && Calendar.current.isDate(Date.now, equalTo: item.date ?? Date.now, toGranularity: .day) ? .yellow : .clear)
                            
                        }
                        
                        ///メモの内容を表示（プレビュー用のため改行はスペースに変換）
                        VStack(alignment: .leading){
                            Text(item.memo?.replacingOccurrences(of: "\n", with: " ") ?? "")
                                .lineSpacing(1)
                                .multilineTextAlignment(.leading)
                                .foregroundColor(Color(UIColor.label))

                            ///日付を右下に配置
                            Text(makeDate(day: item.date ?? Date()))
                                .foregroundColor(.secondary)
                                .frame(maxWidth: .infinity,alignment: .bottomTrailing)
                                .offset(y:5)
                            
                        }.font(.footnote)
                        
                    }
                    ///１行あたり最大150pxまで大きくなれる
                    .frame(maxHeight: 150)
                    .fixedSize(horizontal: false, vertical: true)
                    
                }
                
                ///ラインの表示
                if (items.firstIndex(of: item) ?? items.count) + 1 < items.count{
                    Divider()
                }
                
            }
        }
        
        .fixedSize(horizontal: false, vertical: true)
        .padding()
        .background(.thinMaterial)
        .cornerRadius(15)
        
    }
}

struct ListView_Previews: PreviewProvider {
    static private var dataController = DataController()
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    
    static var previews: some View {
        
        ListView()
        // .environment(\.managedObjectContext, dataController.container.viewContext)
    }
}

func makeDate(day: Date)-> String{
    let df = DateFormatter()
    df.locale = Locale(identifier: "ja-Jp")
    df.dateStyle = .short
    return df.string(from: day)
}


//static var previews: some View {
//    let book = Book(context: moc)
//
//    //book.id = UUID()
//    book.title = "Test book"
//    book.author = "Test author"
//    book.genre = "Horror"
//    book.rating = 4
//    book.review = "This was a great book; I really enjoyed it."
//    return NavigationView {
//        DetailView(book: book)
//    }
//    }
