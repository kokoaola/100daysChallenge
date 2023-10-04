//
//  ChallengeWidget.swift
//  ChallengeWidgetExtensionExtension
//
//  Created by koala panda on 2023/10/04.
//

import Foundation


import WidgetKit
import SwiftUI

struct ChallengeWidget: Widget{
    var body: some WidgetConfiguration{
        
        StaticConfiguration(kind: ChallengeConstants.widgetKind, provider: ChallengeTimelineProvider()) { entry in
            ChallengeEntryView1(entry: entry)
        }
        .supportedFamilies([.systemSmall,.systemMedium])
        .configurationDisplayName("100日チャレンジ")
        .description("現在何日まで達成中かを表示するウィジェット")
    }
}
