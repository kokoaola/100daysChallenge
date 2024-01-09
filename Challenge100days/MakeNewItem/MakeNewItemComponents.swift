//
//  MakeNewItemComponents.swift
//  Challenge100days
//
//  Created by koala panda on 2023/12/28.
//

import SwiftUI

///保存ボタンビュー
struct SaveButton: View {
    ///角丸のレベルを格納する変数
    let radius:CGFloat = 10.0
    
    ///ボタンの幅を格納する変数
    let width = AppSetting.screenWidth / 3
    
    ///ボタンの高さを格納する変数
    let height = AppSetting.screenWidth / 6
    
    ///文字色を格納する変数
    let tint = Color.white
    
    var body: some View {
        ZStack(alignment: .center){
            
            RoundedRectangle(cornerRadius: radius)
                .frame(width: width, height: height)
            
            HStack(alignment: .firstTextBaseline, spacing: 5){
                Text("保存する")
                Image(systemName: "checkmark.circle")
            }
            .font(.title2.weight(.bold))
            .foregroundColor(tint)
        }
    }
}
