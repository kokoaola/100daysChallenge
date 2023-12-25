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
    [     //紙吹雪,
        "Jason Leung",
        
        //グラフィック,
        "Alejandro Ortiz",
        
        //グラデーション赤
        "Codioful (Formerly Gradienta)",
        
        //宇宙星たくさん,
        "Paul Volkmer",
        
        //グラフィック紫
        "Alejandro Ortiz2",
        
        //オーロラj
        "Yang Xi",
        
        //木目
        "Mockup Photos",
        
        //グラフィック,
        "Alejandro Ortiz4",
        
        //宇宙ぐるぐる,
        "Pawel Czerwinski",
        
        //グラフィック,
        "Alejandro Ortiz3",
        
        //グラデーション青緑
        "Codioful (Formerly Gradienta)2"
        
        
    ]
    
    //Date型をString型に変換する
    static func makeDate(day: Date)-> String{
        let df = DateFormatter()
        df.locale = Locale(identifier: "ja-Jp")
        df.dateStyle = .short
        return df.string(from: day)
    }
    
    //Date型をString型に変換する
    static func makeAccessibilityDate(day: Date) -> String {
        let df = DateFormatter()
        df.locale = Locale(identifier: "ja_JP")
        df.dateFormat = "yyyy年M月d日"
        return df.string(from: day)
    }
    
    static func colseKeyBoard(){
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        keyWindow?.endEditing(true)
    }
}

