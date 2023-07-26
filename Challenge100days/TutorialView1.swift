//
//  TutorialView.swift
//  Challenge100days
//
//  Created by koala panda on 2023/02/14.
//

import SwiftUI

struct TutorialView1: View {
    ///ViewModel用の変数
    @EnvironmentObject var userSettingViewModel:UserSettingViewModel
    
    ///ページ全体のカラー情報を格納
//    @AppStorage("colorkeyTop") var storedColorTop: Color = .blue
//    @AppStorage("colorkeyBottom") var storedColorBottom: Color = .green
//
//    ///カラー設定ピッカー用の変数
//    @AppStorage("colorNumber") var colorNumber = 0
    
    ///カラー設定ピッカー用の変数
    @State var selectedColor = 0
    
    ///表示中のページ番号を格納
    @Binding var page: Int
    
    
    var body: some View {

        VStack(alignment: .leading){

            Text("はじめまして。")
                .padding(.bottom, 50)
            Text("このアプリは、あなたの目標達成までの道のりを\n100日間サポートするためのアプリです。")
                .padding(.bottom, 50)
            
            Text("まずはアプリ全体の色を選んでください。")
                .padding(.bottom, 20)
            
            Picker(selection: $selectedColor) {
                Text("青").tag(0)
                Text("オレンジ").tag(1)
                Text("紫").tag(2)
                Text("モノトーン").tag(3)
            } label: {
                Text("")
            }
            .pickerStyle(.segmented)
            

            Spacer()
            
//            進むボタン
            Button {
                page = 2
                userSettingViewModel.saveUserSettingAppColor(colorNum: selectedColor)
//                colorNumber = selectedColor
            } label: {
                NextButton(isStart: false)
            }
            .padding(.bottom, 30)
            .frame(maxWidth: .infinity,alignment: .bottomTrailing)
        }
        .padding()
        .foregroundColor(.primary)
        
//        .onAppear{
//            selectedColor = colorNumber
//        }
        
        .onChange(of: selectedColor) { newValue in
            userSettingViewModel.userSelectedColor = newValue
//            switch newValue{
//            case 0:
//                storedColorTop = .blue
//                storedColorBottom = .green
//            case 1:
//                storedColorTop = .green
//                storedColorBottom = .yellow
//            case 2:
//                storedColorTop = .purple
//                storedColorBottom = .blue
//            case 3:
//                storedColorTop = .black
//                storedColorBottom = .black
//            default:
//                return
//            }
        }
        
    }
}


struct TutorialView1_Previews: PreviewProvider {
    @State static var sampleNum = 1
    static var previews: some View {
        Group{
            TutorialView1(page: $sampleNum)
                .environment(\.locale, Locale(identifier:"ja"))
            TutorialView1(page: $sampleNum)
                .environment(\.locale, Locale(identifier:"en"))
        }
        .environmentObject(UserSettingViewModel())
    }
}
