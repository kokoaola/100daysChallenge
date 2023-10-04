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
            ChallengeEntryView(entry: entry)
        }
        .supportedFamilies([.systemSmall,.systemMedium,.systemLarge])
        .configurationDisplayName("Grocery Widget")
        .description("Gold old grodery app widget.")
    }
}
