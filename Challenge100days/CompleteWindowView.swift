//
//  CompleteView.swift
//  Challenge100days
//
//  Created by koala panda on 2023/01/29.
//

import SwiftUI
import UIKit


///ユーザーが当日のタスクを達成したときに表示するコンプリートウインドウ
struct CompleteWindowView: View {
    ///ViewModel用の変数
    @EnvironmentObject var userSettingViewModel:UserSettingViewModel
    @EnvironmentObject var coreDataViewModel :CoreDataViewModel
    
    ///メモ追加シート表示用のフラグ
    @State var showMemo = false
    
    ///画面戻る用のフラグ
    @Binding var showCompleteWindew:Bool
    
    ///画面戻る用のフラグ
    @Binding var closed:Bool
    
    ///表示＆共有用の画像
    @State var image: Image?
    
    ///今日が何日目か計算する変数
    let dayNumber: Int
    
    
    var body: some View {
        
        ZStack{
            //四角に画像とボタンを重ねてる
            VStack(alignment: .leading, spacing: 30){
                
                //閉じるボタン
                Button(action: {
                    closed = true
                    showCompleteWindew = false
                }){
                    CloseButton()
                }
                
                if dayNumber == 99{
                    VStack(alignment: .center, spacing: 30){
                        
                        VStack(spacing: 0){
                            
                            //読み上げ用のVStack
                            VStack{
                                Text("\(dayNumber)日目のチャレンジ達成！")
                                Text("よく頑張ったね！")
                            }
                            .foregroundColor(.primary)
                            .contentShape(Rectangle())
                            .accessibilityElement(children: .combine)
                            
                            
                            
                            //コンプリート画像
                            generateImageWithText(number: dayNumber, day: coreDataViewModel.allData.last?.date ?? Date.now)
                                .resizable().scaledToFit()
                                .accessibilityLabel("日付入りの綺麗な画像")
                                .padding()
                            
                        }
                        
                        
                        VStack{
                            //シェアボタン
                            ShareLink(
                                item: image ?? Image("noImage"),
                                message: Text("Day\(dayNumber) of #100DaysChallenge\nhttps://apps.apple.com/app/id6449479183"),
                                preview: SharePreview("Day\(dayNumber) of 100DaysChallenge", image: image ?? Image("noImage"))){
                                    LeftIconBigButton(icon: Image(systemName: "square.and.arrow.up"), text: "シェアする")
                                        .foregroundColor(.blue.opacity(0.9))
                                }
                            
                            //メモ追加ボタン
                            Button {
                                showMemo = true
                            } label: {
                                LeftIconBigButton(icon: Image(systemName: "rectangle.and.pencil.and.ellipsis"), text: "メモを追加")
                                    .foregroundColor(.green.opacity(0.9))
                            }
                        }.padding(.bottom, 30)
                        
                    }
                }else{
                    
                    
                    //100日目の画像
                    VStack(alignment: .center, spacing: 0){
                        
                        LottieView(filename: "cong", loop: .loop)
                            .frame(height:50)
                            .padding(.top,-30)
                        
                        //コンプリート画像
                        generateImageWithText(number: dayNumber, day: coreDataViewModel.allData.last?.date ?? Date.now)
                            .resizable().scaledToFit()
                            .accessibilityLabel("日付入りの綺麗な画像")
                            .padding(.horizontal)
//                            .padding(.bottom, -50)
                        
                        
                        LottieView(filename: "award", loop: .playOnce)
                            .frame(height: 230)
//                            .padding(.bottom, -10)
                            .padding(.top, -50)
                        
                        VStack(spacing: 10){
                            //シェアボタン
                            ShareLink(
                                item: image ?? Image("noImage"),
                                message: Text("Day\(dayNumber) of #100daysChallenge\nhttps://apps.apple.com/app/id6449479183"),
                                preview: SharePreview("Day\(dayNumber) of 100daysChallenge", image: image ?? Image("noImage"))){
                                    LeftIconBigButton(icon: Image(systemName: "square.and.arrow.up"), text: "シェアする")
                                        .foregroundColor(.blue.opacity(0.9))
                                }
                            
                            //メモ追加ボタン
                            Button {
                                showMemo = true
                            } label: {
                                LeftIconBigButton(icon: Image(systemName: "rectangle.and.pencil.and.ellipsis"), text: "メモを追加")
                                    .foregroundColor(.green.opacity(0.9))
                            }
                        }
                        .padding(.bottom)
                        
                    }
                    
                    
                }
                
            }
            .background(.thinMaterial)
            .cornerRadius(15)
            .padding()
            
            
            LottieView(filename: "confetti3", loop: .playOnce)
                .frame(width: AppSetting.screenWidth)
                .allowsHitTesting(false)
                .opacity(0.8)
        }
        .onAppear{
            image = generateImageWithText(number: dayNumber, day: coreDataViewModel.allData.last?.date ?? Date.now)
        }
        .onDisappear{
            showCompleteWindew = false
        }
        
        
        
        //メモ追加ボタンが押下されたら、MemoSheetを表示
        .sheet(isPresented: $showMemo) {
            MemoSheet()
                .environmentObject(userSettingViewModel)
        }
    }
}



//struct CompleteDoneView_Previews: PreviewProvider {
//    @State static var aa = false
//    static var previews: some View {
//        Group{
//            CompleteWindowView(showCompleteWindew: $aa, image: Image("noImage"), dayNumber: 1)
//                .environment(\.locale, Locale(identifier:"en"))
//            CompleteWindowView(showCompleteWindew: $aa, image: Image("noImage"), dayNumber: 1)
//                .environment(\.locale, Locale(identifier:"ja"))
//        }.environmentObject(CoreDataViewModel())
//    }
//}
