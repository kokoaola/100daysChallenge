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
    @EnvironmentObject var store: Store
    @ObservedObject var tutorialVM: TutorialViewModel
    
    ///キーボードフォーカス用変数（Doneボタン表示のため）
    @FocusState var longTermEditorFocus: Bool
    @FocusState var shortTermEditorFocus: Bool
    
    var body: some View {
        VStack(alignment: .leading){
            Text("次に、目標を設定してください。")
            
            ///長期目標
            VStack(alignment: .leading){
                Text("①あなたが将来なりたい姿はなんですか？")

                //プレースホルダー
                ZStack(alignment: .topLeading){
                    if !tutorialVM.longTermEditText.isEmpty{
                        EmptyView()
                    }else{
                        Text("例）画力アップ\n　　TOEIC800点").padding(5)
                    }
                    
                    ///テキストエディター
                    TextEditor(text: $tutorialVM.longTermEditText)
                        .scrollContentBackground(Visibility.hidden)
                        .background(.ultraThinMaterial)
                        .border(.white, width: 1)
                        .frame(height: AppSetting.screenHeight / 12)
                        .focused($longTermEditorFocus)
                        .opacity(tutorialVM.longTermEditText.isEmpty ? 0.5 : 1)
                }
                
                Text("\(AppSetting.maxLengthOfTerm)文字以内のみ設定可能です")
                    .font(.caption)
                    .foregroundColor(tutorialVM.longTermEditText.count > AppSetting.maxLengthOfTerm ? .red : .clear)
            }
            
            
            ///短期目標
            VStack(alignment: .leading){
                Text("②その実現のために１００日間取り組むことはなんですか？")
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                
                
                ZStack(alignment: .topLeading){
                    if !tutorialVM.shortTermEditText.isEmpty{
                        EmptyView()
                    }else{
                        Text("例）１日１枚絵を描く\n　　英語の勉強").padding(5)
                   }
                    
                    ///テキストエディター
                    TextEditor(text: $tutorialVM.shortTermEditText)
                        .scrollContentBackground(Visibility.hidden)
                        .background(.ultraThinMaterial)
                        .border(.white, width: 1)
                        .frame(height: AppSetting.screenHeight / 12)
                        .focused($shortTermEditorFocus)
                        .opacity(tutorialVM.shortTermEditText.isEmpty ? 0.5 : 1)
                    
                    
                    
                }
                Text("\(AppSetting.maxLengthOfTerm)文字以内のみ設定可能です")
                    .font(.caption)
                    .foregroundColor(tutorialVM.shortTermEditText.count > AppSetting.maxLengthOfTerm ? .red : .clear)
            }
            
            Spacer()
            
            
            //                        戻るボタン
            HStack{
                Button {
                    tutorialVM.page = 1
                    ///目標を保存
                    store.longTermGoal = tutorialVM.longTermEditText
                    store.shortTermGoal = tutorialVM.shortTermEditText
                } label: {
                    ArrowButton(isBackButton: true, labelText: "戻る")
                }
                
                Spacer()
                
                //                    進むボタン
                Button {
                    tutorialVM.page = 3
                    
                    ///目標を保存
                    store.longTermGoal = tutorialVM.longTermEditText
                    store.shortTermGoal = tutorialVM.shortTermEditText
                } label: {
                    ArrowButton(isBackButton: false, labelText: "次へ")
                        .opacity(!tutorialVM.longTermEditText.isEmpty && !tutorialVM.shortTermEditText.isEmpty && tutorialVM.longTermEditText.count <= AppSetting.maxLengthOfTerm && tutorialVM.shortTermEditText.count <= AppSetting.maxLengthOfTerm ? 1 : 0.4)
                }
                
                //                    次へボタンの無効判定
                .disabled(tutorialVM.longTermEditText.isEmpty || tutorialVM.shortTermEditText.isEmpty || tutorialVM.longTermEditText.count > AppSetting.maxLengthOfTerm || tutorialVM.shortTermEditText.count > AppSetting.maxLengthOfTerm)
            }
            .padding(.bottom, 30)
        }
        
        //        .frame(minHeight: AppSetting.screenHeight/1.6)
        .padding()
        .foregroundColor(Color(UIColor.label))
        
        .onAppear{
            tutorialVM.longTermEditText = store.longTermGoal
            tutorialVM.shortTermEditText = store.shortTermGoal
        }
        
        
        ///キーボード閉じるボタンを配置
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                //1つめのテキストフィールド入力中
                if longTermEditorFocus && !shortTermEditorFocus{
                    Button("次へ"){
                        shortTermEditorFocus = true
                    }
                }else{
                    Button("閉じる"){
                        longTermEditorFocus = false
                        shortTermEditorFocus = false
                    }
                }
            }
        }
        .foregroundColor(Color(UIColor.label))
    }
}
