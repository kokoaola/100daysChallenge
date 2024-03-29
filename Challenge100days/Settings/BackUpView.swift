//
//  BackUpView.swift
//  Challenge100days
//
//  Created by koala panda on 2023/02/17.
//

import SwiftUI
import Combine


///バックアップデータ保存用のビュー
struct BackUpView: View {
    ///ViewModel用の変数
    @EnvironmentObject var globalStore: CoreDataStore
    
    ///キーボードフォーカス用変数（Doneボタン表示のため）
    @FocusState var isInputActive: Bool
    
    ///編集文章格納用変数
    @State private var string = ""
    
    ///ポップアップ表示フラグ格納用変数
    @State private var showToast = false
    
    
    var body: some View {
        ZStack {
            
            VStack(alignment: .leading){
                //説明文
                Text("このアプリにはデータを外部に保存する機能はありません。\nデータを消して最初から新しく始める際など、これまでの記録を残しておきたい場合は、このページからコピーしてデバイスへ保存をお願いいたします。")
                    .foregroundColor(.primary)
                    .padding([.horizontal, .top])
                
                //テキストエディター
                TextEditor(text: $string)
                    .foregroundColor(Color(UIColor.label))
                    .scrollContentBackground(Visibility.hidden)
                    .background(.ultraThinMaterial)
                    .border(.white, width: 1)
                    .focused($isInputActive)
                    .padding()
            }
            .frame(minHeight: AppSetting.screenHeight/1.6)
            
            ToastView(show: $showToast, text: "コピーしました")
            
        }
        .navigationTitle(Text("バックアップ"))
        .toolbarBackground(.visible, for: .navigationBar)
        
        //背景グラデーション設定
        .modifier(UserSettingGradient())
        
        //キーボード閉じるボタン
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("閉じる") {
                    isInputActive = false
                }
            }
            
            
            //コピーボタン
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: {
                    UIPasteboard.general.string = string
                    showToast = true
                }, label: {
                    Image(systemName: "doc.on.doc")
                        .foregroundColor(.primary)
                        .frame(width: 65)
                })
                .accessibilityLabel(showToast ? "コピーしました" : "コピー")
                
            }
        }
        
        //データが1つ以上格納されていればテキストエディターの初期値に設定
        .onAppear{
            for item in globalStore.allData{
                string = string + "\n" + "Day" + String(item.num) + "  " +  AppSetting.makeDate(day: item.wrappedDate) + "\n" + (item.wrappedMemo) + "\n"
            }
        }
    }
}




struct BackUpView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            BackUpView()
                .environment(\.locale, Locale(identifier:"en"))
            BackUpView()
                .environment(\.locale, Locale(identifier:"ja"))
        }
    }
}
