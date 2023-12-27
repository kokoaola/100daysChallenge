//
//  GrobalStore.swift
//  Challenge100days
//
//  Created by koala panda on 2023/12/27.
//

import Foundation
import CoreData

///目標と初回起動のフラグを格納するグローバルオブジェクト
class GrobalStore: ObservableObject {
    ///データコントローラー格納変数
    let context = PersistenceController.persistentContainer.viewContext
    ///データを全件格納する変数
    @Published var allData : [DailyData] = []
    ///今日が何日目のチャレンジか格納する変数
    @Published var dayNumber: Int = 1
    ///全体で表示中のタブを格納する変数
    @Published var userSelectedTag = "one"
    ///当日のタスクが達成済みかを格納する変数
    @Published var finishedTodaysTask = false
    
    init(){
        setAllData()
    }
    
    
    ///すべてのデータを取得するメソッド
    func setAllData(){
        let request = NSFetchRequest<DailyData>(entityName: AppGroupConstants.entityName)
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        do{
            let tasks = try context.fetch(request)
            allData = tasks
        }catch{
            allData = []
        }
        
        objectWillChange.send()
        guard let lastData = allData.last?.date else {
            dayNumber = 1
            finishedTodaysTask = false
            return }
        
        if Calendar.current.isDate(Date.now, equalTo: lastData, toGranularity: .day){
            finishedTodaysTask = true
            dayNumber = allData.count
        }else{
            finishedTodaysTask = false
            dayNumber = allData.count + 1
        }
    }
}
