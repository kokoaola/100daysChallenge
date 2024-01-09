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
    @EnvironmentObject var coreDataStore: CoreDataStore
    @StateObject var makeNewItemVM = MakeNewItemViewModel()
    
    ///画面破棄用の変数
    @Environment(\.dismiss) var dismiss
    ///キーボードフォーカス用変数（Doneボタン表示のため）
    @FocusState var isInputActive: Bool
    
    
    var body: some View {
            VStack(spacing: 20){
                //上のデートピッカー
                HStack(alignment: .top){
                    Text("日付")
                    Spacer()
                    DatePicker(selection: $makeNewItemVM.userSelectedDate, in: makeNewItemVM.dateClosedRange, displayedComponents: .date, label: {Text("追加する日付")})
                        .environment(\.locale, Locale(identifier: "ja-Jp"))
                        .datePickerStyle(.compact)
                        .padding(.top, -10)
                        .labelsHidden()
                }.foregroundColor(Color(UIColor.label)).padding(.top)
                
                //メモ編集用のテキストエディター
                HStack{
                    Text("メモ")
                    Spacer()
                }
                TextEditor(text: $makeNewItemVM.editText)
                    .foregroundColor(Color(UIColor.label))
                    .scrollContentBackground(Visibility.hidden)
                    .background(.ultraThinMaterial)
                    .border(.white)
                    .focused($isInputActive)
                
                //選択された日付が有効ではない時に表示する警告
                if !makeNewItemVM.isVailedDate{
                    Label("選択した日はすでに記録が存在しています。", systemImage: "exclamationmark.circle")
                        .font(.footnote)
                        .padding(5)
                        .foregroundColor(.red)
                        .cornerRadius(10)
                }
                if !makeNewItemVM.isTextLengthValid{
                    //メモの文字数が上限を超えていた場合に表示する警告
                    Label("\(AppSetting.maxLengthOfMemo)文字以内のみ設定可能です", systemImage: "exclamationmark.circle")
                        .font(.footnote)
                        .padding(5)
                        .foregroundColor(.red)
                }
                
                //保存ボタン
                Button{
                    //保存して画面破棄
                    makeNewItemVM.saveTodaysChallenge(challengeDate: coreDataStore.dayNumber){ success in
                        if success {
                            DispatchQueue.main.async {
                                Task{
                                    await coreDataStore.assignNumbers(completion: {
                                        coreDataStore.setAllData()
                                    })
                                }
                            }
                            dismiss()
                        }else{
                            dismiss()
                        }
                    }
                } label: {
                    SaveButton()
                        .foregroundColor(makeNewItemVM.isSaveButtonValid ? .green : .gray)
                        .opacity(makeNewItemVM.isSaveButtonValid ? 1.0 : 0.5)
                }
                .disabled(!makeNewItemVM.isSaveButtonValid)
                
            }
            .foregroundColor(.primary)
            
            
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(.ultraThinMaterial)
            //グラデーション背景の設定
            .modifier(UserSettingGradient())
            .onChange(of: makeNewItemVM.userSelectedDate) { newValue in
                //選択した日付と同じデータがすでに存在している場合はSaveボタンを無効にする
                makeNewItemVM.isValidDate(allData: coreDataStore.allData, checkDate: newValue)
            }
        
            .onAppear{
                //選択した日付と同じデータがすでに存在している場合はSaveボタンを無効にする
                let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
                makeNewItemVM.isValidDate(allData: coreDataStore.allData, checkDate: yesterday)
            }
            
            .toolbar {
                //キーボード閉じるボタン
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("閉じる") {
                        isInputActive = false
                    }
                }
                
                //左上のシート破棄用Xボタン
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            .foregroundColor(Color(UIColor.label))
        //ナビゲーションバーの設定
            .navigationTitle("過去の記録を追加")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .embedInNavigationStack()
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
        .environmentObject(CoreDataStore())
    }
}
