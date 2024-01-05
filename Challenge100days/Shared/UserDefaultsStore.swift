//
//  UserDefaultsStore.swift
//  Challenge100days
//
//  Created by koala panda on 2024/01/05.
//

import Foundation


///ユーザーデフォルト用のグローバルオブジェクト
class UserDefaultsStore: ObservableObject {
    //ユーザーデフォルト用の変数
    private let defaults = UserDefaults.standard
    
    ///目標を表示するかどうかの設定を格納する変数
    @Published private(set) var savedHideInfomation: Bool
    ///背景色を格納する変数
    @Published private(set) var savedColor: Int = 0
    ///長期目標を格納する変数
    @Published private(set) var savedLongTermGoal: String
    ///短期目標を格納する変数
    @Published private(set) var savedShortTermGoal: String
    ///初回起動確認用
    @Published var isFirst: Bool{
        didSet {
            defaults.set(self.isFirst, forKey: UserDefaultsConstants.isFirstKey)
        }
    }
    
    
    init(){
        //アプリ起動時はユーザーデフォルトからデータを取得
        //初期値が入っていない場合は初回起動フラグにtrueを設定
        defaults.register(defaults: ["isFirst":true])
        self.savedLongTermGoal = defaults.string(forKey:UserDefaultsConstants.longTermGoalKey) ?? ""
        self.savedShortTermGoal = defaults.string(forKey:UserDefaultsConstants.shortTermGoalKey) ?? ""
        self.isFirst = defaults.bool(forKey:UserDefaultsConstants.isFirstKey)
        self.savedHideInfomation = defaults.bool(forKey: UserDefaultsConstants.hideInfomationKey)
        self.savedColor = defaults.integer(forKey:UserDefaultsConstants.userSelectedColorKey)
        
    }
    
    ///目標を隠すかどうかを設定する関数
    func switchHideInfomation(_ isShow: Bool){
        self.savedHideInfomation = isShow
        defaults.set(isShow, forKey: UserDefaultsConstants.hideInfomationKey)
    }
    
    
    ///アプリ全体のカラーを設定する関数
    func saveSettingColor(_ color: Int){
        self.savedColor = color
        defaults.set(color, forKey: UserDefaultsConstants.userSelectedColorKey)
    }
    
    
    ///目標を保存するメソッド
    func setGoal(long: String?, short: String?){
        if let long = long {
            self.savedLongTermGoal = long
            defaults.set(self.savedLongTermGoal, forKey: UserDefaultsConstants.longTermGoalKey)
        }
        if let short = short {
            self.savedShortTermGoal = short
            defaults.set(self.savedShortTermGoal, forKey: UserDefaultsConstants.shortTermGoalKey)
        }
    }
    
    ///設定をすべて削除するメソッド
    func resetUserDefaultsSetting(){
        switchHideInfomation(false)
        saveSettingColor(0)
        setGoal(long: "", short: "")
        isFirst = true
    }
}
