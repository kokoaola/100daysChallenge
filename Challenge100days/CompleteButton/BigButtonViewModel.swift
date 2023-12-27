//
//  BigButtonViewModel.swift
//  Challenge100days
//
//  Created by koala panda on 2023/12/27.
//

import Foundation


final class BigButtonViewModel: ViewModelBase{
    ///コンプリートウインドウを表示するかどうかのフラグ
    @Published var showCompleteWindew: Bool
    
    ///アニメーション制御用
    @Published var showAnimation: Bool = true
    
    ///目標を表示するかどうかの設定を格納する変数
    @Published var hideInfomation: Bool{
        didSet {
            defaults.set(self.hideInfomation, forKey: UserDefaultsConstants.hideInfomationKey)
        }
    }
    
    override init(){
        //defaultsへのアクセスをsuper.initの後に移動する処理
        self.showCompleteWindew = false
        self.hideInfomation = false
        // super.initを呼び出す
        super.init()
        // super.initの後でdefaultsから値を取得
        self.hideInfomation = defaults.bool(forKey: UserDefaultsConstants.hideInfomationKey)
    }
    
    ///当日のタスクの完了を保存するメソッド
    func saveTodaysChallenge(challengeDate: Int) {
        //データのインスタンス生成
        let entity = DailyData(context: PersistenceController.shared.moc)
        entity.id = UUID()
        entity.date = Date()
        entity.memo = ""
        entity.num = Int16(challengeDate)
        
        // 変更を保存
        PersistenceController.shared.save { error in
            if let error = error {
                print("Error updating document: \(error)")
                // エラー処理
            }else{
                //ウィジェットを更新
                AppGroupConstants.reloadTimelines()
            }
        }
    }
}
