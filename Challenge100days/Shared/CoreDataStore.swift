//
//  GrobalStore.swift
//  Challenge100days
//
//  Created by koala panda on 2023/12/27.
//

import Foundation
import CoreData

///目標と初回起動のフラグを格納するグローバルオブジェクト
class CoreDataStore: ObservableObject {
    //データコントローラー格納変数
    private let context = PersistenceController.persistentContainer.viewContext
    private let request = NSFetchRequest<DailyData>(entityName: AppGroupConstants.entityName)
    
    ///データを全件格納する変数
    @Published private(set) var allData : [DailyData]
    ///今日が何日目のチャレンジか格納する変数
    @Published private(set) var dayNumber: Int
    ///当日のタスクが達成済みかを格納する変数
    @Published private(set) var finishedTodaysTask = true
    
    @Published var isReturningFromDetailScreen = false

    
    init(){
        
        //配列にすべてのデータを格納
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        do{
            let tasks = try self.context.fetch(self.request)
            self.allData = tasks
            self.dayNumber = tasks.count
        }catch{
            self.allData = []
            self.dayNumber = 1
            return
        }
        setAllData()
        
    }
    
    
    ///すべてのデータを取得するメソッド
    func setAllData(){
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        
        DispatchQueue.main.async {
            
            do{
                //配列に最新のデータをセット
                let tasks = try self.context.fetch(self.request)
                self.allData = tasks
            }catch{
                self.allData = []
                self.dayNumber = 1
                self.finishedTodaysTask = false
                return
            }
            
            //最後の日付を取得
            guard let lastData = self.allData.last?.date else {
                self.dayNumber = 1
                self.finishedTodaysTask = false
                return
            }
            
            //最後の日付が起動した日と同じか確認
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
    func assignNumbers(completion: @escaping () -> Void) async {
        var allTask = [DailyData]()
        
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        do {
            allTask = try self.context.fetch(self.request)
        } catch {
            print("Fetch error")
            return
        }
        
        // allTaskの内容を更新する前にコピーを作成
        let updatedTasks = allTask.enumerated().map { (index, data) -> DailyData in
            let data = data
            data.num = Int16(index + 1)
            return data
        }
        
        await MainActor.run {
            // 変更を保存
            PersistenceController.shared.saveAsync { error in
                if let error = error {
                    print("Save error: \(error)")
                } else {
                    self.allData = updatedTasks
                    completion() // 処理完了時にコンプリーションハンドラを呼び出す
                }
            }
        }
    }
    
    
    ///データベースのすべての記録を削除するメソッド
    func deleteAllData(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: AppGroupConstants.entityName)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try context.execute(batchDeleteRequest)
        } catch {
            print("Error deleting data: \(error)")
        }
        setAllData()
        //ウィジェットを更新
        AppGroupConstants.reloadTimelines()
    }
}
