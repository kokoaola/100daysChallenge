//
//  AppSetting.swift
//  Challenge100days
//
//  Created by koala panda on 2023/02/18.
//

import SwiftUI

///アプリ全体の設定
struct AppSetting{
    ///使用端末の横画面サイズ
    static let screenWidth = UIScreen.main.bounds.width
    
    ///使用端末の縦画面サイズ
    static let screenHeight = UIScreen.main.bounds.height
    
    ///文字の色
    static let labelColr = Color(UIColor.label)

    /// 全画像名を格納した配列
         static let photos = ["Alejandro Ortiz2", "Alejandro Ortiz3", "Pawel Czerwinski", "Paul Volkmer","Daria Nepriakhina", "Gradienta","Alejandro Ortiz", "Jason Leung",  "Alejandro Ortiz4"]
//    static let photos = ["noImage", "Alejandro Ortiz2", "Alejandro Ortiz3", "Pawel Czerwinski", "Dayne Topkin", "Paul Volkmer","Shahadat Rahman","Daria Nepriakhina", "Gradienta","Alejandro Ortiz", "Jason Leung",  "Alejandro Ortiz4"]
    
    ///目標の文字の上限
    static let maxLngthOfTerm = 50
    
    ///メモの文字の上限
    static let maxLngthOfMemo = 300
}
