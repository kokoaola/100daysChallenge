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
    @State var isSelectAll: Bool = false
    
    var body: some View {

            VStack{
                // 1から4個目の曜日
                HStack {
                        ForEach(Weekday.allCases.prefix(5), id: \.self) { weekday in
                            Text(weekday.localizedName)
                                .onTapGesture {
                                    selectedDay[weekday]?.toggle()
                                    //すべてがfalseか確認
                                    checkFormValid()
                                }
                                .padding(5)
                                .foregroundColor(.white)
                                .frame(width: AppSetting.screenWidth / 8)
                                .background(selectedDay[weekday] ?? false ? .blue : .gray.opacity(0.4))
                                .cornerRadius(10)
                                .padding(3)
                                .contentShape(Rectangle())
                                .editAccessibility(label: weekday.localizedName,addTraits: .isButton)
                        }
                    }
                
                // 2から7個目の曜日
                HStack {
                    ForEach(Weekday.allCases.suffix(2), id: \.self) { weekday in
                        Text(weekday.localizedName)
                            .onTapGesture {
                                selectedDay[weekday]?.toggle()
                                //すべてがfalseか確認
                                checkFormValid()
                            }
                            .padding(5)
                            .foregroundColor(.white)
                            .frame(width: AppSetting.screenWidth / 8)
                            .background(selectedDay[weekday] ?? false ? .blue : .gray.opacity(0.4))
                            .cornerRadius(10)
                            .padding(3)
                            .contentShape(Rectangle())
                            .editAccessibility(label: weekday.localizedName,addTraits: .isButton)
                    }
                    
                    if isSelectAll{
                        Text("すべて解除")
                            .onTapGesture {
                                for item in Weekday.allCases{
                                    selectedDay[item]? = false
                                }
                                isSelectAll = false //すべて選択ボタンに変更
                            }
                            .foregroundColor(.blue)
                            .padding(.leading)
                            .accessibilityAddTraits(.isButton)
                    }else{
                        Text("すべて選択")
                            .onTapGesture {
                                for item in Weekday.allCases{
                                    selectedDay[item]? = true
                                }
                                isSelectAll = true //すべて解除ボタンに変更
                            }
                            .foregroundColor(.blue)
                            .padding(.leading)
                            .accessibilityAddTraits(.isButton)
                    }
                }
            }
        
            .onAppear{
                checkFormValid()
            }
        }
        
        
        func checkFormValid() {
            //すべてがfalseの時はisFormValidを無効にする
            let noneSelected = Weekday.allCases.allSatisfy { weekday in
                !(selectedDay[weekday] ?? false)
            }
            if noneSelected {
                isFormValid = false
            }else{
                isFormValid = true
            }
            
            // 全てがtrueの時はisSelectAllをtrueにする
            let allSelected = Weekday.allCases.allSatisfy { weekday in
                selectedDay[weekday] ?? false
            }
            if allSelected {
                isSelectAll = true
            }else{
                isSelectAll = false
            }
        }
    }
