//
//  ViewModelBase.swift
//  ToDoProject
//
//  Created by koala panda on 2023/12/19.
//

import Foundation

///ベースのビューモデル
class ViewModelBase: ObservableObject {
    ///ユーザーデフォルト用の変数
    let defaults = UserDefaults.standard
    
    ///背景色を格納する変数
    @Published var userSelectedColor: Int
    ///初回起動確認用
    @Published var isFirst: Bool{
        didSet {
            defaults.set(self.isFirst, forKey: UserDefaultsConstants.isFirstKey)
        }
    }
    ///長期目標を格納する変数
    @Published private(set) var longTermGoal: String
    ///短期目標を格納する変数
    @Published private(set) var shortTermGoal: String
    
    init(){
        //初期値が入っていない場合は初回起動フラグにtrueを設定
        defaults.register(defaults: ["isFirst":true])
        //アプリ起動時はユーザーデフォルトからデータを取得
        self.longTermGoal = defaults.string(forKey:UserDefaultsConstants.longTermGoalKey) ?? ""
        self.shortTermGoal = defaults.string(forKey:UserDefaultsConstants.shortTermGoalKey) ?? ""
        self.isFirst = defaults.bool(forKey:UserDefaultsConstants.isFirstKey)
        self.userSelectedColor = defaults.integer(forKey:UserDefaultsConstants.userSelectedColorKey)
    }
    
//    ///ユーザーが選んだアプリの色を保存するメソッド
//    func saveUserSettingAppColor(){
//        defaults.set(self.userSelectedColor, forKey: UserDefaultsConstants.userSelectedColorKey)
//    }
//    
//    ///目標を保存するメソッド
//    func setGoal(long: String?, short: String?){
//        if let long = long {
//            defaults.set(self.longTermGoal, forKey: UserDefaultsConstants.longTermGoalKey)
//            self.longTermGoal = long
//        }
//        if let short = short {
//            defaults.set(self.shortTermGoal, forKey: UserDefaultsConstants.shortTermGoalKey)
//            self.shortTermGoal = short
//        }
//    }
}


