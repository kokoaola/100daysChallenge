//
//  SwiftUIView.swift
//  Challenge100days
//
//  Created by koala panda on 2023/02/17.
//

import SwiftUI

struct EditGoal: View {
    ///ViewModel用の変数
    @ObservedObject var settingViewModel: SettingViewModel
    
    ///完了時のクロージャを受け取るプロパティ
    var onDeleted: () -> Void
    
    ///キーボードフォーカス用変数（Doneボタン表示のため）
    @FocusState var isInputActive: Bool
    
    var body: some View {
        
        VStack(alignment: .leading){
            
            //見出しの文言
            Text(settingViewModel.editLongTermGoal ? "目標を変更する" : "100日取り組む内容を変更する")
                .frame(maxWidth: .infinity, alignment: .center)
                .font(.title3)
            
            //テキストエディタ
            TextEditor(text: $settingViewModel.editText)
                .foregroundColor(Color(UIColor.black))
                .tint(.black)
                .scrollContentBackground(Visibility.hidden)
                .background(.gray.opacity(0.5))
                .border(.gray, width: 1)
                .frame(height: 80)
                .opacity(settingViewModel.isTextNotEmpty ? 1 : 0.5)
                .accessibilityLabel("目標変更用のテキストフィールド")
                .focused($isInputActive)
            
            //文字数オーバー時の警告
            Text("\(AppSetting.maxLengthOfTerm)文字以内のみ設定可能です").font(.caption) .font(.caption)
                .foregroundColor(settingViewModel.isTextLengthValid ? .clear : .red)
            
            
            HStack{
                //キャンセルボタン
                Button {
                    //アラートの破棄
                    settingViewModel.showGoalEdittingAlert = false
                } label: {
                    Text("キャンセル")
                        .frame(width: AppSetting.screenWidth / 3.5, height: AppSetting.screenWidth * 0.1)
                }
                .tint(.red)
                
                Spacer()
                
                //保存ボタン
                Button {
                    if settingViewModel.isTextNotEmpty && settingViewModel.isTextLengthValid{
                        onDeleted()
                    }
                    settingViewModel.toastText = "目標を変更しました"
                    settingViewModel.showGoalEdittingAlert = false
                    settingViewModel.showToast = true
                } label: {
                    Text("変更する")
                        .frame(width: AppSetting.screenWidth / 3.5, height: AppSetting.screenWidth * 0.1)
                }.tint(.green)
                    .disabled(!settingViewModel.isTextNotEmpty || !settingViewModel.isTextLengthValid)
            }//HStackここまで
            .foregroundColor(.white)
            .buttonStyle(.borderedProminent)
            .padding(.bottom)
            
        }//VStackここまで
        
        .foregroundColor(.black)
        .padding()
        .background(.white)
        .cornerRadius(15)
        .padding()
        .onAppear{
            isInputActive = true
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
    }
}




//struct EditGoal_Previews: PreviewProvider {
//    @State static var isEdit = false
//    @State static var showToast = false
//    @State static var toastText = "目標を変更しました"
//    static var previews: some View {
//        Group{
//            EditGoal(showAlert: $isEdit,showToast: $showToast,toastText: $toastText, isLong: true)
//                .environment(\.locale, Locale(identifier:"en"))
//            EditGoal(showAlert: $isEdit,showToast: $showToast,toastText: $toastText, isLong: true)
//                .environment(\.locale, Locale(identifier:"ja"))
//        }
//        .environmentObject(CoreDataStore())
//    }
//}
