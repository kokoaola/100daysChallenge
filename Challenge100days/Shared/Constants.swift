//
//  Constants.swift
//  CoreDataAndWidget
//
//  Created by koala panda on 2023/09/28.
//
import Foundation
import SwiftUI
import WidgetKit


///このアプリ内のさまざまな場所で使用される定数をまとめたファイル

struct AppGroupConstants{
    // App Groupを利用するためのコンテナURLを取得。ここで指定するIDはApp Groupsで設定したもの
    static let appGroupContainerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.challenge100days")!
    
    // ウィジェットの識別子。これを利用してウィジェットのタイムラインをリロードする
    static var gaugeWidgetKind = "amatnug.amatnug.gaugeWidget"
    static var numberWidgetKind = "amatnug.amatnug.NumberWidget"
    
    // WidgetCenterを通じて、特定のウィジェットのタイムラインをリロードする。アプリ内でデータ変更があった時などに呼ぶ
    static func reloadTimelines(){
        WidgetCenter.shared.reloadTimelines(ofKind: Self.gaugeWidgetKind)
        WidgetCenter.shared.reloadTimelines(ofKind: Self.numberWidgetKind)
    }
    
    //CoreDataのentityName
    static let entityName = "DailyData"
}


struct UserDefaultsConstants{
    ///ユーザーデフォルト用キー：目標用
    static let longTermGoalKey = "longTermGoal"
    ///ユーザーデフォルト用キー：取り組むこと用
    static let shortTermGoalKey = "shortTermGoal"
    ///ユーザーデフォルト用キー：初回起動確認用
    static let isFirstKey = "isFirst"
    ///ユーザーデフォルト用キー：アプリカラー選択用
    static let userSelectedColorKey = "userSelectedColorKey"
    ////ユーザーデフォルト用キー：目標隠すか用
    static let hideInfomationKey = "hideInfomation"
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
}


