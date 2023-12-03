//
//  generateImageWithText.swift
//  Challenge100days
//
//  Created by koala panda on 2023/02/04.
//

import SwiftUI
import UIKit


///引数で受け取った日付と番号を入れて画像を生成するメソッド
func generateImageWithText(number: Int, day: Date) -> Image {
    
    //日数に応じて画像を指定
    var imageIndex = 0
    
    switch number{
    case (0...9):
        imageIndex = 1
    case (11...19):
        imageIndex = 2
    case (21...29):
        imageIndex = 3
    case (31...39):
        imageIndex = 4
    case (41...49):
        imageIndex = 5
    case (51...59):
        imageIndex = 6
    case (61...69):
        imageIndex = 7
    case (71...79):
        imageIndex = 8
    case (81...89):
        imageIndex = 9
    case (91...99):
        imageIndex = 0
    default:
        imageIndex = 0
    }
    
    
    let imageName = AppSetting.photos[imageIndex]
    
    
    //画像をUIImageに変換に変換
    guard let image = UIImage(named: imageName) else{
        return Image("noImage")
    }
    
    //UIImageViewを生成(文字の後ろの背景として重ねるため)
    let imageView = UIImageView(image: image)
    imageView.backgroundColor = UIColor.clear
    imageView.frame = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
    
    //画像に重ねたい文字を設定
    let year = Calendar(identifier: .gregorian).dateComponents([.year, .month, .day], from: day)
    
    
    
    //太さやサイズを指定してラベルを作る
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
    label.textAlignment = .center
    label.textColor = UIColor(.white)
    //フォントサイズと書体変更している（サイズだけなら label.font.withSize(500)でOK）
    //label.font = UIFont.systemFont(ofSize: image.size.width / 10, weight: UIFont.Weight(rawValue: 0.6), width: UIFont.Width(rawValue: 0.0))
    //複数行表示するための設定(最大行使える)
    label.numberOfLines = 0
    
    //一番大きい100daysの部分
    let stringAttributes1: [NSAttributedString.Key : Any] = [
        .font: UIFont.systemFont(ofSize: image.size.width / 11, weight: UIFont.Weight.heavy, width: UIFont.Width(rawValue: 0)),.kern: 3,
    ]
    //本文
    let string1 = NSAttributedString(string: "100Days Challenge\nDay \(number) Done!\n", attributes: stringAttributes1)
    
    //日付の部分
    let stringAttributes2: [NSAttributedString.Key : Any] = [
        .font: UIFont.systemFont(ofSize: image.size.width / 16,weight: UIFont.Weight.black,width: UIFont.Width(rawValue: 0.0)),.kern: 3,
    ]
    
    //本文
    let string2 = NSAttributedString(string: "\(year.year!) / \(year.month!) / \(year.day!)", attributes: stringAttributes2)
    
    //空白部分
    let empty: [NSAttributedString.Key : Any] = [
        .font: UIFont.systemFont(ofSize: image.size.width / 28, weight: UIFont.Weight.regular)
    ]
    let emptystring = NSAttributedString(string: "\n", attributes:empty)
    
    
    //クレジットの部分
    let para = NSMutableParagraphStyle()
    para.alignment = .right
    para.tailIndent = -50
    let stringAttributes3: [NSAttributedString.Key : Any] = [
        .font: UIFont.systemFont(ofSize: image.size.width / 30, weight: UIFont.Weight.regular),
        .foregroundColor: UIColor.white.withAlphaComponent(0.7),
        .kern: 2,
        .baselineOffset: 0,
        .paragraphStyle: para,
    ]
    var formattedString = imageName
    
    //何枚もある作家は番号を削除
    if imageName.contains("Alejandro"){
        formattedString.removeLast()
    }
    //本文
    let string3 = NSAttributedString(string: " Photo by \(formattedString) ", attributes:stringAttributes3)
    
    //attributedに追加する
    let mutableAttributedString = NSMutableAttributedString()
    mutableAttributedString.append(emptystring)
    mutableAttributedString.append(emptystring)
    mutableAttributedString.append(emptystring)
    mutableAttributedString.append(string1)
    mutableAttributedString.append(emptystring)
    mutableAttributedString.append(emptystring)
    mutableAttributedString.append(string2)
    mutableAttributedString.append(emptystring)
    mutableAttributedString.append(emptystring)
    mutableAttributedString.append(emptystring)
    mutableAttributedString.append(string3)
    label.attributedText = mutableAttributedString
    
    //作ったラベルを重ねる
    UIGraphicsBeginImageContextWithOptions(label.bounds.size, false, 0)
    imageView.layer.render(in: UIGraphicsGetCurrentContext()!)
    label.layer.render(in: UIGraphicsGetCurrentContext()!)
    let imageWithText = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    //Imageを返すときはこっち
    return Image(uiImage: imageWithText!)
    
    //UIImageを返すときはこっち
    //return imageWithText ?? UIImage(named: "noImage")!
    
    //Dataを返すときはこっち
    //return imageWithText?.jpegData(compressionQuality: 1)
}
