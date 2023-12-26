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
