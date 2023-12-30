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
    //色
    let color: Color
    //アイコン
    let icon: Image?
    //表示するString
    let text: String
    
    var body: some View {
        //角丸のレベル
        let radius:CGFloat = 10.0
        //ボタンの幅と高さ
        let width = UIDevice.current.userInterfaceIdiom == .pad ? AppSetting.screenWidth / 3 : AppSetting.screenWidth / 1.7
        let height = AppSetting.screenWidth / 5
        //文字色
        let tint = Color(UIColor.white)
        
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
