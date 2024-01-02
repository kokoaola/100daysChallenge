//
//  BigButtonViewModel.swift
//  Challenge100days
//
//  Created by koala panda on 2023/12/27.
//

import Foundation


final class BigButtonViewModel: ObservableObject{
    
    ///コンプリートウインドウを表示するかどうかのフラグ
    @Published var showCompleteWindew: Bool
    
    ///アニメーション制御用
    @Published var showAnimation: Bool = true
    
    init(){
        self.showCompleteWindew = false
    }
    
    ///当日のタスクの完了を保存するメソッド
    func saveTodaysChallenge(challengeDate: Int, completion: @escaping (Bool) -> Void) {
        //データのインスタンス生成
        let entity = DailyData(context: PersistenceController.shared.moc)
        entity.id = UUID()
        entity.date = Date()
        entity.memo = ""
        entity.num = Int16(challengeDate)
        
        // 変更を保存
        PersistenceController.shared.saveAsync { error in
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
