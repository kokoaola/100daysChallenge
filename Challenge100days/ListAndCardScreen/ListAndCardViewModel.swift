//
//  ListAndCardViewModel.swift
//  Challenge100days
//
//  Created by koala panda on 2023/12/27.
//

import Foundation


final class ListAndCardViewModel: ViewModelBase{
    ///アイテム新規追加用シート格納変数
    @Published var showSheet = false
    
    ///リストで表示が選択されたときのフラグ
    @Published var showList = true
    
    @Published private(set) var allData: [DailyData] = []
    
    ///配列をビューモデルにセットする関数
    func setDailyData(allData: [DailyData]){
        self.allData = allData
    }
    
}
