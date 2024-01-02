//
//  SettingViewModel.swift
//  Challenge100days
//
//  Created by koala panda on 2023/12/28.
//

import Foundation


final class SettingViewModel: ViewModelBase{
    ///目標を表示するかどうかの設定を格納する変数
    @Published var hideInfomation: Bool = true
    
    ///全データ削除の確認アラート表示用の変数
    @Published var showResetAlert = false
    
    ///動作完了時のトーストポップアップ用変数
    @Published var showToast = false
    @Published var toastText = ""
    
    ///通知をお願いするアラート表示用のフラグ（設定画面への遷移ボタン）
//    @Published var showNotificationAlert = false
    
    ///目標再設定アラート表示用変数
//    @Published var showGoalEdittingAlert = false
    
    ///長期目標か短期目標かのフラグ
    @Published var editLongTermGoal = false
    ///自分自身の表示状態を格納するフラグ
    @Published var showGoalEdittingAlert: Bool = false
    ///入力したテキストを格納する変数
    @Published var editText: String = ""
    
    var isTextLengthValid: Bool{
        AppSetting.maxLengthOfTerm > editText.count
    }
    
    var isTextNotEmpty: Bool{
        !editText.isEmpty
    }
    
    override init(){
        // super.initを呼び出す
        super.init()
        // super.initの後でdefaultsから値を取得
        self.hideInfomation = defaults.bool(forKey: UserDefaultsConstants.hideInfomationKey)
    }
}
