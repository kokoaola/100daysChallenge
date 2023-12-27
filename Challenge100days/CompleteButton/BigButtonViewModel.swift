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
    
    ///ユーザーデフォルトに目標表示設定を格納する変数
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
    
    
    func saveTodaysChallenge(challengeDate: Int,completion: @escaping (Error?) -> Void) {
        //データのインスタンス生成
        let entity = DailyData(context: PersistenceController.shared.moc)
        entity.id = UUID()
        entity.date = Date()
        entity.memo = ""
        entity.num = Int16(challengeDate)
        
        // 変更を保存
        PersistenceController.shared.save()
        
        //ウィジェットを更新
        AppGroupConstants.reloadTimelines()
    }
}
