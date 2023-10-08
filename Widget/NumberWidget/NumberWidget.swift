//
//  NumberWidget.swift
//  ChallengeWidgetExtensionExtension
//
//  Created by koala panda on 2023/10/05.
//

import WidgetKit
import SwiftUI

struct NumberWidget: Widget{
    var body: some WidgetConfiguration{
        
        StaticConfiguration(kind: ChallengeConstants.numberWidgetKind, provider: NumberWidgetTimelineProvider()) { entry in
            NumberWidgetEntryView(entry: entry)
        }
        .supportedFamilies([.systemSmall,.systemMedium])
        .configurationDisplayName("100日チャレンジ")
        .description("現在何日まで達成中かを表示するウィジェット")
    }
}
