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
    @EnvironmentObject var userSettingViewModel:UserSettingViewModel
    
    ///表示中のページ番号を格納
    @Binding var page: Int
    
    var body: some View {
        
        ZStack(alignment: .top){
            
            VStack(alignment: .leading, spacing: 50){
                Text("設定は以上です。").padding(.bottom)
                Text("これらの設定は、アプリの設定ページからも変更可能です。")
                Text("それでは、さっそく始めましょう。")
                
                Spacer()
                
                HStack{
                    //戻るボタン
                    Button{
                        page = 2
                    } label: {
                        BackButton()
                    }
                    
                    Spacer()
                    
                    //startボタン
                    Button {
                        userSettingViewModel.toggleTutorialStatus(isFinish: true)
                    } label: {
                        NextButton(isStart: true)
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
    @State static var sampleNum = 1
    static var previews: some View {
        Group{
            TutorialView3(page: $sampleNum)
                .environment(\.locale, Locale(identifier:"en"))
            TutorialView3(page: $sampleNum)
                .environment(\.locale, Locale(identifier:"ja"))
        }
        .environmentObject(UserSettingViewModel())
    }
}
