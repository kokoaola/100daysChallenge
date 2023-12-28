//
//  TutorialComponents.swift
//  Challenge100days
//
//  Created by koala panda on 2023/12/27.
//

import SwiftUI


///チュートリアル用の矢印付きボタンのビュー
struct ArrowButton: View{
    ///戻るボタンか選択する変数
    var isBackButton: Bool
    ///表示する文言を格納する変数
    var labelText: String
    
    ///角丸のレベルを格納する変数
    let radius:CGFloat = 10.0
    ///ボタンの幅と高さを格納する変数
    let width = AppSetting.screenWidth / 3
    let height = AppSetting.screenWidth / 6
    ///文字色を格納する変数
    let tint = Color.white
    
    var body: some View {
        ZStack(alignment: .center){
            
            RoundedRectangle(cornerRadius: radius)
                .frame(width: width, height: height)
            
            HStack(alignment: .firstTextBaseline, spacing: 5){
                if isBackButton{
                    Image(systemName: "arrowshape.left")
                    Text(LocalizedStringKey(labelText))
                }else{
                    Text(LocalizedStringKey(labelText))
                    Image(systemName: "arrowshape.right")
                }
            }
            .font(.title2.weight(.bold))
            .foregroundColor(tint)
        }
        .foregroundColor( isBackButton ? .orange : .green)
    }
}
