//
//  NumberWidgetEntry.swift
//  ChallengeWidgetExtensionExtension
//
//  Created by koala panda on 2023/10/05.
//

import SwiftUI
import WidgetKit

// Widgetで表示させたいデータの構造体を定義
struct NumberWidgetEntry: TimelineEntry{
    // TimelineEntryが必要とするdateプロパティを持つ、これはエントリが表す日時
    let date = Date()
    // Itemオブジェクトの配列を持つ、これがGroceryのアイテム
    var items = 0
}
