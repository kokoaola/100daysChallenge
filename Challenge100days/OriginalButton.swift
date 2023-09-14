//
//  OriginalButton.swift
//  timer
//
//  Created by koala panda on 2023/01/20.
//

import SwiftUI


///シート等の閉じるボタンのビュー
struct CloseButton: View{
    var body: some View {
        Image(systemName: "xmark")
            .font(.title3).foregroundColor(.primary)
            .padding()
    }
}


///チュートリアル用の矢印付きボタンのビュー
struct ArrowButton: View{
    ///戻るボタンか選択する変数
    var isBackButton: Bool
    ///表示する文言を格納する変数
    var labelText: String
    
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


///コンプリートボタンビュー
struct CompleteButton: View {
    ///ボタンの幅を格納する変数
    let width = 300.0
    
    ///ボタンの高さを格納する変数
    let height = 170.0
    
    ///番号を受け取って格納する変数
    let num: Int
    
    var body: some View {
        
        Capsule()
            .frame(width: width, height: height)
            .shadow(color:Color.black, radius: 5.0,
                    x: 8, y: 8)
        
            .overlay{
                VStack{
                    Text("\(num) / 100")
                    Text("Complete!")
                    
                }
                .font(.largeTitle.weight(.bold))
                .foregroundColor(.white)
                
                
                Capsule()
                    .stroke(lineWidth: 10)
                    .foregroundColor(.white)
                    .frame(width: width-10, height: height-10)
            }
    }
}


///アイコンが左にある大きいボタンのビュー
struct LeftIconBigButton: View{
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
    }
}




struct OriginalButton_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            
            VStack{
                LeftIconBigButton(icon: Image(systemName: "rectangle.and.pencil.and.ellipsis"), text: "メモを追加")
                
                CloseButton()
                HStack{
                    ArrowButton(isBackButton: true, labelText: "戻る")
                    ArrowButton(isBackButton: false, labelText: "次へ")
                }
                SaveButton()
                CompleteButton(num: 1)
            }
            .environment(\.locale, Locale(identifier:"en"))
            
            VStack{
                CloseButton()
                HStack{
                    ArrowButton(isBackButton: true, labelText: "戻る")
                    ArrowButton(isBackButton: false, labelText: "次へ")
                }
                SaveButton()
                CompleteButton(num: 1)
            }
            .environment(\.locale, Locale(identifier:"ja"))
        }
    }
}
