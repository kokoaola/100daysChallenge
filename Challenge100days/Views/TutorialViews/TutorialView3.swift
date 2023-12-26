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
    @EnvironmentObject var store: Store
    @ObservedObject var tutorialVM: TutorialViewModel
    
    var body: some View {
        
        ZStack(alignment: .top){
            VStack(alignment: .leading, spacing: 30){
                VStack(alignment: .leading, spacing: 30){
                    Text("設定は以上です。")
                    Text("これらの設定は、アプリの設定ページからも変更可能です。")
                    Text("それでは、さっそく始めましょう。")
                }
                .contentShape(Rectangle())
                .accessibilityElement(children: .combine)
                
                Spacer()
                
                HStack{
                    //戻るボタン
                    Button{
                        tutorialVM.page = 2
                    } label: {
                        ArrowButton(isBackButton: true, labelText: "戻る")
                    }
                    
                    Spacer()
                    
                    //startボタン
                    Button {
                        store.userSelectedTag = "One"
                        //初回起動フラグのfalseにしてユーザーデフォルトに保存
                        store.isFirst = false
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




struct TutorialView3_Previews: PreviewProvider {
    @StateObject static var tutorialViewModel = TutorialViewModel()
    static var previews: some View {
        Group{
            TutorialView3(tutorialVM: tutorialViewModel)
                .environment(\.locale, Locale(identifier:"ja"))
            TutorialView3(tutorialVM: tutorialViewModel)
                .environment(\.locale, Locale(identifier:"en"))
        }
        .environmentObject(Store())
    }
}
