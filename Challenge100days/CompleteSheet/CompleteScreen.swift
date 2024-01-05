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
    @EnvironmentObject var coreDataStore: CoreDataStore
    
    ///メモ追加シート表示用のフラグ
    @State var showMemo = false
    ///画面戻る用のフラグ
    @Binding var showCompleteWindew: Bool
    ///表示＆共有用の画像
    @Binding var image: Image?
    ///アニメーション表示フラグ
    var showAnimation: Bool
    
    var body: some View {
        //使いやすいように格納
        let dayNumber = coreDataStore.dayNumber
        
        
        ZStack{
            VStack(alignment: .center, spacing: 10){
                ///左上の閉じるボタン
                HStack{
                    Button(action: { showCompleteWindew = false }, label: { CloseButton() })
                    Spacer()
                }
                
                ///1〜99日目に表示するビュー
                if dayNumber <= 99{
                    VStack(alignment: .center, spacing: 30){
                        VStack{ //VoiceOver用のVStack
                            Text("\(dayNumber)日目のチャレンジ達成！")
                            Text("よく頑張ったね！")
                        }
                        .foregroundColor(.primary)
                        .contentShape(Rectangle())
                        .accessibilityElement(children: .combine)
                        //コンプリート画像
                        CompleteImageView(image: $image)
                    }
                    .padding(.vertical,30)
                    
                
                ///100日目達成以降のビュー
                }else{
                    VStack(alignment: .center, spacing: 0){
                        //アニメーション
                        LottieView(filename: "cong", loop: .loop)
                            .frame(height: AppSetting.screenHeight * 0.1)
                        //コンプリート画像
                        CompleteImageView(image: $image)
                        //アニメーション
                        LottieView(filename: "award", loop: .playOnce)
                            .padding(.top, -AppSetting.screenHeight * 0.03)
                    }
                }
                
                ///iPadの時はボタンを横並び
                if UIDevice.current.userInterfaceIdiom == .pad{
                    Spacer()
                    HStack(spacing:24){
                        //シェアボタン
                        ShareLinkView(image: image, dayNumber: dayNumber)
                        
                        //メモ追加ボタン
                        Button {
                            showMemo = true
                        } label: {
                            LeftIconBigButton(color: .green, icon: Image(systemName: "rectangle.and.pencil.and.ellipsis"), text: "メモを追加")
                        }
                    }
                }else{
                    ///iPhoneの時はボタンを縦並び
                    VStack{
                        ///シェアボタン
                        ShareLinkView(image: image, dayNumber: dayNumber)
                        ///メモ追加ボタン
                        Button {
                            showMemo = true
                        } label: {
                            LeftIconBigButton(color: .green, icon: Image(systemName: "rectangle.and.pencil.and.ellipsis"), text: "メモを追加")
                        }
                    }
                }
                Spacer()
            }
            .background(.thinMaterial)
            .frame(width: AppSetting.screenWidth - 30)
            .cornerRadius(15)
            .padding()
            
            
            ///シートの上に重ねる紙吹雪のアニメーション
            if showAnimation{
                ConfettiView()
            }
        }
        //メモ追加ボタンが押下されたら、MemoSheetを表示
        .sheet(isPresented: $showMemo) {
            MemoSheet()
                .environmentObject(coreDataStore)
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

