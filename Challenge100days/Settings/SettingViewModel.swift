//
//  SettingViewModel.swift
//  Challenge100days
//
//  Created by koala panda on 2023/12/28.
//

import Foundation


final class SettingViewModel: ObservableObject{
    ///全データ削除の確認アラート表示用の変数
    @Published var showResetAlert = false
    
    ///動作完了時のトーストポップアップ用変数
    @Published var showToast = false
    @Published var toastText = ""
    
    ///長期目標か短期目標かのフラグ
    @Published var editLongTermGoal = false
    ///自分自身の表示状態を格納するフラグ
    @Published var showGoalEdittingAlert: Bool = false
}
