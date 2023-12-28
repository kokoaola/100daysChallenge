//
//  DetailViewModel.swift
//  Challenge100days
//
//  Created by koala panda on 2023/12/27.
//

import Foundation


final class DetailViewModel: ViewModelBase{
    var item: DailyData?
    
    ///入力したテキストを格納するプロパティ
    @Published var editText = ""
    
    ///削除ボタン押下後の確認アラート用のフラグ
    @Published var showCansel = false
    
    
    func setItem(item: DailyData){
        self.item = item
    }
    
    ///当日のタスクの完了を保存するメソッド
    //    func saveTodaysChallenge(challengeDate: Int, completion: @escaping (Bool) -> Void) {
    //        //データのインスタンス生成
    //        let entity = DailyData(context: PersistenceController.shared.moc)
    //        entity.id = UUID()
    //        entity.date = Date()
    //        entity.memo = ""
    //        entity.num = Int16(challengeDate)
    //
    //        // 変更を保存
    //        PersistenceController.shared.saveAsync { error in
    //            if let _ = error {
    //                // エラーハンドリング
    //                completion(false)
    //            } else {
    //                //ウィジェットを更新
    //                AppGroupConstants.reloadTimelines()
    //                // 保存成功
    //                completion(true)
    //            }
    //        }
    //    }
    
    
    
    ///引数で受け取ったデータを削除するメソッド
    func deleteData(data: DailyData, completion: @escaping (Bool) -> Void) {
        // 変更を保存
        PersistenceController.shared.deleteAsync(data){ error in
            if let _ = error {
                // エラーハンドリング
                completion(false)
            } else {
                //ウィジェットを更新
                AppGroupConstants.reloadTimelines()
                // 保存成功
                completion(true)
            }
        }
    }
}
