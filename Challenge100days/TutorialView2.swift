//
//  Tutorial.swift
//  Challenge100days
//
//  Created by koala panda on 2023/02/12.
//

import SwiftUI


///チュートリアル２ページ目
struct TutorialView2: View {
    
    ///ViewModel用の変数
    @EnvironmentObject var userSettingViewModel:UserSettingViewModel
    
    ///入力したテキストを格納するプロパティ
    @State private var editText = ""
    @State private var editText2 = ""
    
    ///キーボードフォーカス用変数（Doneボタン表示のため）
    @FocusState var isInputActive: Bool
    
    ///キーボードフォーカス用変数（Doneボタン表示のため）
    @FocusState var isInputActive2: Bool
    
    ///表示中のページ番号を格納
    @Binding var page: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20){
                    Text("次に、目標を設定してください。")
                    
            ///長期目標
            VStack(alignment: .leading){
                        Text("①あなたが将来なりたい姿はなんですか？")

                        ZStack(alignment: .topLeading){
                            if editText.isEmpty{
                                Text("例）画力アップ\n　　TOEIC800点").padding(8)
                            }

                            ///テキストエディター
                            TextEditor(text: $editText)
                                .scrollContentBackground(Visibility.hidden)
                                .background(.ultraThinMaterial)
                                .border(.white, width: 1)
                                .frame(height: 80)
                                .focused($isInputActive)
                                .opacity(editText.isEmpty ? 0.5 : 1)
                        }
                
                Text("\(AppSetting.maxLengthOfTerm)文字以内のみ設定可能です")
                    .font(.caption)
                    .foregroundColor(editText.count > AppSetting.maxLengthOfTerm ? .red : .clear)
                    }
            
            
            ///短期目標
            VStack(alignment: .leading){
                        Text("②その実現のために１００日間取り組むことはなんですか？")
                            .frame(minHeight: 60)
                           // .fixedSize(horizontal: false, vertical: true)
                        ZStack(alignment: .topLeading){
                            if editText2.isEmpty{
                                Text("例）１日１枚絵を描く\n　　英語の勉強")
                                    .padding(8)
                                    .foregroundColor(.primary)
                            }
                            
                            ///テキストエディター
                            TextEditor(text: $editText2)
                                .foregroundColor(Color(UIColor.label))
                                .scrollContentBackground(Visibility.hidden)
                                .background(.ultraThinMaterial)
                                .border(.white, width: 1)
                                .frame(height: 80)
                                .focused($isInputActive2)
                                .opacity(editText2.isEmpty ? 0.5 : 1)
                        }
                        Text("\(AppSetting.maxLengthOfTerm)文字以内のみ設定可能です")
                            .font(.caption)
                            .foregroundColor(editText2.count > AppSetting.maxLengthOfTerm ? .red : .clear)
                    }
                
                Spacer()
            
            
//                        戻るボタン
                HStack{
                    Button {
                        page = 1
                        userSettingViewModel.saveUserSettingGoal(isLong: true, goal: editText)
                        userSettingViewModel.saveUserSettingGoal(isLong: false, goal: editText2)
                    } label: {
                        ArrowButton(isBackButton: true, labelText: "戻る")
                    }
                    
                    Spacer()
                    
//                    進むボタン
                    Button {
                        page = 3
                        userSettingViewModel.saveUserSettingGoal(isLong: true, goal: editText)
                        userSettingViewModel.saveUserSettingGoal(isLong: false, goal: editText2)
                    } label: {
                        ArrowButton(isBackButton: false, labelText: "次へ")
                            .opacity(!editText.isEmpty && !editText2.isEmpty && editText.count <= AppSetting.maxLengthOfTerm && editText2.count <= AppSetting.maxLengthOfTerm ? 1 : 0.4)
                    }
                    
//                    次へボタンの無効判定
                   .disabled(editText.isEmpty || editText2.isEmpty || editText.count > AppSetting.maxLengthOfTerm || editText2.count > AppSetting.maxLengthOfTerm)
                }
                .padding(.bottom, 30)
                }

        .frame(minHeight: AppSetting.screenHeight/1.6)
        .padding()
        .foregroundColor(Color(UIColor.label))
        
        .onAppear{
            editText = userSettingViewModel.longTermGoal
            editText2 = userSettingViewModel.shortTermGoal
        }

            
        ///キーボード閉じるボタンを配置
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("閉じる") {
                        isInputActive = false
                        isInputActive2 = false
                }
            }
        }
        .foregroundColor(Color(UIColor.label))
    }
        
}




struct TutorialView2_Previews: PreviewProvider {
    @State static var sampleNum = 1
    static var previews: some View {
        Group{
            TutorialView2(page: $sampleNum)
                .environment(\.locale, Locale(identifier:"en"))
            TutorialView2(page: $sampleNum)
                .environment(\.locale, Locale(identifier:"ja"))
        }
        .environmentObject(UserSettingViewModel())
    }
}
