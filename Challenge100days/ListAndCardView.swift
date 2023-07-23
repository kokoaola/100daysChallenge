//
//  ListAndCardView.swift
//  Challenge100days
//
//  Created by koala panda on 2023/01/31./Users/koalapanda/Desktop/作ってるアプリ/Challenge100days/Challenge100days/CompleteView.swift
//

import SwiftUI


extension AnyTransition {
    static var moveAndFade: AnyTransition {
        .asymmetric(
            insertion: .offset(x: 0, y: -30).combined(with: .opacity),
            //insertion: .move(edge: .trailing).combined(with: .opacity),
            removal: .offset(x: 0, y: -30).combined(with: .opacity)
        )
        
    }
}


struct ListAndCardView: View {
    @EnvironmentObject var notificationViewModel :NotificationViewModel
    ///CoreData用の変数
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key:"date", ascending: true)]) var items: FetchedResults<DailyData>
    
    @AppStorage("colorkeyTop") var storedColorTop: Color = .blue
    @AppStorage("colorkeyBottom") var storedColorBottom: Color = .green
    
    ///アイテム新規追加用シート格納変数
    @State var showSheet = false
    
    ///リストで表示が選択されたときのフラグ
    @State var showList = true
    
    var body: some View {
        NavigationStack(){
            
            ///画面全体のスクロールビュー
            ScrollView(.vertical, showsIndicators: false){
                
                HStack(){
                    Text("開始日 : ") + Text("\(makeDate(day:items.first?.date ?? Date.now))")
                        .font(.footnote)
                    
                    Spacer()
                    Picker("", selection: $showList){
                        Text("カード")
                            .tag(false)
                        Text("リスト")
                            .tag(true)
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 150)
                    .padding(.vertical, 5)
                    
                }
                
                ///リストで表示がONになっていてばリストビューを表示
                if showList{
                    ListView()
                }else{
                    CardView()
                }
            }
            .environmentObject(notificationViewModel)
            .foregroundColor(Color(UIColor.label))
            .padding(.horizontal)
            
            ///グラデーション背景設定
            .userSettingGradient(colors: [storedColorTop, storedColorBottom])
            
            .onAppear{
                Task{
                    await reNumber()
                }
            }
            
            .toolbar{
                ///新規追加用のプラスボタン
                ToolbarItem{
                    Button(action: {
                        showSheet.toggle()
                    }, label: {
                        Image(systemName: "plus")
                    })
                }
                
                
            }
            
            .sheet(isPresented: $showSheet, content: makeNewItemSheet.init)
            .navigationTitle("100days Challenge")
            .navigationBarTitleDisplayMode(.automatic)
            
        }
    }
    
    ///データ保存後の番号振り直し用の関数
    func reNumber() async{
        await MainActor.run{
            var counter = Int16(0)
            for item in items{
                counter += 1
                item.num = counter
                try? moc.save()
            }
        }
    }
}



struct ListAndCardView_Previews: PreviewProvider {
    static private var dataController = DataController()
    static var previews: some View {
        Group{
            ListAndCardView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environment(\.locale, Locale(identifier:"en"))
            ListAndCardView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environment(\.locale, Locale(identifier:"ja"))
        }
        .environmentObject(NotificationViewModel())
    }
}
