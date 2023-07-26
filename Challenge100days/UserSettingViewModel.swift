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
    @Published var userSelectedColor: AppColor
    
    ///初回起動確認用
    @Published var finishedTutorial: Bool
    
    private let longTermGoalKey = "longTermGoal"
    private let shortTermGoalKey = "shortTermGoal"
    private let finishedTutorialKey = "finishedTutorial"
    private let defaults = UserDefaults.standard
    
    init(){
        self.longTermGoal = defaults.string(forKey:longTermGoalKey) ?? ""
        self.shortTermGoal = defaults.string(forKey:shortTermGoalKey) ?? ""
        self.finishedTutorial = defaults.bool(forKey:finishedTutorialKey)
//        self.userSelectedColor 
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
    
    func toggleTutorialStatus(isFinish:Bool){
        objectWillChange.send()
        finishedTutorial = isFinish
        defaults.setValue(isFinish, forKey: finishedTutorialKey)
    }
    
    
    func resetUserSetting(){
        self.saveUserSettingGoal(isLong: true, goal: "")
        self.saveUserSettingGoal(isLong: false, goal: "")
        self.toggleTutorialStatus(isFinish: false)
    }
}

enum AppColor {
    case blue
    case orange
    case purple
    case monotone
}
