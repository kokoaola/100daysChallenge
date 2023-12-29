//
//  GrobalStore.swift
//  Challenge100days
//
//  Created by koala panda on 2023/12/27.
//

import Foundation
import CoreData

///目標と初回起動のフラグを格納するグローバルオブジェクト
class GlobalStore: ObservableObject {
    ///データコントローラー格納変数
    let context = PersistenceController.persistentContainer.viewContext
    ///データを全件格納する変数
    @Published var allData : [DailyData]
    ///今日が何日目のチャレンジか格納する変数
    @Published var dayNumber: Int
    ///全体で表示中のタブを格納する変数
    @Published var userSelectedTag = "one"
    ///当日のタスクが達成済みかを格納する変数
    @Published var finishedTodaysTask = true
    
    
    
    let request = NSFetchRequest<DailyData>(entityName: AppGroupConstants.entityName)
    
    init(){
        allData = []
        dayNumber = 1
        
        setAllData()
    }
    
    
    ///すべてのデータを取得するメソッド
    func setAllData(){
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        
        DispatchQueue.main.async {

            do{
                let tasks = try self.context.fetch(self.request)
                    self.allData = tasks
            }catch{
                self.allData = []
                self.dayNumber = 1
                self.finishedTodaysTask = false
                return
            }
            
            guard let lastData = self.allData.last?.date else {
                self.dayNumber = 1
                self.finishedTodaysTask = false
                return
            }
            
            if Calendar.current.isDate(Date.now, equalTo: lastData, toGranularity: .day){
                self.finishedTodaysTask = true
                self.dayNumber = self.allData.count
            }else{
                self.finishedTodaysTask = false
                self.dayNumber = self.allData.count + 1
            }
        }
    }
    
    
    
    ///データの番号を振り直すメソッド
    func assignNumbers() async{
        var allTask = [DailyData]()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
            do{
                allTask = try self.context.fetch(self.request)
            }catch{
                return
            }
        
            for (index, data) in allTask.enumerated() {
                // numを1から順に割り当てる
                data.num = Int16(index + 1)
            }
        
        await MainActor.run{
            // 変更を保存
            PersistenceController.shared.saveAsync { error in
                if let _ = error {
                } else {
                    //                self.setAllData()
                }
            }
        }
    }
}
