//
//  CoreDataViewModel.swift
//  Challenge100days
//
//  Created by koala panda on 2023/07/23.
//

import Foundation
import CoreData

@MainActor
///CoreData関連のViewModel
class CoreDataViewModel: ObservableObject{
    ///データを全件格納する変数
    @Published var allData : [DailyData]
    
    ///データを全件格納する変数
    @Published var todaysNum : Int
    
    ///データコントローラー格納変数
//    let persistenceController = DataController()
    let persistenceController = DataController.persistentContainer
    
//    let storeURL = GroceryConstants.appGroupContainerURL.appendingPathComponent("Challenge100Day.sqlite")
    
    ///当日のタスクが達成済みかを格納する変数
    var checkTodaysTask: Bool{
        if let lastData = allData.last?.date{
            if Calendar.current.isDate(Date.now, equalTo: lastData, toGranularity: .day){
                return true
            }
        }
        return false
    }
    
    ///当日のタスクが達成済みかを格納する変数2
//    var isFinishTodaysTask: Bool
    
    
    init() {
        let context = persistenceController.viewContext
        let request = NSFetchRequest<DailyData>(entityName: "DailyData")
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        var tasks: [DailyData] = []
        do{
            tasks = try context.fetch(request)
            self.allData = tasks
        }catch{
            fatalError()
        }
        
        
//        guard let date = tasks.last?.date else {
//            self.isFinishTodaysTask = false
//            self.todaysNum = 1
//            return
//        }
//        if Calendar.current.isDate(Date.now, equalTo: date, toGranularity: .day){
//            self.isFinishTodaysTask = true
//        }else{
//            self.isFinishTodaysTask = false
//        }
        self.todaysNum = tasks.count + 1
    }
    
    
    ///すべてのデータを再取得するメソッド
    func getAllData() -> [DailyData]{
        let context = persistenceController.viewContext
        let request = NSFetchRequest<DailyData>(entityName: "DailyData")
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        do{
            let tasks = try context.fetch(request)
            return tasks
        }catch{
            fatalError()
        }
    }
    
    
    ///新規作成したデータを保存するメソッド
    func saveData(date:Date, memo: String){
        //本日のデータを重複して登録するのを避ける処理
        if let lastData = allData.last?.date{
            if Calendar.current.isDate(date, equalTo: lastData, toGranularity: .day){
                return
            }
        }
        
        //データのインスタンス生成
        let context = persistenceController.viewContext
        let entity = NSEntityDescription.insertNewObject(forEntityName: "DailyData", into: context) as! DailyData
        entity.id = UUID()
        entity.date = date
        entity.memo = memo
        entity.num = Int16(allData.count + 1)

        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        objectWillChange.send()
        allData = getAllData()
        
        //本日のタスク達成済みか確認
//        if let lastData = allData.last?.date{
//            if Calendar.current.isDate(Date.now, equalTo: lastData, toGranularity: .day){
//                isFinish = true
//            }else{
//                isFinish = false
//            }
//            objectWillChange.send()
////            self.isFinishTodaysTask = isFinish
//        }
    }
    
    
    ///引数で受け取った日のメモを更新するメソッド、データがnilなら最新のメモを更新
    func updateDataMemo(newMemo: String, data: DailyData?) async{
        let context = persistenceController.viewContext
        
        if let data = data{
            data.memo = newMemo
        } else{
            if let lastData = self.allData.last{
                lastData.memo = newMemo
            }
        }
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        objectWillChange.send()
        allData = getAllData()
    }
    
    
    ///引数で受け取ったデータを削除するメソッド
    func deleteData(data: DailyData) async{
        let context = persistenceController.viewContext
        context.delete(data)
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
        }
        
        objectWillChange.send()
        allData = getAllData()
        
        //本日のタスク達成済みか確認
        //データの最後尾の日付が存在しているか
        if let lastData = allData.last?.date{
            //データの最後尾の日付が本日の場合
            if Calendar.current.isDate(Date.now, equalTo: lastData, toGranularity: .day){
                //今日のタスク達成済みフラグを達成済みにする
                objectWillChange.send()
                return
            }
        }
        //データが存在しないとき、データの最後尾の日付が本日ではないとき
        //今日のタスク達成済みフラグを未達成にする
        objectWillChange.send()
    }
    
    
    ///データの番号を振り直すメソッド
    func assignNumbers() async{
        let context = persistenceController.viewContext
        
        await MainActor.run{
            for (index, data) in self.allData.enumerated() {
                // numを1から順に割り当てる
                data.num = Int16(index + 1)
            }
            do {
                // 変更を保存
                try context.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
            objectWillChange.send()
            allData = getAllData()
    }
    
    ///データベースのすべての記録を削除するメソッド
    func deleteAllData(){
        let context = persistenceController.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DailyData")
        
        // Create Batch Delete Request
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        
        do {
            try context.execute(batchDeleteRequest)
        } catch {
            // Error Handling
            print("Error deleting data: \(error)")
        }
        
        objectWillChange.send()
        allData = getAllData()
        objectWillChange.send()
//        self.isFinishTodaysTask = false
    }
}
