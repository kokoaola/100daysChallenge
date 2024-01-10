//
//  NotificationViewModel.swift
//  Challenge100days
//
//  Created by koala panda on 2023/07/20.
//

import NotificationCenter
import Foundation


///通知関連のビューモデル
class NotificationViewModel: ObservableObject{
    
    //ユーザーデフォルト用変数
    private let defaults = UserDefaults.standard
    //端末の通知設定用変数
    private let  notificationCenter = UNUserNotificationCenter.current()
    //端末設定でアプリの通知許可がONになっているかの状態の格納用変数
    @Published var isNotificationEnabled = false
    //通知をお願いするアラート表示用のフラグ（設定画面への遷移ボタン）
    @Published var showNotificationAlert = false
    
    //19時のDate型
    private let  defaultTime: Date = {
        var components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        components.hour = 19
        components.minute = 0
        return Calendar.current.date(from: components)!
    }()
    //デフォルトの文言
    private let defaultText: String = "本日のタスクが未達成です。挑戦を続けて、新たな習慣を築きましょう。"


    // UserDefaultsから取得したデータ用のプロパティ（通知ON-OFF）
    private(set) var savedIsNotificationOn: Bool {
        get { defaults.bool(forKey: UserDefaultsConstants.isNotificationOnKey)}
        set { defaults.set(newValue, forKey: UserDefaultsConstants.isNotificationOnKey) }
    }
    
    // ユーザー入力用のプロパティ（通知時間）
    @Published var userInputTime: Date = Date()
    // UserDefaultsから取得したデータ用のプロパティ（通知時間）
    private(set) var savedTime: Date {
        get { defaults.object(forKey: UserDefaultsConstants.userSettingNotificationTimeKey) as? Date ?? Date()}
        set { defaults.set(newValue, forKey: UserDefaultsConstants.userSettingNotificationTimeKey) }
    }
    
    // ユーザー入力用のプロパティ（曜日）
    @Published var userInputDays: [Weekday: Bool] = [ : ]
    private(set) var savedDays: [Int]  {
        get { defaults.object(forKey: UserDefaultsConstants.userSettingNotificationDayKey) as? [Int] ?? []}
        set { defaults.set(newValue, forKey: UserDefaultsConstants.userSettingNotificationDayKey)}
    }
    
    // ユーザー入力用のプロパティ（テキスト）
    @Published var userInputText: String = ""
    // UserDefaultsから取得したデータ用のプロパティ（テキスト）
    private(set) var savedText: String {
        get { defaults.string(forKey: UserDefaultsConstants.notificationTextKey) ?? ""}
        set { defaults.set(newValue, forKey: UserDefaultsConstants.notificationTextKey) }
    }

    //テキストフィールドに入力された文字数が範囲内か
    var isTextFieldValid: Bool{
        AppSetting.maxLengthOfNotificationText > userInputText.count
    }
    
    //曜日選択は有効か
    @Published var isSelectedDaysValid: Bool = true
    
    //NotificationObjectオブジェクトの作成
    @Published var notification: NotificationObject = NotificationObject()
    
    
    init(){
        ///通知設定がOFFなら初期値を表示
        if !self.savedIsNotificationOn{
            self.userInputTime = defaultTime
            self.userInputDays = Weekday.allCases.reduce(into: [Weekday: Bool]()) { $0[$1] = true }
            self.userInputText = defaultText
            
        }else{
            ///設定がONなら保存された値を表示
            userInputTime = savedTime
            userInputDays = notification.getDaysDic(by: savedDays)
            userInputText = savedText
        }
        setNotificationObject()
        
    }
    
    
    ///アプリの通知設定が許可されているか取得する関数
    func isUserNotificationEnabled(){
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if let error = error { return }
            //通知OK
            if success {
                DispatchQueue.main.async {
                    self.isNotificationEnabled = true
                    self.showNotificationAlert = false
                }
            //通知NG
            }else {
                DispatchQueue.main.async {
                    self.isNotificationEnabled = false
                    self.showNotificationAlert = true
                }
            }
        }
    }
    
    ///通知のオンオフを切り替えるメソッド
    func saveOnOff(isOn: Bool){
        savedIsNotificationOn = isOn
    }
    
    
    ///通知を停止して初期化するメソッド
    func resetNotification(){
        userInputDays = Weekday.allCases.reduce(into: [Weekday: Bool]()) { $0[$1] = true }
        savedTime = defaultTime
        userInputText = defaultText
        saveUserSelectedSetting()
        setNotificationObject()
        //すべてのスケジュールをキャンセル
        notificationCenter.removeAllPendingNotificationRequests()
        //通知をOFFにして保存
        saveOnOff(isOn: false)
    }
    
    ///notificationの持つプロパティの値を更新するメソッド
    func setNotificationObject(){
        DispatchQueue.main.async {
            self.notification.time = self.userInputTime
            self.notification.dateDic = self.userInputDays
        }
    }
    
    ///通知に関する内容を保存するメソッド
    func saveUserSelectedSetting(){
        //時間を保存
        savedTime = userInputTime
        //曜日を保存
        savedDays = notification.dateArray
        //文言を保存
        savedText = userInputText
        
        setNotificationObject()
    }
    
    ///通知をセットするメソッド（当日のタスクが達成済みなら翌日から開始する）
    func setNotification(isFinishTodaysTask: Bool) async{
        
        //通知設定がOFFなら何もせずリターン
        if savedIsNotificationOn == false{ return }
        
        //設定を保存
        saveUserSelectedSetting()
        
        //すでに予約されている通知の設定をすべて削除
        notificationCenter.removeAllPendingNotificationRequests()
        
        //通知音と文言の設定
        //端末の通知設定用変数
        let content = UNMutableNotificationContent()
        content.sound = UNNotificationSound.default
        content.title = "100日チャレンジ継続中！"
        if userInputText.isEmpty{
            content.body = defaultText //空白だったら初期値は定型文
        }else{
            content.body = savedText
        }
        
        
        //ユーザーが設定した時間でデータを作成
        var dateComponentsDay = DateComponents()
        let component = Calendar.current.dateComponents([.hour, .minute], from: self.savedTime)
        dateComponentsDay.hour = component.hour
        dateComponentsDay.minute = component.minute
        
        //今日のタスク完了済みなら日付を明日からでセット
        var startDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: Date())
        if isFinishTodaysTask{
            if let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date()) {
                startDate = Calendar.current.dateComponents([.year, .month, .day], from: tomorrow)
            }
        }
        dateComponentsDay.year = startDate.year
        dateComponentsDay.month = startDate.month
        dateComponentsDay.day = startDate.day

        
        // 保存されている曜日のnum値を取得
        let activeWeekdaysNums = notification.dateArray
        // 曜日ごとにリクエストを作成
        var notificationRequests = [UNNotificationRequest]()
        for day in activeWeekdaysNums{
            dateComponentsDay.weekday = day  // 1が日曜日、2が月曜日、というように設定
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponentsDay, repeats: true)
            // リクエストを追加
            let uuidStringMonday = UUID().uuidString
            let request = UNNotificationRequest(identifier: uuidStringMonday,content: content, trigger: trigger)
            notificationRequests.append(request)
        }
        
        // 通知をスケジュール
        for notificationRequest in notificationRequests {
            Task {
                do {
                    try await notificationCenter.add(notificationRequest)
                } catch {
                    //通知をOFFにして保存
                    saveOnOff(isOn: false)
                }
            }
        }
    }
}

