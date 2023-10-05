//
//  GaugeWidgetEntry.swift
//  ChallengeWidgetExtensionExtension
//
//  Created by koala panda on 2023/09/28.
//

import SwiftUI
import WidgetKit

// Widgetで表示させたいデータの構造体を定義
struct GaugeWidgetEntry: TimelineEntry{
    // TimelineEntryが必要とするdateプロパティを持つ、これはエントリが表す日時
    let date = Date()
    // Itemオブジェクトの配列を持つ、これがGroceryのアイテム
    var items = 0
}
