//
//  ChallengeEntryView.swift
//  ChallengeWidgetExtensionExtension
//
//  Created by koala panda on 2023/10/04.
//

import SwiftUI
import WidgetKit

struct ChallengeEntryView: View {
    let entry: ChallengeEntry
    
    var body: some View{
        VStack(alignment: .leading,spacing: 0) {
            HStack{
                Image(systemName: "list.bullet.circle.fill")
                    .foregroundColor(.orange)
                Text("\(entry.items.count)")
                    .font(.title2)
            }
            
            Rectangle()
                .foregroundStyle(.orange.gradient.opacity(0.4))
                .frame(height: 1)
            
            VStack(alignment: .leading) {
                ForEach(entry.items){item in
                    HStack{
                        Text("\(entry.items.count)")
                            .lineLimit(1)
                    }
                    .font(.subheadline)
                }
            }
            .padding(.top,5)
            Spacer(minLength: 0)
        }
        .padding()
    }
}

struct ChallengeEntryView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeEntryView(entry: ChallengeEntry())
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
