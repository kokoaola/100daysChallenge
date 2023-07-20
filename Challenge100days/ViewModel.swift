//
//  ViewModel.swift
//  Challenge100days
//
//  Created by koala panda on 2023/07/20.
//

import Swift
import Foundation
import SwiftUI

@MainActor class ViewModel: ObservableObject{
    @Published var completeTodaysTask = false
    ///CoreData用の変数
//    @Environment(\.managedObjectContext) var moc
//    @FetchRequest(sortDescriptors: [NSSortDescriptor(key:"date", ascending: true)]) var days: FetchedResults<DailyData>
    
    func checkTodaysTask(items: FetchedResults<DailyData>) -> Bool{
        ///アプリ起動時に今日のミッションがすでに完了しているか確認
        let todaysData = items.filter{
            ///CoreDataに保存されたデータの中に今日と同じ日付が存在するか確認
            Calendar.current.isDate(Date.now, equalTo: $0.date ?? Date.now, toGranularity: .day)
        }
        
        ///もし同日が存在していたら完了フラグをTrueにする
        if todaysData.isEmpty{
            return false
        }else{
            return true
        }
    }
    
}
