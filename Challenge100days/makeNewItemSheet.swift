//
//  makeNewItemSheet.swift
//  Challenge100days
//
//  Created by koala panda on 2023/02/09.
//

import SwiftUI


///新しいデータを追加するビュー
struct makeNewItemSheet: View {
    
    ///ViewModel用の変数
    @EnvironmentObject var coreDataViewModel :CoreDataViewModel
    @EnvironmentObject var userSettingViewModel: UserSettingViewModel
    
    ///画面破棄用の変数
    @Environment(\.dismiss) var dismiss
    
    ///キーボードフォーカス用変数（Doneボタン表示のため）
    @FocusState var isInputActive: Bool
    
    ///入力したテキストを格納するプロパティ
    @State private var editText = ""
    
    ///選択された日付を格納するプロパティ
    @State private var userSelectedData = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
    
    ///編集時のデータピッカー用の変数（未来のデータは追加できないようにするため）
    var dateClosedRange : ClosedRange<Date>{
        let min = Calendar.current.date(byAdding: .year, value: -10, to: Date())!
        let max = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        return min...max
    }
    
    ///選択された日付が有効か判定するプロパティ
    @State var isVailed = false
    
    
    
    var body: some View {
        NavigationStack{
            
            
            VStack(spacing: 20){
                ZStack{
                    //左上のシート破棄用Xボタン
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    //画面タイトル
                    Text("過去の記録を追加")
                        .font(.title2)
                    
                    Spacer()
                }
                .padding(.bottom, 30)
                
                
                //上のデートピッカー
                HStack(alignment: .top){
                    Text("日付")
                    Spacer()
                    DatePicker(selection: $userSelectedData, in: dateClosedRange, displayedComponents: .date, label: {Text("追加する日付")})
                        .environment(\.locale, Locale(identifier: "ja-Jp"))
                        .datePickerStyle(.compact)
                        .padding(.top, -10)
                        .labelsHidden()
                }.foregroundColor(Color(UIColor.label))
                
                //メモ編集用のテキストエディター
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
                    .task {
                        // 入力したされた日本語の1文字目が変換対象にならないバグに対応するため、一度空白を入力して削除する
                        do {
                            try await Task.sleep(nanoseconds: 200 * 1000 * 1000)
                            isInputActive = true
                            editText = "　　　"
                            try await Task.sleep(nanoseconds: 500 * 1000 * 1000)
                            editText = ""
                        } catch {
                            print(error)
                        }
                    }
                
                //選択された日付が有効ではない時に表示する警告
                if !isVailed{
                    Label("選択した日はすでに記録が存在しています。", systemImage: "exclamationmark.circle")
                        .font(.footnote)
                        .padding(5)
                        .foregroundColor(.red)
                        .cornerRadius(10)
                }else if editText.count > AppSetting.maxLengthOfMemo{
                    //メモの文字数が上限を超えていた場合に表示する警告
                    Label("\(AppSetting.maxLengthOfMemo)文字以内のみ設定可能です", systemImage: "exclamationmark.circle")
                        .font(.footnote)
                        .padding(5)
                        .foregroundColor(.red)
                }
                
                
                //保存ボタン
                Button{
                    dismiss()
                    Task{
                    await coreDataViewModel.saveData(date:userSelectedData, memo:editText)
                        await coreDataViewModel.assignNumbers()
                    }
                    
                } label: {
                    SaveButton()
                        .foregroundColor(editText.count <= AppSetting.maxLengthOfMemo && isVailed ? .green : .gray)
                        .opacity(editText.count <= AppSetting.maxLengthOfMemo && isVailed ? 1.0 : 0.5)
                }
                .disabled(isVailed == false || editText.count > AppSetting.maxLengthOfMemo)
                
            }
            .foregroundColor(.primary)
            
            
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(.ultraThinMaterial)
            
            //グラデーション背景の設定
            .modifier(UserSettingGradient(appColorNum: userSettingViewModel.userSelectedColor))
            
            
            .onChange(of: userSelectedData) { newValue in
                //データベースに存在するアイテムの日付とダブってればSaveボタンを無効にする
                for item in coreDataViewModel.allData{
                    if Calendar.current.isDate(item.date!, equalTo: newValue , toGranularity: .day){
                        isVailed = false
                        return
                    }
                }
                //ダブりがなければisVailedをTrueにしてリターン
                isVailed = true
            }
            
            .onAppear{
                let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
                //データベースに昨日の日付があれば、Saveボタンを無効にする
                for item in coreDataViewModel.allData{
                    if Calendar.current.isDate(item.date!, equalTo: yesterday , toGranularity: .day){
                        isVailed = false
                        return
                    }
                }
                //ダブりがなければisVailedをTrueにしてリターン
                isVailed = true
            }
            
            //キーボード閉じるボタンを配置
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
}



struct makeNewItemSheet_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            makeNewItemSheet()
                .environment(\.locale, Locale(identifier:"en"))
            makeNewItemSheet()
                .environment(\.locale, Locale(identifier:"ja"))
        }
        .environmentObject(CoreDataViewModel())
        .environmentObject(UserSettingViewModel())
    }
}
