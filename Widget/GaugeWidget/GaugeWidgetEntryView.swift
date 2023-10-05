//
//  GaugeWidgetEntryView.swift
//  ChallengeWidgetExtensionExtension
//
//  Created by koala panda on 2023/10/04.
//

import SwiftUI
import WidgetKit

struct GaugeWidgetEntryView: View {
    let entry: GaugeWidgetEntry
    @Environment(\.widgetFamily) var widgetFamily
    
    var body: some View{
        switch widgetFamily {
        case .systemSmall:
            Gauge(value: Double(entry.items), in: 0...100){
                Text("Days")
            } currentValueLabel: {
                Text("\(entry.items)")
            } minimumValueLabel: {
                Text("0")
            } maximumValueLabel: {
                Text("100")
            }
            .gaugeStyle(.accessoryCircular)
            .scaleEffect(1.8)
            
            
        case .systemMedium:
            VStack{
                Text("\(entry.items)")
                    .font(.largeTitle.bold())
                    .scaleEffect(1.5)
                    .padding(.bottom, 5)
                
                Gauge(value: Double(entry.items), in: 0...100){
                } currentValueLabel: {
                    EmptyView()
                } minimumValueLabel: {
                    Text("0")
                } maximumValueLabel: {
                    Text("100")
                }
                .gaugeStyle(.accessoryLinear)
                .padding([.horizontal, .bottom])
            }
            
            
            
        default:
            Text("We should never reach here.")
        }
    }
}

struct ChallengeEntryView_Previews: PreviewProvider {
    static var previews: some View {
        GaugeWidgetEntryView(entry: GaugeWidgetEntry())
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
