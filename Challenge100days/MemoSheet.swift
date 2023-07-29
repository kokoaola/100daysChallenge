//
//  MemoSheet.swift
//  Challenge100days
//
//  Created by koala panda on 2023/02/02.
//

import SwiftUI


///ユーザーが記録にメモを追加するためのビュー
struct MemoSheet: View {
    
    ///ViewModel用の変数
    @EnvironmentObject var coreDataViewModel :CoreDataViewModel
    @EnvironmentObject var userSettingViewModel:UserSettingViewModel
    
    ///キーボードフォーカス用変数（Doneボタン表示のため）
    @FocusState var isInputActive: Bool
    
    ///画面破棄用
    @Environment(\.dismiss) var dismiss
    
    ///編集文章格納用
    @State var editText = ""
    
    
    var body: some View {
//        NavigationStack{
                VStack(spacing: 10){
                    ZStack{
                        
                        //左上のシート破棄用Xボタン
                        Button {
                            dismiss()
                        } label: {
                            CloseButton()
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        //画面タイトル
                        Text("メモの追加").font(.title3)
                            .padding()
                            
                    }
                    .foregroundColor(Color(UIColor.label))
                    
                    
                    //文字数が上限オーバーした時の警告
                    Label("\(AppSetting.maxLengthOfMemo)文字以内のみ設定可能です", systemImage: "exclamationmark.circle")
                        .font(.footnote)
                        .padding(5)
                        .foregroundColor(editText.count > AppSetting.maxLengthOfMemo ? .clear : .red)
                        //テキストエディター
                        TextEditor(text: $editText)
                        .focused($isInputActive)
                            .foregroundColor(Color(UIColor.label))
                            .lineSpacing(10)
                            .scrollContentBackground(Visibility.hidden)
                            .background(.ultraThinMaterial)
                            .border(.white, width: 3)
                            .frame(height: 300)
                            .task {
                                // 入力したされた日本語の1文字目が変換対象にならないバグに対応するため、一度空白を入力して削除する
                                
                                if let savedMemo = coreDataViewModel.allData.last?.memo{
                                    if savedMemo.isEmpty{
                                        editText = ""
                                    }else{
                                        editText = savedMemo
                                    }
                                }
                                isInputActive = true
                            }
                    
                            .onTapGesture {
                                AppSetting.colseKeyBoard()
                            }
                    
                    //保存ボタン
                    Button {

                        Task{
                           await coreDataViewModel.updateDataMemo(newMemo: editText, data: nil)
                        }
                        dismiss()
                    } label: {
                        SaveButton()
                            .foregroundColor(editText.count <= AppSetting.maxLengthOfMemo ? .green : .gray)
                            .opacity(editText.count <= AppSetting.maxLengthOfMemo ? 1.0 : 0.5)
                    }
                    .accessibilityLabel("メモを保存する")
                    .tint(.green)
                    //文字数が上限オーバーしている場合はボタンは無効
                    .disabled(editText.count > AppSetting.maxLengthOfMemo)
                    .padding(.top)
                }
            .padding()
            .frame(maxHeight: .infinity, alignment: .top)
            
            //グラデーション＋すりガラス背景設定
            .background(.ultraThinMaterial)
            .modifier(UserSettingGradient(appColorNum: userSettingViewModel.userSelectedColor))
            
//            //キーボード閉じるボタン
//            .toolbar {
//                ToolbarItemGroup(placement: .keyboard) {
//                    Spacer()
//                    Button("閉じる") {
//                        isInputActive = false
//                    }
//                }
//            }
//            .foregroundColor(Color(UIColor.label))
            
            //すでにメモデータが格納されていればテキストエディターの初期値に設定
//            .onAppear{
//                editText = coreDataViewModel.allData.last?.memo ?? ""
//            }
//        }
    }
    
    // キーボードを閉じるためのヘルパー関数
//    private func hideKeyboard() {
//        let keyWindow = UIApplication.shared.connectedScenes
//            .filter({$0.activationState == .foregroundActive})
//            .map({$0 as? UIWindowScene})
//            .compactMap({$0})
//            .first?.windows
//            .filter({$0.isKeyWindow}).first
//        keyWindow?.endEditing(true)
//    }
}


struct MemoSheet_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            MemoSheet()
                .environment(\.locale, Locale(identifier:"en"))
            MemoSheet()
                .environment(\.locale, Locale(identifier:"ja"))
        }
        .environmentObject(CoreDataViewModel())
        .environmentObject(UserSettingViewModel())
    }
}
