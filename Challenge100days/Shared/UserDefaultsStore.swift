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
    
    
    ///目標非表示の設定を格納する変数
    //ユーザー入力用
    @Published var userInputHideInfomation: Bool = false
    //保存用
    private(set) var savedHideInfomation: Bool {
        get { defaults.bool(forKey: UserDefaultsConstants.hideInfomationKey) }
        set { defaults.set(newValue, forKey: UserDefaultsConstants.hideInfomationKey) }
    }
    
    ///背景色を格納する変数
    //ユーザー入力用
    @Published var userInputColor: Int = 0
    //保存用
    private(set) var savedColor: Int {
        get { defaults.integer(forKey:UserDefaultsConstants.userSelectedColorKey) }
        set { defaults.set(newValue, forKey: UserDefaultsConstants.userSelectedColorKey) }
    }
    
    ///長期目標を格納する変数
    //ユーザー入力用
    @Published var userInputLongTermGoal: String = ""
    //保存用
    private(set) var savedLongTermGoal2: String {
        get { defaults.string(forKey:UserDefaultsConstants.longTermGoalKey) ?? "" }
        set { defaults.set(newValue, forKey: UserDefaultsConstants.longTermGoalKey) }
    }
    
    ///短期目標を格納する変数
    //ユーザー入力用
    @Published var userInputShortTermGoal: String = ""
    //保存用
    private(set) var savedShortTermGoal2: String {
        get { defaults.string(forKey:UserDefaultsConstants.shortTermGoalKey) ?? "" }
        set { defaults.set(newValue, forKey: UserDefaultsConstants.shortTermGoalKey) }
    }
    
    
    
    
    ///長期目標を格納する変数
//    @Published private(set) var savedLongTermGoal: String
    ///短期目標を格納する変数
//    @Published private(set) var savedShortTermGoal: String
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
//        self.savedLongTermGoal = defaults.string(forKey:UserDefaultsConstants.longTermGoalKey) ?? ""
//        self.savedShortTermGoal = defaults.string(forKey:UserDefaultsConstants.shortTermGoalKey) ?? ""
        self.isFirst = defaults.bool(forKey:UserDefaultsConstants.isFirstKey)
//        self.savedHideInfomation = defaults.bool(forKey: UserDefaultsConstants.hideInfomationKey)
//        self.savedColor = defaults.integer(forKey:UserDefaultsConstants.userSelectedColorKey)
        
        userInputHideInfomation = savedHideInfomation
        userInputColor = savedColor
        userInputLongTermGoal = savedLongTermGoal2
        userInputShortTermGoal = savedShortTermGoal2
    }
    
    ///目標表示設定を保存する関数
    func saveHideInfomation(){
        savedHideInfomation = userInputHideInfomation
    }
    
    ///アプリ全体のカラーを設定する関数
    func saveSettingColor(){
        savedColor = userInputColor
    }
    

    
    func saveLongTermGoal(){
        savedLongTermGoal2 = userInputLongTermGoal
    }
    func saveShortTermGoal(){
        savedShortTermGoal2 = userInputShortTermGoal
    }
    
    ///値の長さが正しいかどうかのプロパティ
    var isLongTermGoalLengthValid: Bool{
        AppSetting.maxLengthOfTerm >= userInputLongTermGoal.count
    }
    var isShortTermGoalLengthValid: Bool{
        AppSetting.maxLengthOfTerm >= userInputShortTermGoal.count
    }
    var isLongTermNotEmpty: Bool{
        !userInputLongTermGoal.isEmpty
    }
    var isShortTermGoalNotEmpty: Bool{
        !userInputShortTermGoal.isEmpty
    }
    var isAllGoalValid: Bool{
        isLongTermGoalLengthValid && isShortTermGoalLengthValid && isLongTermNotEmpty && isShortTermGoalNotEmpty
    }

    
    ///設定をすべて削除するメソッド
    func resetUserDefaultsSetting(){
        userInputHideInfomation = false
        saveHideInfomation()
        
        userInputColor = 0
        saveSettingColor()
        
        userInputLongTermGoal = ""
        saveLongTermGoal()
        
        userInputShortTermGoal = ""
        saveShortTermGoal()
        
        isFirst = true
    }
}
