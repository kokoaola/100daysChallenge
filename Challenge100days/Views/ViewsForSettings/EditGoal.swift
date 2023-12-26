//
//  SwiftUIView.swift
//  Challenge100days
//
//  Created by koala panda on 2023/02/17.
//

import SwiftUI

struct EditGoal: View {
    ///ViewModel用の変数
    @EnvironmentObject var userSettingViewModel:Store
    @EnvironmentObject var notificationViewModel: NotificationViewModel
    
    ///自分自身の表示状態を格納するフラグ
    @Binding var showAlert: Bool
    
    ///SettingViewでトーストポップアップを表示させるフラグ
    @Binding var showToast: Bool
    
    ///トースト内に表示する文章を格納する変数
    @Binding var toastText: String
    
    ///入力したテキストを格納する変数
    @State var editText: String = ""
    
    ///変更する目標が長期目標か短期目標かの変数
    let isLong: Bool
    
    
    var body: some View {
        
        VStack(alignment: .leading){
            
            //見出しの文言
            Text(isLong ? "目標を変更する" : "100日取り組む内容を変更する")
                .frame(maxWidth: .infinity, alignment: .center)
                .font(.title3)
            
            //テキストエディタ
            TextEditor(text: $editText)
                .foregroundColor(Color(UIColor.black))
                .tint(.black)
                .scrollContentBackground(Visibility.hidden)
                .background(.gray.opacity(0.5))
                .border(.gray, width: 1)
                .frame(height: 80)
                .opacity(editText.isEmpty ? 0.5 : 1)
                .accessibilityLabel("目標変更用のテキストフィールド")
            
            //文字数オーバー時の警告
            Text("\(AppSetting.maxLengthOfTerm)文字以内のみ設定可能です").font(.caption) .font(.caption)
                .foregroundColor(editText.count > AppSetting.maxLengthOfTerm ? .red : .clear)
            
            
            HStack{
                //キャンセルボタン
                Button {
                    showAlert = false
                } label: {
                    Text("キャンセル")
                        .frame(width: AppSetting.screenWidth / 3.5, height: AppSetting.screenWidth * 0.1)
                }
                .tint(.red)
                
                Spacer()
                
                //保存ボタン
                Button {
                    if !editText.isEmpty && AppSetting.maxLengthOfTerm >= editText.count{
                        if isLong{
                            userSettingViewModel.longTermGoal = editText
                        }else{
                            userSettingViewModel.shortTermGoal = editText
                        }
                    }
                    toastText = "目標を変更しました"
                    showAlert = false
                    showToast = true
                } label: {
                    Text("変更する")
                        .frame(width: AppSetting.screenWidth / 3.5, height: AppSetting.screenWidth * 0.1)
                }.tint(.green)
                    .disabled(editText.isEmpty || editText.count > AppSetting.maxLengthOfTerm)
            }//HStackここまで
            .foregroundColor(.white)
            .buttonStyle(.borderedProminent)
            .padding(.bottom)
            
        }//VStackここまで
        
        .foregroundColor(.black)
        .padding()
        .background(.white)
        .cornerRadius(15)
        .padding()
        
        //ページ表示時に初期値として現在の目標をテキストエディターに入力
        .onAppear{
            if isLong{
                editText = userSettingViewModel.longTermGoal
            }else{
                editText = userSettingViewModel.shortTermGoal
            }
        }
    }
    
}




struct EditGoal_Previews: PreviewProvider {
    @State static var isEdit = false
    @State static var showToast = false
    @State static var toastText = "目標を変更しました"
    static var previews: some View {
        Group{
            EditGoal(showAlert: $isEdit,showToast: $showToast,toastText: $toastText, isLong: true)
                .environment(\.locale, Locale(identifier:"en"))
            EditGoal(showAlert: $isEdit,showToast: $showToast,toastText: $toastText, isLong: true)
                .environment(\.locale, Locale(identifier:"ja"))
        }
        .environmentObject(Store())
        .environmentObject(NotificationViewModel())
    }
}
