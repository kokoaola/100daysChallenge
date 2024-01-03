//
//  NotificationComponent.swift
//  Challenge100days
//
//  Created by koala panda on 2024/01/03.
//

import SwiftUI

struct DaysButtonView: View {
    @Binding var selectedDay: [Weekday: Bool]
    @Binding var isFormValid: Bool
    
    var body: some View {
        VStack{
            // 1から4個目の曜日
            HStack {
                ForEach(Weekday.allCases.prefix(5), id: \.self) { weekday in
                    Text(weekday.name)
                        .onTapGesture {
                            selectedDay[weekday]?.toggle()
                            //すべてがfalseか確認
                            checkFormValid()
                        }
                        .padding(8)
                        .foregroundColor(.white)
                        .background(selectedDay[weekday] ?? false ? .blue : .gray.opacity(0.4))
                        .cornerRadius(20)
                }
            }
            
            // 2から7個目の曜日
            HStack {
                ForEach(Weekday.allCases.suffix(2), id: \.self) { weekday in
                    Text(weekday.name)
                        .onTapGesture {
                            selectedDay[weekday]?.toggle()
                            //すべてがfalseか確認
                            checkFormValid()
                        }
                        .padding(8)
                        .foregroundColor(.white)
                        .background(selectedDay[weekday] ?? false ? .blue : .gray.opacity(0.4))
                        .cornerRadius(20)
                }
                Text("すべて選択")
                    .onTapGesture {
                        for item in Weekday.allCases{
                            selectedDay[item]? = true
                        }
                    }
                    .foregroundColor(.blue)
                    .padding(.leading)
            }
        }
    }
    func checkFormValid() {
        //すべてがfalseか確認
        let noneSelected = Weekday.allCases.allSatisfy { weekday in
            !(selectedDay[weekday] ?? false)
        }
        if noneSelected {
            isFormValid = false
        }else{
            isFormValid = true
        }
    }
}
