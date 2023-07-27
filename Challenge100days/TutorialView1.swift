//
//  TutorialView.swift
//  Challenge100days
//
//  Created by koala panda on 2023/02/14.
//

import SwiftUI


///チュートリアル１ページ目
struct TutorialView1: View {
    
    ///ViewModel用の変数
    @EnvironmentObject var userSettingViewModel:UserSettingViewModel
    
    ///カラー設定ピッカー用の変数
    @State var selectedColor = 0
    
    ///表示中のページ番号を格納
    @Binding var page: Int
    
    
    var body: some View {

        VStack(alignment: .leading, spacing: 50){

            Text("はじめまして。")
            Text("このアプリは、あなたの目標達成までの道のりを100日間サポートするためのアプリです。")
            Text("まずはアプリ全体の色を選んでください。")
            
            //背景色選択用のピッカー
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
            
            //進むボタン
            Button {
                page = 2
                userSettingViewModel.saveUserSettingAppColor(colorNum: selectedColor)
            } label: {
                ArrowButton(isBackButton: false, labelText: "次へ")
            }
            .padding(.bottom, 30)
            .frame(maxWidth: .infinity,alignment: .bottomTrailing)
        }
        .padding()
        
        
        //ピッカーが選択される毎に背景色を変更
        .onChange(of: selectedColor) { newValue in
            userSettingViewModel.userSelectedColor = newValue
            userSettingViewModel.saveUserSettingAppColor(colorNum: newValue)
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
