//
//  TutorialView3.swift
//  Challenge100days
//
//  Created by koala panda on 2023/02/14.
//

import SwiftUI

struct TutorialView3: View {
    ///入力したテキストを格納するプロパティ
    @State private var editText = ""
    
    ///キーボードフォーカス用変数（Doneボタン表示のため）
    @FocusState var isInputActive: Bool
    
    ///入力したテキストを格納するプロパティ
    @State private var editText2 = ""
    
    ///キーボードフォーカス用変数（Doneボタン表示のため）
    @FocusState var isInputActive2: Bool
    @Binding var page: Int
    
    @AppStorage("isFirst") var isFirst = true
    
    var body: some View {
        
        ZStack(alignment: .top){
            
            VStack(alignment: .leading, spacing: 30){
                Text("設定は以上です。").padding(.bottom)
                
                Text("これらの設定は、アプリの設定ページからも変更可能です。")
                
                Text("それでは、さっそく始めましょう。")
                
                Spacer()
                HStack{
                    
                    Button{
                        
                        page = 2
                        
                    } label: {
                        TutorialButton2(labelString: "戻る", labelImage: "arrowshape.left")
                            .foregroundColor(.orange)
                    }
                    Spacer()
                    Button {
                        
                        isFirst = false
                        
                    } label: {
                        TutorialButton(labelString: "始める", labelImage: "arrowshape.right")
                            .foregroundColor(.green)
                    }
                    
                }
                .padding(.bottom)
                .frame(maxWidth: .infinity, alignment: .bottom)
                
            }
            .padding()
            .foregroundColor(Color(UIColor.label))
            
            
            
            
            
            
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
        }
    }
    
}

struct TutorialView3_Previews: PreviewProvider {
    @State static var a = 1
    static var previews: some View {
        TutorialView3(page: $a)
    }
}
