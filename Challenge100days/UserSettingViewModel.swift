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
    ///初回起動確認用
    @Published var finishedTutorial: Bool
    
    private let longTermGoalKey = "longTermGoal"
    private let shorTermGoalKey = "shortTermGoal"
    private let finishedTutorialKey = "finishedTutorial"
    private let defaults = UserDefaults.standard
    
    init(){
        self.longTermGoal = defaults.string(forKey:longTermGoalKey) ?? ""
        self.shortTermGoal = defaults.string(forKey:shorTermGoalKey) ?? ""
        self.finishedTutorial = defaults.bool(forKey:finishedTutorialKey)
    }
    
    ///ユーザーが選んだ目標を保存するメソッド
    func saveUserSettingGoal(isLong: Bool, goal: String){
        if isLong{
            longTermGoal = goal
            defaults.set(goal, forKey: longTermGoalKey)
        }else{
            shortTermGoal = goal
            defaults.set(goal, forKey: shorTermGoalKey)
        }
    }
}
