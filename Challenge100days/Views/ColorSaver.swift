//
//  ColorSaveUserDefaults.swift
//  Challenge100days
//
//  Created by koala panda on 2023/02/14.
//

import Foundation
import SwiftUI
import UIKit


///引数で受け取った番号に応じた背景色を指定するViewModifier
struct UserSettingGradient: ViewModifier{
    let appColorNum: Int
    var colors:[Color]{
        switch appColorNum{
        case 0:
            return [.blue, .green]
        case 1:
            return [.green, .yellow]
        case 2:
            return [.purple, .blue]
        case 3:
            return [.black, .black]
        default:
            return [.blue, .green]
        }
    }
    
    func body(content: Content) -> some View{
        content.background(.secondary).foregroundStyle(LinearGradient(
            colors: [colors[0], colors[1]],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ))
    }
}

//func userSettingBottomColors(colorNum: Int) -> Color{
//        switch colorNum{
//        case 0:
//            return .primary
//        case 1:
//            return .primary
//        case 2:
//            return .primary
//        case 3:
//            return .primary
//        default:
//            return .primary
//        }
//    }



/*
 使う時：
 
 @State private var selectedColor = 0
 VStack{
     Picker(selection: $selectedColor) {
         Text("青").tag(0)
         Text("オレンジ").tag(1)
         Text("紫").tag(2)
         Text("モノトーン").tag(3)
         } label: {
         Text("アプリの色を変更する")
     }
 }
 //背景グラデーション設定
 .modifier(UserSettingGradient(appColorNum: selectedColor))
 
 
 */
