//
//  GaugeWidgetEntryTimelineProvider.swift
//  ChallengeWidgetExtensionExtension
//
//  Created by koala panda on 2023/10/04.
//

import WidgetKit
import SwiftUI
import CoreData

// TimelineProviderプロトコルを採用する構造体GroceryTimelineProviderを定義
struct GaugeWidgetEntryTimelineProvider:TimelineProvider{
    // Entry型としてGroceryEntryを使用
    typealias Entry = GaugeWidgetEntry
    
    
    // placeholderメソッドでデフォルトのGroceryEntryを返す、Widgetのプレビュー表示に使われる
    func placeholder(in context: Context) -> GaugeWidgetEntry {
        GaugeWidgetEntry(items: 32)
    }
    
    // getSnapshotメソッドでデフォルトのGroceryEntryを返す、Widgetの静的なビューの表示に使われる
    func getSnapshot(in context: Context, completion: @escaping (GaugeWidgetEntry) -> Void) {
        completion(GaugeWidgetEntry(items: 32))
    }
    
    // getTimelineメソッドで指定されたWidgetファミリーサイズに基づいてフェッチするアイテムの数を決定し、タイムラインを取得
    func getTimeline(in context: Context, completion: @escaping (Timeline<GaugeWidgetEntry>) -> Void) {
        // Itemのフェッチリクエストを作成
//        let request = DailyData.fetchRequest()

        let context = PersistenceController.persistentContainer.viewContext
        let request = NSFetchRequest<DailyData>(entityName: "DailyData")
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        do{
            let items = try context.fetch(request)
            let itemCount = items.count
            completion(Timeline(entries: [GaugeWidgetEntry(items: itemCount)], policy: .never))
        }catch{
            fatalError()
        }
    }
}

