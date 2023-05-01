//
//  MemoView.swift
//  Challenge100days
//
//  Created by koala panda on 2023/02/04.
//

import SwiftUI
import CoreData

extension View {
    func endEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


struct DetailView: View {
    ///CoreData用の変数
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key:"date", ascending: true)]) var days: FetchedResults<DailyData>
    @Environment(\.managedObjectContext) var moc
    
    ///画面破棄用の変数
    @Environment(\.dismiss) var dismiss
    
    ///ビュー生成時にオブジェクトデータ受け取る用変数
    let item: DailyData
    
    ///削除ボタン押下後の確認アラート用のフラグ
    @State private var showCansel = false
    
    ///入力したテキストを格納するプロパティ
    @State private var editText = ""
    
    ///シェア用の画像格納用変数
    @State var image: Image?
    
    ///表示されているデータが何日目か表示するのに使う変数
    @State var num: Int? = nil
    
    
    ///キーボードフォーカス用変数（Doneボタン表示のため）
    @FocusState var isInputActive: Bool
    
    @AppStorage("colorkeyTop") var storedColorTop: Color = .blue
    @AppStorage("colorkeyBottom") var storedColorBottom: Color = .green
    
    var body: some View {
        NavigationStack{
            
            
            VStack{
                
                
                HStack{
                    
                    ///日付けのセルは通常モードの時と同じ
                    Text("\(num ?? 1) / 100")
                        .font(.title)
                    
                    Spacer()
                    
                    
                    ///日付表示
                    Text(makeDate(day: item.date ?? Date.now))
                        .font(.title3.weight(.ultraLight))
                        .padding(.leading, 40)
                }
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                
                ///メモ編集用のテキストエディター
                TextEditor(text: $editText)
                    .lineSpacing(2)
                    .scrollContentBackground(Visibility.hidden)
                    .frame(maxHeight: .infinity)
                    .focused($isInputActive)
                    .tint(.white)
                
                
                
                
            }
            
            .padding()
            .frame(maxHeight: AppSetting.screenHeight / 1.4)
            .background(.thinMaterial)
            .cornerRadius(15)
            .foregroundColor(.primary)
            .padding(.top, -50)
            
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(.ultraThinMaterial)
            .background(.secondary)
            .foregroundStyle(
                .linearGradient(
                    colors: [storedColorTop, storedColorBottom],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        }
        
        
        
        
        
        
        .onAppear{
            ///アクションタブの方から削除済みのアイテムを詳細を表示していた時に、空白の画面が表示されてしまう問題を避けるための処理
            if days.firstIndex(of: item) == nil{
                dismiss()
            }
            
            ///シェア用の画像を生成
            image = generateImageWithText(number: Int(item.num), day: item.date ?? Date.now)
            
            ///その他の初期設定
            editText = item.memo ?? ""
            num =  Int(item.num)
        }
        
        
        
        .toolbar{
            
            ///キーボード閉じるボタンを配置
            ToolbarItemGroup(placement: .keyboard) {
                
                Spacer()
                
                Button("保存") {
                    Task{
                        await save()
                    }
                    isInputActive = false
                }
            }
            
            
            
            ///アイテム削除用ごみ箱アイコン
            ToolbarItem(placement: .navigationBarTrailing){
                Button {
                    showCansel = true
                } label: {
                    Image(systemName: "trash")
                }
                .foregroundColor(.red)
                .padding(.trailing)
            }
            
            ///画像シェア用のリンク
            ToolbarItem(placement: .navigationBarTrailing) {
                ShareLink(item: image ?? Image("noImage") , preview: SharePreview("画像", image:image ?? Image("noImage") )){
                    Image(systemName: "square.and.arrow.up")
                    
                }
            }
            
            
        }
        .foregroundColor(Color(UIColor.label))
        ///削除ボタン押下時のアラート
        .alert("この日の記録を破棄しますか？", isPresented: $showCansel){
            Button("破棄する",role: .destructive){
                Task{
                    await  delete()
                    await reNumber()
                }
                
                
                dismiss()
            }
            Button("戻る",role: .cancel){}
        }message: {
            Text("表示中のデータは破棄されます。\n（この動作は取り消せません。）")
        }
    }
    
    ///データ保存用関数
    func save() async{
        await MainActor.run{
            item.memo = editText
            try? moc.save()
            isInputActive = false
        }
    }
    
    
    ///データ保存後の番号振り直し用の関数
    func reNumber() async{
        var counter = Int16(0)
        for i in days{
            counter += 1
            i.num = counter
            try? moc.save()
            UserDefaults.standard.set(days.count + 1, forKey: "todayIs")
        }
    }
    
    ///削除用の関数
    func delete() async{
        moc.delete(item)
        try? moc.save()
        
        var counter = Int16(0)
        for i in days{
            counter += 1
            i.num = counter
            try? moc.save()
        }
    }
    
}

//
//struct MemoView_Previews: PreviewProvider {
//    static private var dataController = DataController()
//    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
//
//    static var previews: some View {
//
//        DetailView(item: <#DailyData#>)
//        //            MemoView(num: 1, item: book)
//            .environment(\.managedObjectContext, dataController.container.viewContext)
//
//    }
//}

