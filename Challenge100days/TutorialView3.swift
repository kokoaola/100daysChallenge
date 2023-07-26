//
//  TutorialView3.swift
//  Challenge100days
//
//  Created by koala panda on 2023/02/14.
//

import SwiftUI

struct TutorialView3: View {
    @EnvironmentObject var userSettingViewModel:UserSettingViewModel
//    ///入力したテキストを格納するプロパティ
//    @State private var editText = ""
    
//    ///キーボードフォーカス用変数（Doneボタン表示のため）
//    @FocusState var isInputActive: Bool
    
//    ///入力したテキストを格納するプロパティ
//    @State private var editText2 = ""
    
    ///キーボードフォーカス用変数（Doneボタン表示のため）
//    @FocusState var isInputActive2: Bool
    @Binding var page: Int
//
//    @AppStorage("isFirst") var isFirst = true
    
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
                        BackButton()
                            .foregroundColor(.orange)
                    }
                    Spacer()
                    Button {
                        userSettingViewModel.toggleTutorialStatus(isFinish: true)
                    } label: {
                        StartButton()
                            .foregroundColor(.green)
                    }
                    
                }
                .padding(.bottom, 30)
                .frame(maxWidth: .infinity, alignment: .bottom)
                
            }
            .padding()
            .foregroundColor(Color(UIColor.label))
            
            
            
            
            
            
            ///キーボード閉じるボタンを配置
//            .toolbar {
//                ToolbarItemGroup(placement: .keyboard) {
//                    Spacer()
//                    Button("閉じる") {
//                        isInputActive = false
//                        isInputActive2 = false
//
//                    }
//                }
//            }
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
