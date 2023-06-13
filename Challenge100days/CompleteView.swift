//
//  CompleteView.swift
//  Challenge100days
//
//  Created by koala panda on 2023/01/29.
//

import SwiftUI
import UIKit

struct CompleteView: View {
    ///CoreData用の変数
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key:"date", ascending: true)]) var days: FetchedResults<DailyData>
    
    ///メモ追加シート表示用のフラグ
    @State var showMemo = false
    ///画面戻る用のフラグ
    @Binding var showCompleteWindew:Bool
    ///実績取り消し押下後の確認アラート用のフラグ
    @State var showCansel = false
    
    ///表示＆共有用の画像
    @State var image: Image?
    
    var dayNumber: Int{
        days.isEmpty ? 1 : days.count
    }
    
    var body: some View {
        
       // VStack{
            
            ///四角に画像とボタンを重ねてる
        VStack(spacing: 60){
                
            VStack{
                ///閉じるボタン
                Button(action: {
                    showCompleteWindew = false
                }){
                    Image(systemName: "xmark")
                        .font(.title3).foregroundColor(.primary)
                }.frame(maxWidth: .infinity,minHeight: 30, alignment: .topLeading)
                    .padding(.vertical)
                
                
                    Text("\(dayNumber)日目のチャレンジ達成！")
                    Text("よく頑張ったね！")
                    ///コンプリート画像
                    image?
                        .resizable().scaledToFit()
                }
                .foregroundColor(Color(UIColor.label))
                
                
                

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
                }
                .padding(.bottom)
                
            }
            .padding()
            .background(.thinMaterial)
            .cornerRadius(15)
            
        
        
        ///画面表示時にコンプリート画像を生成して表示
        .onAppear{
            image =  generateImageWithText(number: dayNumber, day: days.last?.date ?? Date.now)
        }
        
        ///メモ追加編集用のビュー
        .sheet(isPresented: $showMemo) {
            MemoSheet()
        }
    }
}



struct CompleteDoneView_Previews: PreviewProvider {
    @Environment(\.managedObjectContext) var moc
    @State static var aa = false
    static var previews: some View {
        Group{
            CompleteView(showCompleteWindew: $aa, image: Image("noImage"))
                .environment(\.locale, Locale(identifier:"en"))
            CompleteView(showCompleteWindew: $aa, image: Image("noImage"))
                .environment(\.locale, Locale(identifier:"ja"))
        }
    }
}
