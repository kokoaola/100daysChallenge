//
//  DataController.swift
//  Bookworm
//
//  Created by Paul Hudson on 23/11/2021.
//


import Foundation
import CoreData

class DataController: ObservableObject {


    // CoreDataManagerのシングルトンインスタンス
    static let shared = DataController()

    // 外部からの初期化を防ぐためのprivateイニシャライザ
    private init() {}

    // プライベートな永続コンテナを作成。アプリ内で一つのデータベースを保持する
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
        
        
        
        // ファイル存在確認
//        for filename in ["challengedDay.sqlite", "challengedDay.sqlite-wal", "challengedDay.sqlite-shm"] {
//            let oldURL = oldDirectory.appendingPathComponent(filename)
//            let newURL = appGroupURL.appendingPathComponent(filename)
//
//            print(filename,"2古いところに",fileManager.fileExists(atPath: oldURL.path) ? "あるよ" : "ないよ")
//            print(filename,"2新しいところに",fileManager.fileExists(atPath: newURL.path) ? "あるよ" : "ないよ")
//        }

        return container
    }()
}


//class DataController: ObservableObject {
//    // CoreDataManagerのシングルトンインスタンス
//    static let shared = DataController()
//
//    // 外部からの初期化を防ぐためのprivateイニシャライザ
//    private init() {}
//
//    // プライベートな永続コンテナを作成。アプリ内で一つのデータベースを保持する
//    static let persistentContainer: NSPersistentContainer = {
//
//        // AppグループコンテナのURLを指定し、SQLiteのデータベースファイルの場所を決定
//        //コンテナ（Appグループ）レベルで共有するので、パスコンポーネントはGrocery.xcdatamodeldと同じ名前
//        //        let storeURL = GroceryConstants.appGroupContainerURL.appendingPathComponent("challengedDay.sqlite")
//
//        // "Grocery"という名前でNSPersistentContainerを生成
//        //永続コンテナーはCoreDataのデータモデル名を受け取る
//        let container = NSPersistentContainer(name: "challengedDay")
//        // 指定したURLに永続ストアを設定
//        //        container.persistentStoreDescriptions = [NSPersistentStoreDescription(url: storeURL)]
//
//        // 指定されたURLに永続ストアが存在するか確認し、存在すればロード、存在しなければ作成
//        container.loadPersistentStores { storeDesc, error in
//            if let error = error as? NSError {
//                // エラーが存在したらその内容をコンソールに出力
//                print(error.localizedDescription)
//            }
//        }
//
//
//        // 初期化が完了したコンテナを返す
//        return container
//    }()
//    //    let container = NSPersistentContainer(name: "challengedDay")
//    //
//    //    init() {
//    //        container.loadPersistentStores { description, error in
//    //            if let error = error {
//    //                print("Core Data failed to load: \(error.localizedDescription)")
//    //            }
//    //        }
//    //    }
//}
