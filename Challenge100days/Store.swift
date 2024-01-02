//
//  Store.swift
//  WeatherApp
//
//  Created by koala panda on 2023/12/13.
//

//import Foundation
//
//
/////目標と初回起動のフラグを格納するグローバルオブジェクト
//class Store: ObservableObject {
//    ///データコントローラー格納変数
//    let context = PersistenceController.persistentContainer.viewContext
//    
//    ///ユーザーデフォルト用の変数
//    private let defaults = UserDefaults.standard
//    
//    ///長期目標を格納する変数
//    @Published var longTermGoal:String{
//        didSet {
//            defaults.set(self.longTermGoal, forKey: UserDefaultsConstants.longTermGoalKey)
//        }
//    }
//    
//    ///短期目標を格納する変数
//    @Published var shortTermGoal:String{
//        didSet {
//            defaults.set(self.shortTermGoal, forKey: UserDefaultsConstants.shortTermGoalKey)
//        }
//    }
//    
//    ///初回起動確認用
//    @Published var isFirst: Bool{
//        didSet {
//            defaults.set(self.isFirst, forKey: UserDefaultsConstants.isFirstKey)
//        }
//    }
//    
//    ///背景色を格納する変数
//    @Published var userSelectedColor: Int
//    
//    ///全体で表示中のタブを格納する変数
//    @Published var userSelectedTag = "one"
//    
//    ///アニメーション表示確認用
//    @Published var showAnimation: Bool = true
//
//    
//    
//    
//    init(){
//        //初期値が入っていない場合は初回起動フラグにtrueを設定
//        defaults.register(defaults: ["isFirst":true])
//        //アプリ起動時はユーザーデフォルトからデータを取得
//        self.longTermGoal = defaults.string(forKey:UserDefaultsConstants.longTermGoalKey) ?? ""
//        self.shortTermGoal = defaults.string(forKey:UserDefaultsConstants.shortTermGoalKey) ?? ""
//        self.isFirst = defaults.bool(forKey:UserDefaultsConstants.isFirstKey)
//        self.userSelectedColor = defaults.integer(forKey:UserDefaultsConstants.userSelectedColorKey)
//    }
//    
//    ///ユーザーが選んだアプリの色を保存するメソッド
//    func saveUserSettingAppColor(){
//        defaults.set(self.userSelectedColor, forKey: UserDefaultsConstants.userSelectedColorKey)
//    }
//    
//    ///ユーザーのカスタムセッティングをすべてリセットするメソッド
//    func resetUserSetting(){
//        userSelectedTag = "one"
//        self.longTermGoal = ""
//        self.shortTermGoal = ""
//        self.isFirst = true
//        self.userSelectedColor = 0
//    }
//    
//}
