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
    //    @FetchRequest(sortDescriptors: [NSSortDescriptor(key:"date", ascending: true)]) var days: FetchedResults<DailyData>
    //    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var notificationViewModel :NotificationViewModel
    @EnvironmentObject var coreDataViewModel :CoreDataViewModel
    
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
                .accessibilityElement()
                .accessibilityLabel("\(item.num)日目の記録、\(makeAccessibilityDate(day: item.date ?? Date()))")
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                ZStack(alignment: .topLeading){
                    if editText.isEmpty{
                        Text("保存されたメモはありません。\nタップで追加できます。")
                            .padding(8)
                            .foregroundColor(.primary)
                            .opacity(0.5)
                    }
                    ///メモ編集用のテキストエディター
                    TextEditor(text: $editText)
                        .lineSpacing(2)
                        .scrollContentBackground(Visibility.hidden)
                        .frame(maxHeight: .infinity)
                        .focused($isInputActive)
                        .tint(.white)
                    
                    
                }
                
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
            .userSettingGradient(colors: [storedColorTop, storedColorBottom])
            
        }
        
        .navigationBarBackButtonHidden(true)
        
        
        
        
        .onAppear{
            ///アクションタブの方から削除済みのアイテムを詳細を表示していた時に、空白の画面が表示されてしまう問題を避けるための処理
            if coreDataViewModel.allData.firstIndex(of: item) == nil{
                dismiss()
            }
            
            ///シェア用の画像を生成
            //            image = generateImageWithText(number: Int(item.num), day: item.date ?? Date.now)
            
            ///その他の初期設定
            editText = item.memo ?? ""
            num =  Int(item.num)
        }
        
        
        
        .toolbar{
            
            ///保存ボタンを配置
            ToolbarItemGroup(placement: .keyboard) {
                
                
                Text("\(AppSetting.maxLengthOfMemo)文字以内のみ設定可能です")
                    .font(.caption)
                    .foregroundColor(editText.count > AppSetting.maxLengthOfMemo ? .red : .clear)
                
                
                
                Button("保存する") {
                    Task{
                        await coreDataViewModel.updateDataMemo(newMemo:editText, data:item )
                    }
                    isInputActive = false
                }
                
                .foregroundColor(editText.count <= AppSetting.maxLengthOfMemo ? .primary : .gray)
                .opacity(editText.count <= AppSetting.maxLengthOfMemo ? 1.0 : 0.5)
                .disabled(editText.count > AppSetting.maxLengthOfMemo)
                
                
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
            
            ///戻るボタン
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack{
                        Image(systemName: "chevron.backward")
                        Text("戻る")
                    }
                }
            }
        }
        .foregroundColor(Color(UIColor.label))
        
        ///削除ボタン押下時のアラート
        .alert("この日の記録を破棄しますか？", isPresented: $showCansel){
            Button("破棄する",role: .destructive){
                coreDataViewModel.deleteData(data:item)
                Task{
                    await coreDataViewModel.assignNumbers()
                }
                if notificationViewModel.isNotificationOn{
                    notificationViewModel.setNotification(item: coreDataViewModel.allData.last)
                }
                dismiss()
            }
            Button("戻る",role: .cancel){}
        }message: {
            Text("表示中のデータは破棄されます。\n（この動作は取り消せません。）")
        }
    }
    
    ///データ保存用関数
//    func save() async{
//        await MainActor.run{
//            item.memo = editText
//            try? moc.save()
//            isInputActive = false
//        }
//    }
    
    
    ///データ保存後の番号振り直し用の関数
    //    func reNumber() async{
    //        var counter = Int16(0)
    //        for i in days{
    //            counter += 1
    //            i.num = counter
    //            try? moc.save()
    //            UserDefaults.standard.set(days.count + 1, forKey: "todayIs")
    //        }
    //    }
    
    ///削除用の関数
//    func delete() async{
//        moc.delete(item)
//        try? moc.save()
//
//        var counter = Int16(0)
//        for i in days{
//            counter += 1
//            i.num = counter
//            try? moc.save()
//        }
//
//    }
    
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

