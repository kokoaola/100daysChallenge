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
    
    ///データコントローラー格納変数
    let persistenceController = DataController()
    
    ///当日のタスクが達成済みかを格納するコンピューテッドプロパティ
    var checkTodaysTask: Bool{
        if let lastData = allData.last?.date{
            if Calendar.current.isDate(Date.now, equalTo: lastData, toGranularity: .day){
                return true
            }else{
                return false
            }
        }
        return false
    }
    
    
    init() {
        let context = persistenceController.container.viewContext
        let request = NSFetchRequest<DailyData>(entityName: "DailyData")
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        do{
            let tasks = try context.fetch(request)
            self.allData = tasks
        }catch{
            fatalError()
        }
    }
    
    
    ///すべてのデータを再取得するメソッド
    func getAllData() -> [DailyData]{
        let context = persistenceController.container.viewContext
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
    func saveData(date:Date, memo: String) {
        let context = persistenceController.container.viewContext
        let entity = NSEntityDescription.insertNewObject(forEntityName: "DailyData", into: context) as! DailyData
        entity.id = UUID()
        entity.date = date
        entity.memo = memo
        entity.num = Int16(allData.count + 1)
        
        do {
            try context.save()
            print("OK")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        objectWillChange.send()
        allData = getAllData()
    }
    
    
    ///引数で受け取った日のメモを更新するメソッド、データがnilなら最新のメモを更新
    func updateDataMemo(newMemo: String, data: DailyData?) {
        let context = persistenceController.container.viewContext
        
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
    func deleteData(data: DailyData) {
        let context = persistenceController.container.viewContext
        context.delete(data)
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
        }
        
        objectWillChange.send()
        allData = getAllData()
    }
    
    
    ///データの番号を振り直すメソッド
    func assignNumbers() async{
        let context = persistenceController.container.viewContext
        
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
            
            objectWillChange.send()
            allData = getAllData()
        }
    }
}
