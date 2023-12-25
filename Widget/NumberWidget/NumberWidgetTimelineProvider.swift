//
//  NumberWidgetTimelineProvider.swift
//  ChallengeWidgetExtensionExtension
//
//  Created by koala panda on 2023/10/05.
//

import WidgetKit
import SwiftUI
import CoreData

// TimelineProviderプロトコルを採用する構造体GroceryTimelineProviderを定義
struct NumberWidgetTimelineProvider:TimelineProvider{
    // Entry型としてGroceryEntryを使用
    typealias Entry = NumberWidgetEntry
    
    
    // placeholderメソッドでデフォルトのGroceryEntryを返す、Widgetのプレビュー表示に使われる
    func placeholder(in context: Context) -> NumberWidgetEntry {
        NumberWidgetEntry(items: 32)
    }
    
    // getSnapshotメソッドでデフォルトのGroceryEntryを返す、Widgetの静的なビューの表示に使われる
    func getSnapshot(in context: Context, completion: @escaping (NumberWidgetEntry) -> Void) {
        completion(NumberWidgetEntry(items: 32))
    }
    
    // getTimelineメソッドで指定されたWidgetファミリーサイズに基づいてフェッチするアイテムの数を決定し、タイムラインを取得
    func getTimeline(in context: Context, completion: @escaping (Timeline<NumberWidgetEntry>) -> Void) {
        // Itemのフェッチリクエストを作成
        //        let request = DailyData.fetchRequest()
        
        let context = PersistenceController.persistentContainer.viewContext
        let request = NSFetchRequest<DailyData>(entityName: "DailyData")
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        do{
            let items = try context.fetch(request)
            let itemCount = items.count
            completion(Timeline(entries: [NumberWidgetEntry(items: itemCount)], policy: .never))
        }catch{
            fatalError()
        }
    }
}
