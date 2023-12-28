//
//  ListComponents.swift
//  Challenge100days
//
//  Created by koala panda on 2023/12/28.
//

import SwiftUI


///リストにデータが一件も存在していないときのビュー
struct NoDataView: View {
    var body: some View {
        Text("まだデータがありません")
            .foregroundColor(Color(UIColor.label))
            .frame(maxWidth: .infinity, alignment: .center)
            .padding()
            .background(.thinMaterial)
            .cornerRadius(15)
    }
}


///リスト１行のビュー
struct ListLowView: View{
    var num: Int
    var date: Date
    var memo: String
    
    var body: some View{
        //セル部分のレイアウト
        HStack(alignment: .center){
            ZStack{
                //青い四角に番号を重ねて左端に表示
                Text("\(num)")
                    .font(.title2) .foregroundColor(.white)
                    .frame(width: AppSetting.screenWidth * 0.12, height: AppSetting.screenWidth * 0.12)
                    .background(.blue)
                    .cornerRadius(15)
                
                //最終アイテム追加してから１日以内なら、日付にキラキラを重ねて表示
                Image(systemName: "sparkles")
                    .offset(x:14, y:-14)
                    .foregroundColor(Calendar.current.isDate(Date.now, equalTo: date, toGranularity: .day) ? .yellow : .clear)
            }
            .padding(.trailing, 5)
            
            //メモの内容を表示
            VStack{
                Text(memo.replacingOccurrences(of: "\n", with: " "))
                //プレビュー用しやすいように改行はスペースに変換
                    .lineSpacing(1)
                    .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .topLeading)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(Color(UIColor.label))
                
                //日付を右下に配置
                Text(date, format:.dateTime.day().month().year())
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity,alignment: .bottomTrailing)
                
            }.frame(maxWidth: .infinity,maxHeight: .infinity)
                .font(.footnote)
            
            //右の矢印
            Image(systemName: "chevron.forward")
                .fontWeight(.thin)
                .foregroundColor(.gray)
            
        }
        .accessibilityElement()
        .accessibilityLabel("\(num)日目の記録、\(date, format:.dateTime.day().month().year())")
        .accessibilityAddTraits(.isLink)
        
        //セルの高さは最大150pxまで大きくなれる
        .frame(maxHeight: 150)
        .fixedSize(horizontal: false, vertical: true)
    }
}
