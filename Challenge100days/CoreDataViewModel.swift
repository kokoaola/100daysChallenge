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
    
    func getAll() -> [DailyData]{

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
    
    func saveData() {
        let context = persistenceController.container.viewContext
        let entity = NSEntityDescription.insertNewObject(forEntityName: "DailyData", into: context) as! DailyData
        entity.id = UUID()
        entity.date = Date()
        entity.memo = ""
        entity.num = Int16(allData.count + 1)
        
        do {
            try context.save()
//            allData.append(entity)
            print("OK")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        objectWillChange.send()
        allData = getAll()
    }
    
    
    func updateLastDataMemo(newMemo: String) {
        let context = persistenceController.container.viewContext
//        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)] //降順で並べる
//        request.fetchLimit = 1 //最新の一つだけを取得
        do {
//            if let lastData = try context.fetch(request).first { //最新のデータを取得
            if let lastData = self.allData.last{
                lastData.memo = newMemo //最新のデータのメモを更新
                try context.save() //変更を保存
            }
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        objectWillChange.send()
        allData = getAll()
    }
    
//    func reNumber() async{
//        await MainActor.run{
//            var counter = Int16(0)
//            for item in allData{
//                counter += 1
//                item.num = counter
//                try? moc.save()
//            }
//        }
//    }
    
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
            allData = getAll()
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
