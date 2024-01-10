//
//  NotificationComponent.swift
//  Challenge100days
//
//  Created by koala panda on 2024/01/03.
//

import SwiftUI

struct DaysButtonView: View {
    @EnvironmentObject var notificationViewModel :NotificationViewModel
//    @Binding var selectedDay: [Weekday: Bool]
//    @Binding var isFormValid: Bool
    @State private var isSelectAll: Bool = false
    
    var body: some View {

            VStack{
                // 1から4個目の曜日
                HStack {
                        ForEach(Weekday.allCases.prefix(5), id: \.self) { weekday in
                            Text(weekday.localizedName)
                                .onTapGesture {
                                    //曜日に対応するキーを反転
                                    notificationViewModel.userInputDays[weekday]?.toggle()
                                    //すべてがfalseか確認
                                    checkFormValid()
                                }
                                .padding(5)
                                .foregroundColor(.white)
                                .frame(width: AppSetting.screenWidth / 8)
                                .background(notificationViewModel.userInputDays[weekday] ?? false ? .blue : .gray.opacity(0.4))
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
                                //曜日に対応するキーを反転
                                notificationViewModel.userInputDays[weekday]?.toggle()
                                //すべてがfalseか確認
                                checkFormValid()
                            }
                            .padding(5)
                            .foregroundColor(.white)
                            .frame(width: AppSetting.screenWidth / 8)
                            .background(notificationViewModel.userInputDays[weekday] ?? false ? .blue : .gray.opacity(0.4))
                            .cornerRadius(10)
                            .padding(3)
                            .contentShape(Rectangle())
                            .editAccessibility(label: weekday.localizedName,addTraits: .isButton)
                    }
                    
                    if isSelectAll{
                        Text("すべて解除")
                            .onTapGesture {
                                for item in Weekday.allCases{
                                    //すべての項目をfalseにする
                                    notificationViewModel.userInputDays[item]? = false
                                }
                                notificationViewModel.isSelectedDaysValid = false
                                isSelectAll = false //すべて選択ボタンに変更
                            }
                            .foregroundColor(.blue)
                            .padding(.leading)
                            .accessibilityAddTraits(.isButton)
                    }else{
                        Text("すべて選択")
                            .onTapGesture {
                                for item in Weekday.allCases{
                                    //すべての項目をtrueにする
                                    notificationViewModel.userInputDays[item]? = true
                                }
                                notificationViewModel.isSelectedDaysValid = true
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
                !(notificationViewModel.userInputDays[weekday] ?? false)
            }
            if noneSelected {
                notificationViewModel.isSelectedDaysValid = false
            }else{
                notificationViewModel.isSelectedDaysValid = true
            }
            
            // 全てがtrueの時はisSelectAllをtrueにする
            let allSelected = Weekday.allCases.allSatisfy { weekday in
                notificationViewModel.userInputDays[weekday] ?? false
            }
            if allSelected {
                isSelectAll = true
            }else{
                isSelectAll = false
            }
        }
    }
