//
//  CompleteView.swift
//  Challenge100days
//
//  Created by koala panda on 2023/01/29.
//

import SwiftUI
import UIKit


///ユーザーが当日のタスクを達成したときに表示するコンプリートウインドウ
struct CompleteSheet: View {
    ///ViewModel用の変数
    @EnvironmentObject var store: Store
    @EnvironmentObject var coreDataViewModel :CoreDataViewModel
    
    ///メモ追加シート表示用のフラグ
    @State var showMemo = false
    
    ///画面戻る用のフラグ
    @Binding var showCompleteWindew:Bool
    
    ///表示＆共有用の画像
    @State var image: Image?
    
    ///今日が何日目か計算する変数
    let dayNumber: Int
    
    var showAnimation = true
    
    var body: some View {
        
        ZStack{
            //四角に画像とボタンを重ねてる
            VStack(alignment: .center, spacing: 10){
                
                //閉じるボタン
                HStack{
                    Button(action: {
                        showCompleteWindew = false
                    }){
                        CloseButton()
                    }
                    Spacer()
                }
                
                
                //100日達成する前に表示する画像
                if dayNumber <= 99{
                    VStack(alignment: .center, spacing: 30){
                        
                        //読み上げ用のVStack
                        VStack{
                            Text("\(dayNumber)日目のチャレンジ達成！")
                            Text("よく頑張ったね！")
                        }
                        .foregroundColor(.primary)
                        .contentShape(Rectangle())
                        .accessibilityElement(children: .combine)
                        
                        
                        
                        //コンプリート画像
//                        generateImageWithText(number: dayNumber, day: coreDataViewModel.allData.last?.date ?? Date.now)
                        
                        if image == nil{
                            ProgressView()
                                .frame(height: AppSetting.screenHeight * 0.3)
                        }else{
                            image?
                                .resizable().scaledToFit()
                                .accessibilityLabel("日付入りの綺麗な画像")
                                .padding()
                                .frame(height: AppSetting.screenHeight * 0.3)
                        }
                    }.padding(.vertical,30)
                    
                }else{
                    ///100日目達成以降のビュー
                    VStack(alignment: .center, spacing: 0){
                        //Congratulationsのアニメーション
                        LottieView(filename: "cong", loop: .loop)
                            .frame(height: AppSetting.screenHeight * 0.1)
                        
                        //コンプリート画像
                        generateImageWithText(number: dayNumber, day: coreDataViewModel.allData.last?.date ?? Date.now)
                            .resizable().scaledToFit()
                            .accessibilityLabel("日付入りの綺麗な画像")
                            .padding(.horizontal)
                            .frame(height: AppSetting.screenHeight * 0.3)
                        
                        
                        LottieView(filename: "award", loop: .playOnce)
                            .padding(.top, -AppSetting.screenHeight * 0.03)
                    }
                    
                    
                }
                
                //iPadの時はボタンを横並び
                if UIDevice.current.userInterfaceIdiom == .pad{
                    Spacer()
                    HStack(spacing:24){
                        //シェアボタン
                        ShareLink(
                            item: image ?? Image("noImage"),
                            message: Text("#Day\(dayNumber) #100DaysChallenge #100日チャレンジ\n"),
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
                    }
                }else{
                    
                    VStack{
                        //シェアボタン
                        ShareLink(
                            item: image ?? Image("noImage"),
                            message: Text("#Day\(dayNumber) #100DaysChallenge #100日チャレンジ\n"),
                            //message: Text("Day\(dayNumber) of #100DaysChallenge\nhttps://apps.apple.com/app/id6449479183"),
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
                    }
                }
                
                Spacer()
            }
            .background(.thinMaterial)
            .frame(width: AppSetting.screenWidth - 30)
            .cornerRadius(15)
            .padding()
            
           if showAnimation{
                LottieView(filename: "confetti3", loop: .playOnce)
                    .frame(width: AppSetting.screenWidth)
                    .allowsHitTesting(false)
                    .opacity(0.8)
            }
        }
        .onAppear{
            //イメージを作成してセット
            DispatchQueue.main.async {
                if image == nil{
                    image = generateImageWithText(number: dayNumber, day: coreDataViewModel.allData.last?.date ?? Date.now)
                }
            }
        }
        //メモ追加ボタンが押下されたら、MemoSheetを表示
        .sheet(isPresented: $showMemo) {
            MemoSheet()
                .environmentObject(store)
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

