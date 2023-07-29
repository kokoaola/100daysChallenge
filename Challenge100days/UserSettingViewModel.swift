//
//  UserSetting.swift
//  Challenge100days
//
//  Created by koala panda on 2023/07/26.
//

import Foundation

class UserSettingViewModel: ObservableObject{
    ///長期目標を格納する変数
    @Published var longTermGoal:String
    ///短期目標を格納する変数
    @Published var shortTermGoal:String
    ///表示中のタブを格納する変数
    @Published var userSelectedTag = "one"
    ///背景色を格納する変数
    @Published var userSelectedColor: Int
    ///初回起動確認用
    @Published var isFirst: Bool
    ///コンプリートウインドウ表示フラグ
    @Published var showCompleteWindow = false
    
    ///ユーザーデフォルト用の変数
    private let defaults = UserDefaults.standard
    ///ユーザーデフォルト用キー：目標用
    private let longTermGoalKey = "longTermGoal"
    ///ユーザーデフォルト用キー：取り組むこと用
    private let shortTermGoalKey = "shortTermGoal"
    ///ユーザーデフォルト用キー：初回起動確認用
    private let isFirstKey = "isFirst"
    ///ユーザーデフォルト用キー：アプリカラー選択用
    private let userSelectedColorKey = "userSelectedColorKey"
    

    init(){
        defaults.register(defaults: ["isFirst":true])
        //アプリ起動時はユーザーデフォルトからデータを取得
        self.longTermGoal = defaults.string(forKey:longTermGoalKey) ?? ""
        self.shortTermGoal = defaults.string(forKey:shortTermGoalKey) ?? ""
        self.isFirst = defaults.bool(forKey:isFirstKey)
        self.userSelectedColor = defaults.integer(forKey:userSelectedColorKey)
    }
    
    ///ユーザーが選んだアプリの色を保存するメソッド
    func saveUserSettingAppColor(colorNum: Int){
        self.userSelectedColor = colorNum
        defaults.set(colorNum, forKey: userSelectedColorKey)
    }
    
    ///ユーザーが選んだ目標を保存するメソッド
    func saveUserSettingGoal(isLong: Bool, goal: String){
        objectWillChange.send()
        if isLong{
            longTermGoal = goal
            defaults.set(goal, forKey: longTermGoalKey)
        }else{
            shortTermGoal = goal
            defaults.set(goal, forKey: shortTermGoalKey)
        }
    }
    
    ///初回起動フラグを変更して保存するメソッド
    func toggleTutorialStatus(changeTo:Bool){
        objectWillChange.send()
        isFirst = changeTo
        defaults.setValue(isFirst, forKey: isFirstKey)
    }
    
    ///ユーザーのカスタムセッティングをすべてリセットするメソッド
    func resetUserSetting(){
        userSelectedTag = "one"
        self.saveUserSettingGoal(isLong: true, goal: "")
        self.saveUserSettingGoal(isLong: false, goal: "")
        self.toggleTutorialStatus(changeTo: true)
        self.saveUserSettingAppColor(colorNum: 0)
    }
    
    ///
    func switchShowCompleteWindow(isOn: Bool){
        objectWillChange.send()
        self.showCompleteWindow = isOn
    }
}


