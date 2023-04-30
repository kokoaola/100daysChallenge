//
//  Tutorial.swift
//  Challenge100days
//
//  Created by koala panda on 2023/02/12.
//

import SwiftUI

struct TutorialView2: View {
    ///入力したテキストを格納するプロパティ
    @State private var editText = ""
    
    ///キーボードフォーカス用変数（Doneボタン表示のため）
    @FocusState var isInputActive: Bool
    
    ///入力したテキストを格納するプロパティ
    @State private var editText2 = ""
    
    ///キーボードフォーカス用変数（Doneボタン表示のため）
    @FocusState var isInputActive2: Bool
    
    @Binding var page: Int
    
    @AppStorage("longTermGoal") var longTermGoal: String = ""
    @AppStorage("shortTermGoal") var shortTermGoal: String = ""
    
    @AppStorage("isFirst") var isFirst = true
    
    ///選択された日付が有効か判定するプロパティ
    @State var isVailed = false
    
    var body: some View {

                
        VStack(alignment: .leading){
                    Text("次に、目標を設定してください。")
                //.padding(.bottom)
                    
                    VStack{
                        Text("①あなたが１００日後になりたい姿はなんですか？")
                            .frame(minHeight: 60)
                            //.fixedSize(horizontal: false, vertical: true)
                            
                            
                        ZStack(alignment: .topLeading){
                            if editText.isEmpty{
                                Text("例）画力アップ\n　　TOEIC800点")
//                                Text("例）九九の達人\n　　画力アップ\n　　TOEIC800点")
                                    .padding(8)
                                    .foregroundColor(.primary)
                            }

                            
                            ///テキストエディター
                            TextEditor(text: $editText)
                                .foregroundColor(Color(UIColor.label))
                                .scrollContentBackground(Visibility.hidden)
                                .background(.ultraThinMaterial)
                                .border(.white, width: 1)
                                .frame(height: 80)
                                .focused($isInputActive)
                                .opacity(editText.isEmpty ? 0.5 : 1)
                        }
                    }
                    .padding(.bottom)
            
            
                    VStack{
                        Text("②その実現のために１００日間取り組むことはなんですか？")
                            .frame(minHeight: 60)
                           // .fixedSize(horizontal: false, vertical: true)
                        ZStack(alignment: .topLeading){
                            if editText2.isEmpty{
                                Text("例）１日１枚絵を描く\n　　英語の勉強\n")
//                                Text("例）算数のドリル\n　　１日１枚絵を描く\n　　英語の勉強")
                                    .padding(8)
                                    .foregroundColor(.primary)
                            }
                            
                            ///テキストエディター
                            TextEditor(text: $editText2)
                                .foregroundColor(Color(UIColor.label))
                            //.lineSpacing(10)
                                .scrollContentBackground(Visibility.hidden)
                                .background(.ultraThinMaterial)
                                .border(.white, width: 1)
                                .frame(height: 80)
                                .focused($isInputActive2)
                                .opacity(editText2.isEmpty ? 0.5 : 1)
                            

                        }
                    }
                
                Spacer()
                HStack{
                    
                    Button {
                        page = 1
                    } label: {
                        TutorialButton2(labelString: "戻る", labelImage: "arrowshape.left")
                            .foregroundColor(.orange)
                    }
                    Spacer()
                    Button {
                        longTermGoal = editText
                        shortTermGoal = editText2
                        page = 3
                    } label: {
                        TutorialButton(labelString: "次へ", labelImage: "arrowshape.right")
                            .foregroundColor(isVailed ? .green : .gray)
                    }
                    .disabled(isVailed == false)
                    
                }
                .padding(.bottom)
                }

        .frame(minHeight: AppSetting.screenHeight/1.6)
        .padding()
        .foregroundColor(Color(UIColor.label))
        
        .onChange(of: editText2, perform: { newValue in
            if newValue.isEmpty == false && editText.isEmpty == false{
                isVailed = true
            }
        })
            
        ///キーボード閉じるボタンを配置
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    isInputActive = false
                    isInputActive2 = false
                
                }
            }
        }
        .foregroundColor(Color(UIColor.label))
    }
        
}

struct TutorialView2_Previews: PreviewProvider {
    @State static var a = 1
    static var previews: some View {
        TutorialView2(page: $a)
    }
}
