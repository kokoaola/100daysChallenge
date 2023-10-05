//
//  GaugeWidget.swift
//  ChallengeWidgetExtensionExtension
//
//  Created by koala panda on 2023/10/04.
//

import Foundation
import WidgetKit
import SwiftUI

struct GaugeWidget: Widget{
    var body: some WidgetConfiguration{
        
        StaticConfiguration(kind: ChallengeConstants.gaugeWidgetKind, provider: GaugeWidgetEntryTimelineProvider()) { entry in
            GaugeWidgetEntryView(entry: entry)
        }
        .supportedFamilies([.systemSmall,.systemMedium])
        .configurationDisplayName("100日チャレンジ")
        .description("現在何日まで達成中かを表示するウィジェット")
    }
}
