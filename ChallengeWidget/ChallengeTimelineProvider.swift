//
//  ChallengeTimelineProvider.swift
//  ChallengeWidgetExtensionExtension
//
//  Created by koala panda on 2023/10/04.
//

import WidgetKit
import SwiftUI
import CoreData

// TimelineProviderプロトコルを採用する構造体GroceryTimelineProviderを定義
struct ChallengeTimelineProvider:TimelineProvider{
    // Entry型としてGroceryEntryを使用
    typealias Entry = ChallengeEntry
    
    
    // placeholderメソッドでデフォルトのGroceryEntryを返す、Widgetのプレビュー表示に使われる
    func placeholder(in context: Context) -> ChallengeEntry {
        ChallengeEntry()
    }
    
    // getSnapshotメソッドでデフォルトのGroceryEntryを返す、Widgetの静的なビューの表示に使われる
    func getSnapshot(in context: Context, completion: @escaping (ChallengeEntry) -> Void) {
        completion(ChallengeEntry())
    }
    
    // getTimelineメソッドで指定されたWidgetファミリーサイズに基づいてフェッチするアイテムの数を決定し、タイムラインを取得
    func getTimeline(in context: Context, completion: @escaping (Timeline<ChallengeEntry>) -> Void) {
        // Itemのフェッチリクエストを作成
//        let request = DailyData.fetchRequest()

        let context = DataController.persistentContainer.viewContext
        let request = NSFetchRequest<DailyData>(entityName: "DailyData")
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        do{
            let items = try context.fetch(request)
            completion(Timeline(entries: [ChallengeEntry(items: items)], policy: .never))
        }catch{
            fatalError()
        }
        
//        do{
//            // フェッチリクエストを使用してアイテムをフェッチ
//            let items = try DataController.shared.managedObjectContext.fetch(request)
//            // フェッチしたアイテムを使用してGroceryEntryを作成し、それを含むタイムラインを作成。ポリシーは.neverで、手動でのみ更新
//            completion(Timeline(entries: [GroceryEntry(items: items)], policy: .never))
//        }catch{
//            // エラーが発生した場合はエラー内容を出力
//            print(error.localizedDescription)
//        }
    }
}

