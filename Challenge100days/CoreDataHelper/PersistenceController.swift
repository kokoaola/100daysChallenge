//
//  DataController.swift
//  Challenge100days
//
//  Created by koala panda on 2023/12/03.
//

import Foundation
import CoreData



struct PersistenceController{
    // CoreDataManagerのシングルトンインスタンス
    static let shared = PersistenceController()
    
    
    // 外部からの初期化を防ぐためのprivateイニシャライザ
    private init() {
        moc = PersistenceController.persistentContainer.viewContext
    }
    
    ///DataControllerを直接インスタンス化することなく、シングルトンパターンを用いてアプリ全体で同じviewContextを使用する
    var moc: NSManagedObjectContext
    
    // プライベートな永続コンテナを作成しアプリ内で一つのデータベースを保持する
    static let persistentContainer: NSPersistentContainer = {
        let fileManager = FileManager.default
        
        let oldDirectory = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let appGroupURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.challenge100days")!
        
        //これまでのデータが存在している場合は、旧フォルダから新しいAppGroupのフォルダに移動させる
        // データベースと関連するすべてのファイルを新しい場所に移動
        for filename in ["challengedDay.sqlite", "challengedDay.sqlite-wal", "challengedDay.sqlite-shm"] {
            let oldURL = oldDirectory.appendingPathComponent(filename)
            let newURL = appGroupURL.appendingPathComponent(filename)
            
            if fileManager.fileExists(atPath: oldURL.path) && !fileManager.fileExists(atPath: newURL.path) {
                do {
                    try fileManager.moveItem(at: oldURL, to: newURL)
                } catch {
                    print("Error moving \(filename): \(error)")
                }
            }
        }
        
        // その後、NSPersistentContainerを新しいURLで初期化
        // 永続コンテナの設定を新しい場所に変更
        let container = NSPersistentContainer(name: "challengedDay")
        let storeDescription = NSPersistentStoreDescription(url: appGroupURL.appendingPathComponent("challengedDay.sqlite"))
        container.persistentStoreDescriptions = [storeDescription]
        container.loadPersistentStores { storeDesc, error in
            if let error = error as? NSError {
                print(error.localizedDescription)
            }
        }
        return container
    }()
    
    
    ///保存用関数
    ///アプリ全体でのデータ管理を中央化、カプセル化して他の部分からデータベース操作を容易に行えるようにするため、PersistenceControllerにsave関数を記述する
    ///コードの再利用性とメンテナンス性が向上する
    func save() {
        do {
            try moc.save()
        } catch {
            print("Error saving to CD: ", error.localizedDescription)
        }
    }
}


