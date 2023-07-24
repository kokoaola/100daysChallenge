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
    let persistenceController = DataController()
    
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
        self.allData = []
    }
    
    func getAll() -> [DailyData]{
        let persistenceController = DataController()
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
    
    func saveData(date: Date, memo: String, num: Int16) {
        let context = persistenceController.container.viewContext
        let entity = NSEntityDescription.insertNewObject(forEntityName: "DailyData", into: context) as! DailyData
        entity.id = UUID()
        entity.date = date
        entity.memo = memo
        entity.num = num
        
        do {
            try context.save()
            allData.append(entity)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    
    func updateLastDataMemo(newMemo: String) {
        let context = persistenceController.container.viewContext
        let request = NSFetchRequest<DailyData>(entityName: "DailyData")
//        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)] //降順で並べる
//        request.fetchLimit = 1 //最新の一つだけを取得
        let lastData = self.allData.last
        do {
//            if let lastData = try context.fetch(request).first { //最新のデータを取得
            if let lastData = self.allData.last{
                lastData.memo = newMemo //最新のデータのメモを更新
                try context.save() //変更を保存
            }
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    
    /////全件表示関数
//    func getAllData() -> [Entity]{
//        //すべてのデータを取り出す
//        let persistenceController = PersistenceController.shared
//        let context = persistenceController.container.viewContext
//        let request = NSFetchRequest<Entity>(entityName: "Entity")
//        //request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
//
//        do{let tasks = try context.fetch(request)
//            return tasks
//        }catch{
//            fatalError()
//        }
//    }
}
