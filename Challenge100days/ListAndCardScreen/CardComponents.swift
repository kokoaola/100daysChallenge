//
//  CardAndListComponents.swift
//  Challenge100days
//
//  Created by koala panda on 2023/12/28.
//

import SwiftUI

///カードビューのセルの外枠
struct CardBackComponents: View {
    let num: Int
    var body: some View {
        VStack(spacing: -3){
            
            //100マス目の王冠表示用
            Image(systemName: "crown.fill")
                .foregroundColor(num == 100 ? .yellow : .clear)
            
            ZStack{
                //空白のマスを１００個
                Image(systemName:"app")
                    .font(.title.weight(.thin))
                    .foregroundColor(.gray)
                    .opacity(0.3)
                
                //10個ずつ番号をつける
                Text((num % 10 == 0) ? "\(num)" : "")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .opacity(0.5)
            }
        }
        .accessibilityHidden(true)
    }
}

///カードビューのセルの塗りつぶし部分
struct CardFrontComponents: View {
    var num: Int
    var date: Date
    
    var body: some View {
        VStack(spacing: -3){
            //ダミー用の王冠（これがないと後ろのセルとずれちゃう）
            Image(systemName: "crown.fill").foregroundColor(.clear)
            
            ZStack{
                //日数に応じて青いセルを表示する
                Image(systemName:"app.fill")
                    .font(.title.weight(.thin))
                    .foregroundColor(.blue)
                
                
                //最終アイテム追加してから１日以内ならキラキラを表示
                Image(systemName: "sparkles")
                    .offset(x:8, y:-9)
                    .foregroundColor(Calendar.current.isDate(Date.now, equalTo: date, toGranularity: .day) ? .yellow : .clear)
                
                //セルに番号を重ねる
                Text("\(num)")
                    .font(.footnote)
                    .foregroundColor(.white)
            }
        }
    }
}
