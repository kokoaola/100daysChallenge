//
//  CoreDataViewModel.swift
//  Challenge100days
//
//  Created by koala panda on 2023/07/23.
//

import Foundation
import CoreData


class CoreDataViewModel: ObservableObject{
    @Published var allData : [DailyData]
    let persistenceController = DataController2()
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
    
    
//    func checkTodaysTask() -> Bool{
//        if Calendar.current.isDate(Date.now, equalTo: allData.last?.date ?? Date.now, toGranularity: .day){
//            return true
//        }else{
//            return false
//        }
//    }
    
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
    
    
    ///新しくデータを保存するメソッド
    func saveData(date:Date, memo: String) {
        let context = persistenceController.container.viewContext
        let entity = NSEntityDescription.insertNewObject(forEntityName: "DailyData", into: context) as! DailyData
        entity.id = UUID()
        entity.date = Date()
        entity.memo = ""
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
        
        guard let data = data else {
            do {
                if let lastData = self.allData.last{
                    lastData.memo = newMemo //最新のデータのメモを更新
                    try context.save() //変更を保存
                }
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
            objectWillChange.send()
            allData = getAllData()
            return
        }
        
        do {
                data.memo = newMemo //受け取ったデータのメモを更新
                try context.save() //変更を保存
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        objectWillChange.send()
        allData = getAllData()
    }
    
    
//    func updateLastDataMemo(newMemo: String) {
//        let context = persistenceController.container.viewContext
//        do {
//            if let lastData = self.allData.last{
//                lastData.memo = newMemo //最新のデータのメモを更新
//                try context.save() //変更を保存
//            }
//        } catch let error as NSError {
//            print("Could not save. \(error), \(error.userInfo)")
//        }
//
//        objectWillChange.send()
//        allData = getAllData()
//    }
    
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

    
    
    func assignNumbers() async{
        let context = persistenceController.container.viewContext
        
        await MainActor.run{
            for (index, data) in self.allData.enumerated() {
                data.num = Int16(index + 1) // numを1から順に割り当てる
            }
            do {
                try context.save() // 変更を保存
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
            
            objectWillChange.send()
            allData = getAllData()
        }
    }
}
