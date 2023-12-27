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
    @EnvironmentObject var store:GrobalStore
    @StateObject var addMemoVM = AddMemoViewModel()
    
    ///キーボードフォーカス用変数（Doneボタン表示のため）
    @FocusState var isInputActive: Bool
    
    ///画面破棄用
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 10){
            ZStack{
                //左上のシート閉じるボタン
                Button { dismiss() } label: { CloseButton() }
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
                .foregroundColor(addMemoVM.isLengthValid ? .clear : .red)
            
            //テキストエディター
            TextEditor(text: $addMemoVM.editText)
                .customAddMemoTextEditStyle()
                .focused($isInputActive)
                .onTapGesture {
                    AppSetting.colseKeyBoard()
                }
            
            //保存ボタン
            Button {
                Task{
                    await addMemoVM.updateDataMemo(data: store.allData.last) {
                            store.setAllData()
                    }
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
            .padding(.top)
        }
        .padding()
        .frame(maxHeight: .infinity, alignment: .top)
        
        //グラデーション＋すりガラス背景設定
        .background(.ultraThinMaterial)
        .modifier(UserSettingGradient(appColorNum: addMemoVM.userSelectedColor))
        
        .onAppear{
            self.isInputActive = true
        }
        //キーボード閉じるボタン
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("閉じる") {
                    isInputActive = false
                }
                .foregroundColor(.primary)
            }
        }
    }
}


//struct MemoSheet_Previews: PreviewProvider {
//    static var previews: some View {
//        Group{
//            MemoSheet()
//                .environment(\.locale, Locale(identifier:"en"))
//            MemoSheet()
//                .environment(\.locale, Locale(identifier:"ja"))
//        }
//        .environmentObject(CoreDataViewModel())
//        .environmentObject(Store())
//    }
//}
