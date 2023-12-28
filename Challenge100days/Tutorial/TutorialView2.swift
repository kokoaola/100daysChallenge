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
                
                //プレースホルダーを重ねて表示
                ZStack(alignment: .topLeading){
                    if !tutorialVM.longTermEditText.isEmpty{
                        EmptyView()
                    }else{
                        Text("例）画力アップ\n　　TOEIC800点").padding(5)
                    }
                    
                    ///テキストエディター
                    TextEditor(text: $tutorialVM.longTermEditText)
                        .focused($longTermEditorFocus)
                        .opacity(tutorialVM.longTermEditText.isEmpty ? 0.5 : 1)
                        .customTutorialTextEditStyle()
                }
                
                Text("\(AppSetting.maxLengthOfTerm)文字以内のみ設定可能です")
                    .font(.caption)
                    .foregroundColor(tutorialVM.isLongTermLengthValid ? .clear : .red)
            }
            
            
            ///短期目標
            VStack(alignment: .leading){
                Text("②その実現のために１００日間取り組むことはなんですか？")
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                
                //プレースホルダーを重ねて表示
                ZStack(alignment: .topLeading){
                    if !tutorialVM.shortTermEditText.isEmpty{
                        EmptyView()
                    }else{
                        Text("例）１日１枚絵を描く\n　　英語の勉強").padding(5)
                    }
                    
                    ///テキストエディター
                    TextEditor(text: $tutorialVM.shortTermEditText)
                        .focused($shortTermEditorFocus)
                        .opacity(tutorialVM.shortTermEditText.isEmpty ? 0.5 : 1)
                        .customTutorialTextEditStyle()
                }
                
                Text("\(AppSetting.maxLengthOfTerm)文字以内のみ設定可能です")
                    .font(.caption)
                    .foregroundColor(tutorialVM.isShortTermLengthValid ? .clear : .red)
            }
            
            Spacer()
            
            ///戻るボタン
            HStack{
                Button {
                    tutorialVM.page = 1
                    tutorialVM.saveTerm() //目標を保存
                } label: {
                    ArrowButton(isBackButton: true, labelText: "戻る")
                }
                
                Spacer()
                
                ///進むボタン
                Button {
                    tutorialVM.page = 3
                    tutorialVM.saveTerm() //目標を保存
                } label: {
                    ArrowButton(isBackButton: false, labelText: "次へ")
                        .opacity(tutorialVM.isNextButtonNotFade ? 1 : 0.4)
                }
                
                //次へボタンの無効判定
                .disabled(!tutorialVM.isNextButtonValid)
            }
            .padding(.bottom, 30)
        }
        .padding()
        .foregroundColor(Color(UIColor.label))
        
        ///ビュー表示時に目標をテキストフィールドにセット
        .onAppear{
            tutorialVM.setTermToTextField()
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
                    //2つめのテキストフィールド入力中
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
