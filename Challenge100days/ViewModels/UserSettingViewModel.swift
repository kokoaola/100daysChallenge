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
    ///アニメーション表示確認用
    @Published var showAnimation: Bool = true
    
    ///ユーザーデフォルト用の変数
    private let defaults = UserDefaults.standard

    

    init(){
        defaults.register(defaults: ["isFirst":true])
        //アプリ起動時はユーザーデフォルトからデータを取得
        self.longTermGoal = defaults.string(forKey:UserDefaultsConstants.longTermGoalKey) ?? ""
        self.shortTermGoal = defaults.string(forKey:UserDefaultsConstants.shortTermGoalKey) ?? ""
        self.isFirst = defaults.bool(forKey:UserDefaultsConstants.isFirstKey)
        self.userSelectedColor = defaults.integer(forKey:UserDefaultsConstants.userSelectedColorKey)
    }
    
    ///ユーザーが選んだアプリの色を保存するメソッド
    func saveUserSettingAppColor(colorNum: Int){
        self.userSelectedColor = colorNum
        defaults.set(colorNum, forKey: UserDefaultsConstants.userSelectedColorKey)
    }
    
    ///ユーザーが選んだ目標を保存するメソッド
    func saveUserSettingGoal(isLong: Bool, goal: String){
        objectWillChange.send()
        if isLong{
            longTermGoal = goal
            defaults.set(goal, forKey: UserDefaultsConstants.longTermGoalKey)
        }else{
            shortTermGoal = goal
            defaults.set(goal, forKey: UserDefaultsConstants.shortTermGoalKey)
        }
    }
    
    ///初回起動フラグを変更して保存するメソッド
    func toggleTutorialStatus(changeTo:Bool){
        objectWillChange.send()
        isFirst = changeTo
        defaults.setValue(isFirst, forKey: UserDefaultsConstants.isFirstKey)
    }
    
    ///ユーザーのカスタムセッティングをすべてリセットするメソッド
    func resetUserSetting(){
        userSelectedTag = "one"
        self.saveUserSettingGoal(isLong: true, goal: "")
        self.saveUserSettingGoal(isLong: false, goal: "")
        self.toggleTutorialStatus(changeTo: true)
        self.saveUserSettingAppColor(colorNum: 0)
    }
}


