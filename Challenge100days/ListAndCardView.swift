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
                    Spacer()
                    Picker("", selection: $showList){
                        Text("カード")
                            .tag(false)
                        Text("リスト")
                            .tag(true)
                    }.pickerStyle(.segmented)
                        .frame(width: 150)
                        .padding(.vertical, 5)
                        
//                    Text("リストで表示")
//                        .onTapGesture {
//                            showList.toggle()
//                        }
//                    Toggle("", isOn: $showList)
//                        .labelsHidden()
//                        .tint(.green)
//                        .padding(.trailing, 10)
//                        .multilineTextAlignment(.trailing)
                }//.padding(.vertical)
                
                ///リストで表示がONになっていてばリストビューを表示
                if showList{
                    
                    if items.isEmpty{
                        NoDataListView()
                    }else{
                        ListView()
                            .transition(.moveAndFade)
                    }
                        
                        //.transition(.moveAndFade)
                }else{
                    CardView()
                        .transition(.moveAndFade)
                }
                
                ///カードのビュー表示
                //CardView()
                
                
                ///ここからリストのビュー
//                VStack(){
//                    ///リスト非表示用のヘッダー
//                    HStack{
//                        Text("リストで表示")
//                        Image(systemName: "chevron.right.circle")
//                            .imageScale(.large)
//                            .fontWeight(.thin)
//                            .rotationEffect(.degrees(showList ? 90 : 0))
//                            .animation(.spring(), value: showList)
//
//                    }
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .padding(.top)
//                    .onTapGesture {
//                        withAnimation{
//                            showList.toggle()
//                        }
//                    }
//
////                    ///リストで表示がONになっていてばリストビューを表示
////                    if showList && !items.isEmpty{
////                        ListView().transition(.moveAndFade)
////                    }else if showList && items.isEmpty{
////                        NoDataListView().transition(.moveAndFade)
////                    }
//
//                }//リストここまで
            }//スクロールビューここまで
            .foregroundColor(Color(UIColor.label))
            
            ///グラデーション背景設定
            .padding(.horizontal)
            .background(.secondary)
            .foregroundStyle(
                .linearGradient(
                    colors: [storedColorTop, storedColorBottom],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            
            
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
}

struct ListAndCardView_Previews: PreviewProvider {
    static private var dataController = DataController()
    //@State static var path = [String]()
    
    static var previews: some View {
        ListAndCardView()
            .environment(\.managedObjectContext, dataController.container.viewContext)
    }
}
