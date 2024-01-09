//
//  SwiftUIView.swift
//  Challenge100days
//
//  Created by koala panda on 2024/01/06.
//

import SwiftUI


struct DetailHeaderView: View {
    let num: Int
    let date: Date
    
    var body: some View {
        HStack{
            Text("\(num ) / 100")
                .font(.title)
            
            Spacer()
            
            Text(AppSetting.makeDate(day: date))
                .font(.title3.weight(.ultraLight))
                .padding(.leading, 40)
        }
        .accessibilityElement()
        .accessibilityLabel("\(num)日目の記録、\(AppSetting.makeAccessibilityDate(day: date))")
        .foregroundColor(.primary)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}




struct backButtonView: View {
    var body: some View {
        HStack{
            Image(systemName: "chevron.backward")
            Text("戻る")
        }
    }
}

struct trashButtonView: View {
    var body: some View {
        Image(systemName: "trash")
            .foregroundColor(.red)
            .padding(.trailing)
    }
}
