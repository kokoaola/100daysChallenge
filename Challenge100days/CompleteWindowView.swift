//
//  CompleteView.swift
//  Challenge100days
//
//  Created by koala panda on 2023/01/29.
//

import SwiftUI
import UIKit

struct CompleteWindowView: View {
    
    @EnvironmentObject var coreDataViewModel :CoreDataViewModel
    
    ///CoreData用の変数
//    @Environment(\.managedObjectContext) var moc
//    @FetchRequest(sortDescriptors: [NSSortDescriptor(key:"date", ascending: true)]) var days: FetchedResults<DailyData>
    
    ///メモ追加シート表示用のフラグ
    @State var showMemo = false
    ///画面戻る用のフラグ
    @Binding var showCompleteWindew:Bool
    ///実績取り消し押下後の確認アラート用のフラグ
    @State var showCansel = false
    
    ///表示＆共有用の画像
    @State var image: Image?
    
    var dayNumber: Int{
        coreDataViewModel.allData.isEmpty ? 1 : coreDataViewModel.allData.count
    }
    
    var body: some View {
        
        ///四角に画像とボタンを重ねてる
        VStack(alignment: .leading, spacing: 20){
            
            ///閉じるボタン
            Button(action: {
                showCompleteWindew = false
            }){
                CloseButton()
            }
            
            
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
                generateImageWithText(number: dayNumber, day: coreDataViewModel.allData.last?.date ?? Date.now)
                    .resizable().scaledToFit()
                // MARK: -
                    .accessibilityLabel("日付入りの画像")
//                    .accessibilityRemoveTraits(.isImage)
//                    .accessibilityAddTraits(.isImage)
                
                
                VStack{
                    ///シェアボタン
                    ShareLink(item: image ?? Image("noImage") , preview: SharePreview("画像", image:image ?? Image("noImage"))){
                        ShareButton()
                            .foregroundColor(.blue.opacity(0.9))
                    }
                    
                    ///メモ追加ボタン
                    Button {
                        showMemo = true
                    } label: {
                        MemoButton()
                            .foregroundColor(.green.opacity(0.9))
                    }
                    
                }.padding(30)
            }
            
        }
        .padding()
        .background(.thinMaterial)
        .cornerRadius(15)
        
        
        
        ///画面表示時にコンプリート画像を生成して表示
//        .onAppear{
//            image =  generateImageWithText(number: dayNumber, day: coreDataViewModel.allData.last?.date ?? Date.now)
//        }
        
        ///メモ追加編集用のビュー
        .sheet(isPresented: $showMemo) {
            MemoSheet()
        }
    }
}



struct CompleteDoneView_Previews: PreviewProvider {
//    @Environment(\.managedObjectContext) var moc
    @State static var aa = false
    static var previews: some View {
        Group{
            CompleteWindowView(showCompleteWindew: $aa, image: Image("noImage"))
                .environment(\.locale, Locale(identifier:"en"))
            CompleteWindowView(showCompleteWindew: $aa, image: Image("noImage"))
                .environment(\.locale, Locale(identifier:"ja"))
        }.environmentObject(CoreDataViewModel())
    }
}
