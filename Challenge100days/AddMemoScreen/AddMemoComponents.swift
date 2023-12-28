//
//  AddMemoComponents.swift
//  Challenge100days
//
//  Created by koala panda on 2023/12/28.
//

import SwiftUI


///シート等の閉じるボタンのビュー
struct CloseButton: View{
    var body: some View {
        Text("閉じる")
            .foregroundColor(.blue)
            .padding()
    }
}


///アイコンが左にある大きいボタンのビュー
struct LeftIconBigButton: View{
    let color: Color
    ///アイコンを受け取って格納する変数
    let icon: Image?
    
    ///表示するStringを受け取って格納する変数
    let text: String
    
    ///角丸のレベルを格納する変数
    let radius:CGFloat = 10.0
    
    ///ボタンの幅を格納する変数
    let width = UIDevice.current.userInterfaceIdiom == .pad ? AppSetting.screenWidth / 3 : AppSetting.screenWidth / 1.7
    
    ///ボタンの高さを格納する変数
    let height = AppSetting.screenWidth / 5
    
    ///文字色を格納する変数
    let tint = Color(UIColor.white)
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: radius)
                .frame(width: width, height: height)
                .foregroundColor(tint)
            RoundedRectangle(cornerRadius: radius)
                .frame(width: width - 7, height: height - 7)
            HStack(alignment: .lastTextBaseline){
                icon
                Text(LocalizedStringKey(text))
            }
            .font(.title2.weight(.bold))
            .foregroundColor(tint)
        }
        .foregroundColor(color.opacity(0.9))
    }
}
