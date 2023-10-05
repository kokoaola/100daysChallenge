//
//  NumberWidgetEntryView.swift
//  ChallengeWidgetExtensionExtension
//
//  Created by koala panda on 2023/10/05.
//

import SwiftUI
import WidgetKit

struct NumberWidgetEntryView: View {
        let entry: NumberWidgetEntry
        @Environment(\.widgetFamily) var widgetFamily
        
        var body: some View{
            switch widgetFamily {
            case .systemSmall:
                    HStack(spacing:-2){
                        Text(String(format: "%03d", entry.items))
                            .monospacedDigit()
                            .font(.title)
                            .fontWeight(.heavy)
                            .scaleEffect(1.3)
                            .offset(y: -30)
                        
                        Text("/")
                            .font(.largeTitle)
                            .scaleEffect(3.5)
                            .rotationEffect(Angle(degrees: 25))
                            .fontWeight(.ultraLight)
                            .offset(x:5, y: -10)
                        
                        
                        Text("100")
                            .font(.title)
                            .fontWeight(.heavy)
                            .scaleEffect(1.3)
                            .offset(y: 30)
                    }
                
            case .systemMedium:
                Gauge(value: Double(entry.items), in: 0...100){
                    Text("\(entry.items)")
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


struct NumberWidgetEntryView_Previews: PreviewProvider {
    static var previews: some View {
        NumberWidgetEntryView(entry: NumberWidgetEntry())
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
