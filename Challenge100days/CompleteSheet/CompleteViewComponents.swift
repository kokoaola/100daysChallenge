//
//  CompleteViewComponents.swift
//  Challenge100days
//
//  Created by koala panda on 2023/12/27.
//

import SwiftUI


///リンクボタンのビュー
struct ShareLinkView: View {
    var image: Image?
    var dayNumber: Int
    
    var body: some View {
        ShareLink(
            item: image ?? Image("noImage"),
            message: Text("#Day\(dayNumber) #100DaysChallenge #100日チャレンジ\n"),
            //message: Text("Day\(dayNumber) of #100DaysChallenge\nhttps://apps.apple.com/app/id6449479183"),
            preview: SharePreview("Day\(dayNumber) of 100DaysChallenge", image: image ?? Image("noImage"))){
                LeftIconBigButton(color: .blue, icon: Image(systemName: "square.and.arrow.up"), text: "シェアする")
            }
    }
}


///日付入りの画像のビュー
struct CompleteImageView: View {
    @Binding var image: Image?
    
    var body: some View {
        if let image = image{
            image
                .resizable().scaledToFit()
                .accessibilityLabel("日付入りの綺麗な画像")
                .padding()
                .frame(height: AppSetting.screenHeight * 0.3)
        }else{
            ProgressView()
                .frame(height: AppSetting.screenHeight * 0.3)
        }
    }
}
