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
    @EnvironmentObject var coreDataStore: CoreDataStore
    @StateObject var addMemoVM = AddMemoViewModel()
    
    ///キーボードフォーカス用変数（Doneボタン表示のため）
    @FocusState var isInputActive: Bool
    
    ///画面破棄用
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0){
                //文字数が上限オーバーした時の警告
                Label("\(AppSetting.maxLengthOfMemo)文字以内のみ設定可能です", systemImage: "exclamationmark.circle.fill")
                    .font(.footnote)
                    .padding(.vertical, 10)
                    .foregroundColor(addMemoVM.isLengthValid ? .clear : .red)
                
                //テキストエディター
                TextEditor(text: $addMemoVM.editText)
                    .customAddMemoTextEditStyle()
                    .focused($isInputActive)
                    .onTapGesture {
                        isInputActive = false
                    }
                    .padding(.bottom, 20)
                
                //保存ボタン
                Button {
                    Task{
                        await addMemoVM.updateDataMemo(data: coreDataStore.allData.last, completion: {
                            coreDataStore.setAllData()
                        })
                    }
                    dismiss()
                } label: {
                    SaveButton()
                        .foregroundColor(addMemoVM.isLengthValid ? .green : .gray)
                        .opacity(addMemoVM.isLengthValid ? 1.0 : 0.5)
                }
                .accessibilityLabel("メモを保存する")
                .tint(.green)
                //文字数が上限オーバーしている場合はボタンは無効
                .disabled(!addMemoVM.isLengthValid)
                .padding(.bottom, AppSetting.screenHeight / 5)
        
            }
            
            .toolbar {
                //キーボード閉じるボタン
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("閉じる") {
                        isInputActive = false
                    }
                }
                
                //シート閉じるボタン
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    //左上のシート破棄用Xボタン
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            .foregroundColor(.primary)
            //ナビゲーションバーの設定
            .navigationTitle("メモの追加")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)

        //グラデーション＋すりガラス背景設定
            .background(.ultraThinMaterial)
        //グラデーション背景の設定
            .modifier(UserSettingGradient())
            .onAppear{
                self.isInputActive = true
            }

        .ignoresSafeArea(.keyboard, edges: .bottom)
        .embedInNavigationStack()
    }
}


struct MemoSheet_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            MemoSheet()
                .environment(\.locale, Locale(identifier:"en"))
            MemoSheet()
                .environment(\.locale, Locale(identifier:"ja"))
        }
    }
}
