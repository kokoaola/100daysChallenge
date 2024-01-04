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
        print("Fetched tasks count: \(allTask.count)")
        
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



///ユーザーデフォルト用のグローバルオブジェクト
class UserDefaultsStore: ObservableObject {
    //ユーザーデフォルト用の変数
    private let defaults = UserDefaults.standard
    
    ///目標を表示するかどうかの設定を格納する変数
    @Published private(set) var hideInfomation: Bool
    ///背景色を格納する変数
    @Published private(set) var savedColor: Int = 0
    ///長期目標を格納する変数
    @Published private(set) var longTermGoal: String
    ///短期目標を格納する変数
    @Published private(set) var shortTermGoal: String
    ///初回起動確認用
    @Published var isFirst: Bool{
        didSet {
            defaults.set(self.isFirst, forKey: UserDefaultsConstants.isFirstKey)
        }
    }
    
    
    init(){
        //アプリ起動時はユーザーデフォルトからデータを取得
        //初期値が入っていない場合は初回起動フラグにtrueを設定
        defaults.register(defaults: ["isFirst":true])
        self.longTermGoal = defaults.string(forKey:UserDefaultsConstants.longTermGoalKey) ?? ""
        self.shortTermGoal = defaults.string(forKey:UserDefaultsConstants.shortTermGoalKey) ?? ""
        self.isFirst = defaults.bool(forKey:UserDefaultsConstants.isFirstKey)
        self.hideInfomation = defaults.bool(forKey: UserDefaultsConstants.hideInfomationKey)
        self.savedColor = defaults.integer(forKey:UserDefaultsConstants.userSelectedColorKey)
        
    }

    ///目標を隠すかどうかを設定する関数
    func switchHideInfomation(_ isShow: Bool){
        self.hideInfomation = isShow
        defaults.set(isShow, forKey: UserDefaultsConstants.hideInfomationKey)
    }
    
    
    ///アプリ全体のカラーを設定する関数
    func saveSettingColor(_ color: Int){
        self.savedColor = color
        defaults.set(color, forKey: UserDefaultsConstants.userSelectedColorKey)
    }
    
    
    ///目標を保存するメソッド
    func setGoal(long: String?, short: String?){
        if let long = long {
            self.longTermGoal = long
            defaults.set(self.longTermGoal, forKey: UserDefaultsConstants.longTermGoalKey)
        }
        if let short = short {
            self.shortTermGoal = short
            defaults.set(self.shortTermGoal, forKey: UserDefaultsConstants.shortTermGoalKey)
        }
    }
    
    ///設定をすべて削除するメソッド
    func resetUserDefaultsSetting(){
        switchHideInfomation(false)
        saveSettingColor(0)
        setGoal(long: "", short: "")
        isFirst = true
    }
}
