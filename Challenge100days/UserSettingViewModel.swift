//
//  UserSetting.swift
//  Challenge100days
//
//  Created by koala panda on 2023/07/26.
//

import Foundation

class UserSettingViewModel: ObservableObject{
    @Published var longTermGoal:String
    @Published var shortTermGoal:String
    @Published var userSelectedTag = "one"
    @Published var userSelectedColor: Int
    
    ///初回起動確認用
    @Published var finishedTutorial: Bool
    
    ///ユーザーデフォルト用の変数
    private let defaults = UserDefaults.standard
    ///ユーザーデフォルト用キー：目標用
    private let longTermGoalKey = "longTermGoal"
    ///ユーザーデフォルト用キー：取り組むこと用
    private let shortTermGoalKey = "shortTermGoal"
    ///ユーザーデフォルト用キー：初回起動確認用
    private let finishedTutorialKey = "finishedTutorial"
    ///ユーザーデフォルト用キー：アプリカラー選択用
    private let userSelectedColorKey = "userSelectedColorKey"
    
    
    init(){
        self.longTermGoal = defaults.string(forKey:longTermGoalKey) ?? ""
        self.shortTermGoal = defaults.string(forKey:shortTermGoalKey) ?? ""
        self.finishedTutorial = defaults.bool(forKey:finishedTutorialKey)
        self.userSelectedColor = defaults.integer(forKey:userSelectedColorKey)
        
//        switch savedColor{
//        case 1:
//            userSelectedColor = AppColor.orange
//        case 2:
//            userSelectedColor = AppColor.purple
//        case 3:
//            userSelectedColor = AppColor.monotone
//        default:
//            userSelectedColor = AppColor.blue
//        }
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
    func toggleTutorialStatus(isFinish:Bool){
        objectWillChange.send()
        finishedTutorial = isFinish
        defaults.setValue(isFinish, forKey: finishedTutorialKey)
    }
    
    ///ユーザーのカスタムセッティングをすべてリセットするメソッド
    func resetUserSetting(){
        self.saveUserSettingGoal(isLong: true, goal: "")
        self.saveUserSettingGoal(isLong: false, goal: "")
        self.toggleTutorialStatus(isFinish: false)
        self.saveUserSettingAppColor(colorNum: 0)
    }
}


