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
    
    ///入力したテキストを格納するプロパティ
    @State private var longTermEditText = ""
    @State private var shortTermEditText = ""
    
    ///キーボードフォーカス用変数（Doneボタン表示のため）
    @FocusState var firstTextEditorFocus: Bool
    
    
    ///キーボードフォーカス用変数（Doneボタン表示のため）
    @FocusState var secondTextEditorFocus: Bool
    
    ///表示中のページ番号を格納
    @Binding var page: Int
    
    var body: some View {
        VStack(alignment: .leading){
            Text("次に、目標を設定してください。")
            
            ///長期目標
            VStack(alignment: .leading){
                Text("①あなたが将来なりたい姿はなんですか？")

                ZStack(alignment: .topLeading){
                    if !longTermEditText.isEmpty{
                        EmptyView()
                    }else{
                        Text("例）画力アップ\n　　TOEIC800点").padding(5)
                    }
                    
                    ///テキストエディター
                    TextEditor(text: $longTermEditText)
                        .scrollContentBackground(Visibility.hidden)
                        .background(.ultraThinMaterial)
                        .border(.white, width: 1)
                        .frame(height: AppSetting.screenHeight / 12)
                        .focused($firstTextEditorFocus)
                        .opacity(longTermEditText.isEmpty ? 0.5 : 1)
                }
                
                Text("\(AppSetting.maxLengthOfTerm)文字以内のみ設定可能です")
                    .font(.caption)
                    .foregroundColor(longTermEditText.count > AppSetting.maxLengthOfTerm ? .red : .clear)
            }
            
            
            ///短期目標
            VStack(alignment: .leading){
                Text("②その実現のために１００日間取り組むことはなんですか？")
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                
                
                ZStack(alignment: .topLeading){
                    if !shortTermEditText.isEmpty{
                        EmptyView()
                    }else{
                        Text("例）１日１枚絵を描く\n　　英語の勉強").padding(5)
                   }
                    
                    ///テキストエディター
                    TextEditor(text: $shortTermEditText)
                        .scrollContentBackground(Visibility.hidden)
                        .background(.ultraThinMaterial)
                        .border(.white, width: 1)
                        .frame(height: AppSetting.screenHeight / 12)
                        .focused($secondTextEditorFocus)
                        .opacity(shortTermEditText.isEmpty ? 0.5 : 1)
                    
                    
                    
                }
                Text("\(AppSetting.maxLengthOfTerm)文字以内のみ設定可能です")
                    .font(.caption)
                    .foregroundColor(shortTermEditText.count > AppSetting.maxLengthOfTerm ? .red : .clear)
            }
            
            Spacer()
            
            
            //                        戻るボタン
            HStack{
                Button {
                    page = 1
                    ///目標を保存
                    store.longTermGoal = longTermEditText
                    store.shortTermGoal = shortTermEditText
                } label: {
                    ArrowButton(isBackButton: true, labelText: "戻る")
                }
                
                Spacer()
                
                //                    進むボタン
                Button {
                    page = 3
                    
                    ///目標を保存
                    store.longTermGoal = longTermEditText
                    store.shortTermGoal = shortTermEditText
                } label: {
                    ArrowButton(isBackButton: false, labelText: "次へ")
                        .opacity(!longTermEditText.isEmpty && !shortTermEditText.isEmpty && longTermEditText.count <= AppSetting.maxLengthOfTerm && shortTermEditText.count <= AppSetting.maxLengthOfTerm ? 1 : 0.4)
                }
                
                //                    次へボタンの無効判定
                .disabled(longTermEditText.isEmpty || shortTermEditText.isEmpty || longTermEditText.count > AppSetting.maxLengthOfTerm || shortTermEditText.count > AppSetting.maxLengthOfTerm)
            }
            .padding(.bottom, 30)
        }
        
        //        .frame(minHeight: AppSetting.screenHeight/1.6)
        .padding()
        .foregroundColor(Color(UIColor.label))
        
        .onAppear{
            longTermEditText = store.longTermGoal
            shortTermEditText = store.shortTermGoal
        }
        
        
        ///キーボード閉じるボタンを配置
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                //1つめのテキストフィールド入力中
                if firstTextEditorFocus && !secondTextEditorFocus{
                    Button("次へ"){
                        secondTextEditorFocus = true
                    }
                }else{
                    Button("閉じる"){
                        firstTextEditorFocus = false
                        secondTextEditorFocus = false
                    }
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
        .environmentObject(Store())
    }
}
