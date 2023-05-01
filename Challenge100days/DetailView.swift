//
//  MemoView.swift
//  Challenge100days
//
//  Created by koala panda on 2023/02/04.
//

import SwiftUI
import CoreData


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
    
    ///編集モードかどうかのフラグ
    @State private var isEdit = false
    
    ///入力したテキストを格納するプロパティ
    @State private var editText = ""
    
    ///選択された日付を格納するプロパティ
    @State private var selectedDay = Date.now
    
    ///シェア用の画像格納用変数
    @State var image: Image?
    
    ///表示されているデータが何日目か表示するのに使う変数
    @State var num: Int? = nil
    
    ///編集時に選択した日付が有効か判定するための変数
    @State var isVailed = true
    
    ///編集時のデータピッカー用の変数（未来のデータは追加できないようにするため）
    var dateClosedRange : ClosedRange<Date>{
        let min = Calendar.current.date(byAdding: .year, value: -10, to: Date())!
        let max = Calendar.current.date(byAdding: .second, value: 1, to: Date())!
        return min...max
    }
    
    ///キーボードフォーカス用変数（Doneボタン表示のため）
    @FocusState var isInputActive: Bool
    
    @AppStorage("colorkeyTop") var storedColorTop: Color = .blue
    @AppStorage("colorkeyBottom") var storedColorBottom: Color = .green
    
    var body: some View {
        
        ///ビュー全体をスクロールで表示するためのスクロールビュー
        ScrollView(.vertical, showsIndicators: false){
            
            
            VStack(alignment: .leading){
                
                ///選択された日付が有効ではない時に表示する警告
                Label("選択した日はすでに記録が存在しています。", systemImage: "exclamationmark.circle")
                    .font(.footnote)
                    .foregroundColor(isVailed == false ? .red : .clear)
                
                
                ///データの詳細を一覧で表示
                if isEdit == false{
                    HStack{
                        
                        ///左の青い番号セル表示用
                        Text("\(item.num) / 100")
                            .font(.title.weight(.thin))
                            .foregroundColor(.white)
                            .frame(width: AppSetting.screenWidth * 0.3, height: AppSetting.screenWidth * 0.25)
                            .background(.blue)
                            .cornerRadius(15)
                        
                        Spacer()
                        
                        ///日付表示
                        VStack{
                            Text("AA")
                            Text(makeDate(day: item.date ?? Date.now))
                                .font(.title3.weight(.ultraLight)).foregroundColor(.black)
                                .padding(.leading, 40)
                        }
                    }
                    .padding(.bottom)
                    
                    
                    ///メモ表示用
                    Text(item.memo ?? "")
                        .foregroundColor(.black).multilineTextAlignment(.leading).lineSpacing(5)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(item.memo != "" ? .bottom : [] )
                    
                    
                }else{
                    ///編集モードの時のビュー
                    HStack{
                        
                        ///日付けのセルは通常モードの時と同じ
                        Text("\(num ?? 1) / 100")
                            .font(.title.weight(.thin))
                            .foregroundColor(.white)
                            .frame(width: AppSetting.screenWidth * 0.3, height: AppSetting.screenWidth * 0.25)
                            .background(.blue)
                            .cornerRadius(15)
                        
                        Spacer()
                        
                        
                        ///日付変更用のデータピッカー
                        DatePicker(selection: $selectedDay, in: dateClosedRange, displayedComponents: .date, label: {Text("")})
                            .datePickerStyle(.compact)
                            .labelsHidden()
                            .padding(.leading, 20)
                    }.frame(maxWidth: .infinity, alignment: .leading)
                    
                    ///メモ編集用のテキストエディター
                    TextEditor(text: $editText)
                        .foregroundColor(Color(UIColor.black))
                        .lineSpacing(5)
                        .scrollContentBackground(Visibility.hidden)
                        .background(Color(UIColor.white))
                        .border(.gray)
                        .frame(height: AppSetting.screenHeight * 0.4)
                        .padding(.top)
                        .focused($isInputActive)
                    
                }
                
            }
            
            .padding()
            .fixedSize(horizontal: false, vertical: true)
            .background(.white)
            .cornerRadius(15)
            .padding()
            
        }
        
        //.background(.ultraThinMaterial)
        .background(.secondary)
        .foregroundStyle(
            .linearGradient(
                colors: [storedColorTop, storedColorBottom],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        //.background(.quaternary).foregroundStyle(.blue)
        
        
        ///データピッカーで日付が選択された時に発動
        .onChange(of: selectedDay) { newValue in
            ///日付が選択された時に青い日付表示セルをリアルタイムで調整するための処理
            let array = days.filter{
                $0.date ?? Date.now < newValue
            }
            if item.date ?? Date.now < newValue {
                num = array.count
            }else{
                num = array.count + 1
            }
            
            ///元々の日付と同じならSaveボタンを有効にしてリターン
            if Calendar.current.isDate(item.date ?? Date.now, equalTo: newValue , toGranularity: .day){
                isVailed = true
                return
            }
            
            ///フェッチリクエストに存在するアイテムの日付とダブってればSaveボタンを無効にしてリターン
            for i in days{
                
                if Calendar.current.isDate(i.date!, equalTo: newValue , toGranularity: .day){
                    isVailed = false
                    return
                }
            }
            ///ダブりがなければisVailedをTrueにしてリターン
            isVailed = true
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
            selectedDay = item.date ?? Date.now
        }
        
        
        .toolbar{
            
            ///キーボード閉じるボタンを配置
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    isInputActive = false
                }
            }
            
            ///通常モードの時のツールバー
            if isEdit == false{
                
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
                
                ///アイテム編集用ペンアイコン
                ToolbarItem(placement: .navigationBarTrailing){
                    Button {
                        isEdit = true
                    } label: {
                        Image(systemName:"square.and.pencil")
                        
                    }
                    .foregroundColor(.primary)
                    .padding(.trailing)
                    
                }
                
                ///画像シェア用のリンク
                ToolbarItem(placement: .navigationBarTrailing) {
                    ShareLink(item: image ?? Image("noImage") , preview: SharePreview("画像", image:image ?? Image("noImage") )){
                        Image(systemName: "square.and.arrow.up")
                        
                    }
                }
                
            }else{
                
                ///編集モードの時のツールバー
                ToolbarItem(placement: .navigationBarTrailing){
                    
                    ///完了ボタン
                    Button {
                        Task{
                            await save()
                            await reNumber()
                        }
                        isEdit = false
                        
                    } label: {
                        HStack{
                            Text("保存")
                            Image(systemName:"checkmark.circle")
                        }
                        .padding(.trailing)
                    }
                    .foregroundColor(isVailed == false ? .gray : .green)
                    .disabled(isVailed == false)
                    
                }
            }
        }
        
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
            item.date = selectedDay
            item.memo = editText
            try? moc.save()
            image = generateImageWithText(number: Int(item.num), day: item.date ?? Date.now)
            UserDefaults.standard.set(days.count + 1, forKey: "todayIs")
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

