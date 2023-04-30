//
//  CompleteDoneView.swift
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
    @Binding var isComplete:Bool
    ///実績取り消し押下後の確認アラート用のフラグ
    @State var showCansel = false
    
    ///表示＆共有用の画像
    @State var image: Image?
    
    var dayNumber: Int{
        days.isEmpty ? 1 : days.count
    }

    var body: some View {
            
            VStack{

                ///四角に画像とボタンを重ねてる
                VStack{
                    
                    ///取り消しボタン（押すと確認アラートを表示）
                    Button(action: {
                        showCansel = true
                    }){
                        Image(systemName: "xmark.circle")
                            .font(.title3).foregroundColor(.red)
                    }.frame(maxWidth: .infinity,minHeight: 30, alignment: .topLeading)
                    
                    
                    VStack{
                        Text("本日のチャレンジ達成！")
                        Text("よく頑張ったね！")
                    }
                    .foregroundColor(Color(UIColor.label))

                    
                    ///コンプリート画像
                    image?
                        .resizable().scaledToFit()
                    
                    
                    ///シェアボタン
                    ShareLink(item: image ?? Image("noImage") , preview: SharePreview("画像", image:image ?? Image("noImage"))){
                        OriginalButton(labelString: "シェアする", labelImage: "square.and.arrow.up")
                            .foregroundColor(.blue.opacity(0.9))
                            .padding()
                    }
                    
                    
                    ///メモ追加ボタン
                    Button {
                        showMemo = true
                    } label: {
                        OriginalButton(labelString:(days.last?.memo == "") ? "メモを追加" : "メモを編集", labelImage: "rectangle.and.pencil.and.ellipsis")
                            .foregroundColor(.green.opacity(0.9))
                            .padding(.bottom)
                    }
                    
                }
                .padding()
                .background(.thinMaterial)
                .cornerRadius(15)
                
   
            }
            .padding(.bottom, 50)
            
        
        ///画面表示時にコンプリート画像を生成して表示
        .onAppear{
            image =  generateImageWithText(number: dayNumber, day: days.last?.date ?? Date.now)
        }
        
        ///メモ追加編集用のビュー
        .sheet(isPresented: $showMemo) {
            MemoSheet()
        }
        
        ///取り消しボタン押下時のアラート
        .alert("今日の記録を破棄しますか？", isPresented: $showCansel){
            Button("破棄する",role: .destructive){

                Task{
                    await  delete()
                    //await reNumber()
                }
                isComplete = false
            }
            Button("戻る",role: .cancel){}
        }message: {
            Text("本日のデータとメモは破棄されます。\n（破棄したデータは元に戻せません。）")
        }
        
    }
    

    ///削除用の関数
    func delete() async{
            if let item = days.last{
                moc.delete(item)
                try? moc.save()
            }
    }
    
    ///データ保存後の番号振り直し用の関数
    func reNumber() async{
        await MainActor.run{
            var counter = Int16(0)
            for i in days{
                counter += 1
                i.num = counter
                try? moc.save()
            }
        }
    }
    
    
}


struct CompleteDoneView_Previews: PreviewProvider {
    @Environment(\.managedObjectContext) var moc
    @State static var aa = false
    static private var dataController = DataController()
    
    static var previews: some View {
        CompleteView(isComplete: $aa, image: Image("noImage"))
    }
}


