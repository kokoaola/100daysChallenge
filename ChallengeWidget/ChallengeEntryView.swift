//
//  ChallengeEntryView.swift
//  ChallengeWidgetExtensionExtension
//
//  Created by koala panda on 2023/10/04.
//

import SwiftUI
import WidgetKit

struct ChallengeEntryView1: View {
    let entry: ChallengeEntry
    @Environment(\.widgetFamily) var widgetFamily
    
    var body: some View{
        switch widgetFamily {
        case .systemSmall:
            Gauge(value: Double(entry.items.count), in: 0...100){
                Text("Days")
            } currentValueLabel: {
                Text("\(entry.items.count)")
            } minimumValueLabel: {
                Text("0")
            } maximumValueLabel: {
                Text("100")
            }
            .gaugeStyle(.accessoryCircular)
            .scaleEffect(1.8)
            
        case .systemMedium:
            Gauge(value: Double(entry.items.count), in: 0...100){
                Text("\(entry.items.count)")
                    .font(.largeTitle.bold())
                    .scaleEffect(1.5)
                    .padding(.vertical, 5)
            } currentValueLabel: {
                EmptyView()
            } minimumValueLabel: {
                Text("0")
            } maximumValueLabel: {
                Text("100")
            }
            .tint(LinearGradient(gradient: Gradient(colors: [Color.green, Color.yellow, Color.orange, Color.red, Color.purple]), startPoint: .leading, endPoint: .trailing))
            .gaugeStyle(.linearCapacity)
            .padding([.horizontal, .bottom])
        
            
            
        default:
            Text("We should never reach here.")
        }
    }
}

struct ChallengeEntryView1_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeEntryView1(entry: ChallengeEntry())
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
