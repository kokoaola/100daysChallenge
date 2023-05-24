//
//  makeNewItemSheet.swift
//  Challenge100days
//
//  Created by koala panda on 2023/02/09.
//

import SwiftUI

struct makeNewItemSheet: View {
    
    ///CoreData用の変数
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key:"date", ascending: true)]) var items: FetchedResults<DailyData>
    @Environment(\.managedObjectContext) var moc
    
    ///画面破棄用の変数
    @Environment(\.dismiss) var dismiss
    
    ///キーボードフォーカス用変数（Doneボタン表示のため）
    @FocusState var isInputActive: Bool
    
    ///入力したテキストを格納するプロパティ
    @State private var editText = ""
    
    ///選択された日付を格納するプロパティ
    @State private var theDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
    
    ///編集時のデータピッカー用の変数（未来のデータは追加できないようにするため）
    var dateClosedRange : ClosedRange<Date>{
        let min = Calendar.current.date(byAdding: .year, value: -10, to: Date())!
        let max = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        return min...max
    }
    
    ///選択された日付が有効か判定するプロパティ
    @State var isVailed = false
    
    @AppStorage("colorkeyTop") var storedColorTop: Color = .blue
    @AppStorage("colorkeyBottom") var storedColorBottom: Color = .green
    
    var body: some View {
        NavigationStack{
            
            
            VStack(spacing: 20){
                ZStack{
                    
                    ///左上のシート破棄用Xボタン
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    ///画面タイトル
                    Text("過去の記録を追加")
                        .font(.title2)
                    
                    Spacer()
                }
                .padding(.bottom, 30)
                
                
                ///上のデートピッカー
                HStack(alignment: .top){
                    Text("日付")
                    Spacer()
                    DatePicker(selection: $theDate, in: dateClosedRange, displayedComponents: .date, label: {Text("追加する日付")})
                        .environment(\.locale, Locale(identifier: "ja-Jp"))
                        .datePickerStyle(.compact)
                        .padding(.top, -10)
                        .labelsHidden()
                }.foregroundColor(Color(UIColor.label))
                
                ///メモ編集用のテキストエディター
                HStack{
                    Text("メモ")
                    Spacer()
                }
                TextEditor(text: $editText)
                    .foregroundColor(Color(UIColor.label))
                    .lineSpacing(10)
                    .scrollContentBackground(Visibility.hidden)
                    .background(.ultraThinMaterial)
                    .border(.white)
                    .frame(height: 300)
                    .focused($isInputActive)
                
                
                ///選択された日付が有効ではない時に表示する警告
                if !isVailed{
                    Label("選択した日はすでに記録が存在しています。", systemImage: "exclamationmark.circle")
                        .font(.footnote)
                        .padding(5)
                        .foregroundColor(.red)
                        .cornerRadius(10)
                }else if editText.count > AppSetting.maxLngthOfMemo{
                    Label("\(AppSetting.maxLngthOfMemo)文字以内のみ設定可能です", systemImage: "exclamationmark.circle")
                        .font(.footnote)
                        .padding(5)
                        .foregroundColor(.red)
                }
                
                
                ///保存ボタン
                Button{
                    dismiss()
                    Task{
                        await save()
                        await reNumber()
                    }
                    
                } label: {
                    OriginalButton(labelString: "保存する", labelImage: "checkmark.circle")
                        .foregroundColor(editText.count <= AppSetting.maxLngthOfMemo && isVailed ? .green : .gray)
                        .opacity(editText.count <= AppSetting.maxLngthOfMemo && isVailed ? 1.0 : 0.5)
                    
                    //                        .foregroundColor(isVailed ? .green : .gray)
                    //                        .opacity(isVailed ? 1.0 : 0.5)
                }
                //.padding()
                .disabled(isVailed == false || editText.count > AppSetting.maxLngthOfMemo)
                
            }
            .foregroundColor(.primary)
            
            
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(.ultraThinMaterial)
            .userSettingGradient(colors: [storedColorTop, storedColorBottom])
//            .background(.secondary)
//            .foregroundStyle(
//                .linearGradient(
//                    colors: [storedColorTop, storedColorBottom],
//                    startPoint: .topLeading,
//                    endPoint: .bottomTrailing
//                )
//            )
            
            
            .onChange(of: theDate) { newValue in
                ///フェッチリクエストに存在するアイテムの日付とダブってればSaveボタンを無効にしてリターン
                for item in items{
                    if Calendar.current.isDate(item.date!, equalTo: newValue , toGranularity: .day){
                        isVailed = false
                        return
                    }
                }
                ///ダブりがなければisVailedをTrueにしてリターン
                isVailed = true
            }
            
            .onAppear{
                let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
                ///フェッチリクエストに存在するアイテムの日付とダブってればSaveボタンを無効にしてリターン
                for item in items{
                    if Calendar.current.isDate(item.date!, equalTo: yesterday , toGranularity: .day){
                        
                        isVailed = false
                        return
                    }
                }
                ///ダブりがなければisVailedをTrueにしてリターン
                isVailed = true
            }
            
            ///キーボード閉じるボタンを配置
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("閉じる") {
                        isInputActive = false
                    }
                }
            }
            .foregroundColor(Color(UIColor.label))
            
            
        }
        
    }
    
    ///データ保存用関数
    func save() async{
        await MainActor.run{
            let day = DailyData(context: moc)
            day.id = UUID()
            day.date = theDate
            day.memo = editText
            try? moc.save()
            
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

struct makeNewItemSheet_Previews: PreviewProvider {
    static var previews: some View {
        makeNewItemSheet()
    }
}



