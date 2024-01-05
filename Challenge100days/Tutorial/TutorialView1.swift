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
    @ObservedObject var tutorialVM: TutorialViewModel
    @EnvironmentObject var userDefaultsStore: UserDefaultsStore
    
    var body: some View {

        VStack(alignment: .leading, spacing: 30){
            VStack(alignment: .leading, spacing: 20){
                Text("はじめまして。")
                Text("このアプリは、あなたの目標達成までの道のりを100日間サポートするためのアプリです。")
                Text("まずはアプリ全体の色を選んでください。")
            }
            //VoiceOver用の設定
            .contentShape(Rectangle())
            .accessibilityElement(children: .combine)
            
            ///背景色選択用のピッカー
            Picker(selection: $userDefaultsStore.userInputColor) {
                Text("青").tag(0)
                Text("オレンジ").tag(1)
                Text("紫").tag(2)
                Text("モノトーン").tag(3)
            } label: {
                Text("")
            }
            .pickerStyle(.segmented)
            
            Spacer()
            
            ///進むボタン
            Button {
                tutorialVM.page = 2
                //アプリの色を保存
                userDefaultsStore.saveSettingColor()
            } label: {
                ArrowButton(isBackButton: false, labelText: "次へ")
            }
            .padding(.bottom, 30)
            .frame(maxWidth: .infinity,alignment: .bottomTrailing)
        }
        .padding()
    }
}
