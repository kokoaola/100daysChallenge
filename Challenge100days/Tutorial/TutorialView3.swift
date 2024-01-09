//
//  TutorialView3.swift
//  Challenge100days
//
//  Created by koala panda on 2023/02/14.
//

import SwiftUI


///チュートリアル３ページ目
struct TutorialView3: View {
    ///ViewModel用の変数
    @ObservedObject var tutorialVM: TutorialViewModel
    @EnvironmentObject var userDefaultsStore: UserDefaultsStore
    
    var body: some View {
        
        ZStack(alignment: .top){
            VStack(alignment: .leading, spacing: 30){
                VStack(alignment: .leading, spacing: 30){
                    Text("設定は以上です。")
                    Text("これらの設定は、アプリの設定ページからも変更可能です。")
                    Text("それでは、さっそく始めましょう。")
                }
                //VoiceOver用の設定
                .contentShape(Rectangle())
                .accessibilityElement(children: .combine)
                
                Spacer()
                
                HStack{
                    ///戻るボタン
                    Button{
                        tutorialVM.page = 2
                    } label: {
                        ArrowButton(isBackButton: true, labelText: "戻る")
                    }
                    
                    Spacer()
                    
                    ///startボタン
                    Button {
                        withAnimation {
                            userDefaultsStore.isFirst = false //初回起動フラグのfalseにして保存
                        }
                    } label: {
                        ArrowButton(isBackButton: false, labelText: "始める")
                    }
                }
                .padding(.bottom, 30)
                .frame(maxWidth: .infinity, alignment: .bottom)
            }
            .padding()
        }
    }
}
