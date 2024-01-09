//
//  ListAndCardViewModel.swift
//  Challenge100days
//
//  Created by koala panda on 2023/12/27.
//

import Foundation


final class ListAndCardViewModel: ObservableObject{
    ///アイテム新規追加用シート格納変数
    @Published var showSheet = false
    
    ///リストで表示が選択されたときのフラグ
    @Published var showList = true
    
    ///すべてのコアデータを格納する変数
    @Published var allData: [DailyData] = []
    
    ///DetailScreenから戻ってきたことを通知する変数
    ///（onAppearのsetDailyDataメソッドが二重に実行されないようにするため）
    @Published var isReturningFromDetailScreen = false
    
    ///配列をビューモデルにセットする関数
    func setDailyData(allData: [DailyData]){
        self.allData = allData
    }
    
}
