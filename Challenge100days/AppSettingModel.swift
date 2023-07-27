//
//  AppSetting.swift
//  Challenge100days
//
//  Created by koala panda on 2023/02/18.
//

import SwiftUI

enum AppColor {
    case blue
    case orange
    case purple
    case monotone
}


///アプリ全体の設定
struct AppSetting{
    ///使用端末の横画面サイズ
    static let screenWidth = UIScreen.main.bounds.width
    
    ///使用端末の縦画面サイズ
    static let screenHeight = UIScreen.main.bounds.height
    
    ///目標の文字の上限
    static let maxLengthOfTerm = 50
    
    ///メモの文字の上限
    static let maxLengthOfMemo = 1000
    
    /// 全画像名を格納した配列
    static let photos =
    [     //紙吹雪
        "Jason Leung",
        
        //グラフィック
        "Alejandro Ortiz",
        
        //オーロラ
        "Yang Xi",
        
        //グラフィック
        "Alejandro Ortiz2",
        
        //宇宙星たくさん
        "Paul Volkmer",
        
        //グラフィック
        "Alejandro Ortiz3",
        
        //お花
        "Daria Nepriakhina",
        
        //グラフィック
        "Alejandro Ortiz4",
        
        //宇宙ぐるぐる
        "Pawel Czerwinski",
        
        //グラデーション
        "Codioful (Formerly Gradienta)"
    ]
}
