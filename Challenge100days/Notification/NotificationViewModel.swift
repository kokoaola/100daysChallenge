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
    ///ユーザーデフォルト用変数
    private let defaults = UserDefaults.standard
    
    ///端末の通知設定用変数
    let content = UNMutableNotificationContent()
    let notificationCenter = UNUserNotificationCenter.current()
    //端末設定でアプリの通知許可がONになっているかの状態の格納用変数
    @Published var isNotificationEnabled = false
    //通知をお願いするアラート表示用のフラグ（設定画面への遷移ボタン）
    @Published var showNotificationAlert = false
    
    ///アプリ内の通知設定用変数
    //通知を送る時間を格納する変数(ユーザーデフォルト保存用)
    @Published private(set) var savedTime: Date
    //通知を送る曜日を格納する変数(ユーザーデフォルト保存用)
    private(set) var savedDays = Weekday.allCases.reduce(into: [Weekday: Bool]()) { $0[$1] = true }
    //ユーザーが通知を設定したかを格納する変数(ユーザーデフォルト保存用)
    private(set) var isNotificationOn: Bool
    

    
    init(){
        ///ユーザーの設定を取得
        ///通知On
        self.isNotificationOn = defaults.bool(forKey: UserDefaultsConstants.isNotificationOnKey)
        ///通知時間
        if isNotificationOn{
            self.savedTime = defaults.object(forKey: UserDefaultsConstants.userSettingNotificationTimeKey) as? Date ?? Date()
        }else{
            var components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
            components.hour = 19
            components.minute = 0
            self.savedTime = Calendar.current.date(from: components) ?? Date()
        }
        ///通知曜日
        let array = defaults.object(forKey: UserDefaultsConstants.userSettingNotificationDayKey) as? [Int] ?? []
        // `num` 値のセットから `[Weekday: Bool]` 辞書を作成する
        var newWeekdays: [Weekday: Bool] = [:]
        // 全ての曜日をループして、各曜日が activeWeekdaysNums セット内にあるかどうかをチェック
        for weekday in Weekday.allCases {
            newWeekdays[weekday] = array.contains(weekday.num)
        }
        savedDays = newWeekdays
    }
    
    
    ///アプリの通知設定が許可されているか取得する関数
    func isUserNotificationEnabled(){
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if let error = error { return }
            
            if success {//通知OK
                DispatchQueue.main.async {
                    self.isNotificationEnabled = true
                    self.showNotificationAlert = false
                }
            }else {//通知NG
                DispatchQueue.main.async {
                    self.isNotificationEnabled = false
                    self.showNotificationAlert = true
                }
            }
        }
    }
    
    ///通知のオンオフを切り替えるメソッド
    func switchUserNotification(isOn: Bool){
        self.isNotificationOn = isOn
        defaults.set(isOn, forKey: UserDefaultsConstants.isNotificationOnKey)
    }
    
    
    ///通知を全てキャンセルするメソッド
    func resetNotification(){
        //すべてのスケジュールをキャンセル
        notificationCenter.removeAllPendingNotificationRequests()
        //通知をOFFにして保存
        switchUserNotification(isOn: false)

        //時間を初期化して保存
        var components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        components.hour = 19
        components.minute = 0
        DispatchQueue.main.async {
            self.savedTime = Calendar.current.date(from: components) ?? Date()
            self.savedDays = Weekday.allCases.reduce(into: [Weekday: Bool]()) { $0[$1] = true }
        }
        saveUserSelectedTime()
    }
    
    
    ///通知を送る時間と曜日を保存するメソッド
    func saveUserSelectedTime(){
        defaults.set(savedTime, forKey: "notificationTime")
        // 曜日の状態を配列として保存
        let activeWeekdaysNums = Array(savedDays.filter { $0.value }.map { $0.key.num })
        defaults.set(activeWeekdaysNums, forKey: UserDefaultsConstants.userSettingNotificationDayKey)
    }
    
    ///通知をセットするメソッド（当日のタスクが達成済みなら翌日から開始する）
    func setNotification(isFinishTodaysTask: Bool, time: Date?, days: [Weekday: Bool]?) async{
        
        //通知設定がOFFなら何もせずリターン
        if !isNotificationOn{ return }
        
        // 設定されている曜日のnum値を取得
        let activeWeekdaysNums = Set(savedDays.filter { $0.value }.map { $0.key.num })
        DispatchQueue.main.async{
            //ユーザーが選択した時間を取得（nilなら保存された値を使用する）
            if let time = time{
                self.savedTime = time
            }
            if let days = days{
                self.savedDays = days
            }
        }

        //設定を保存
        saveUserSelectedTime()
        
        //すでに予約されている通知の設定をすべて削除
        notificationCenter.removeAllPendingNotificationRequests()
        
        //通知音と文言の設定
        content.sound = UNNotificationSound.default
        content.title = "100日チャレンジ継続中！"
        content.body = "本日のタスクが未達成です。挑戦を続けて、新たな習慣を築きましょう。"
        
        // 通知時刻を指定
        let component = Calendar.current.dateComponents([.hour, .minute], from: self.savedTime)
        var startDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: Date())
        //今日のタスク完了済みなら明日から
        if isFinishTodaysTask{
            if let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date()) {
                startDate = Calendar.current.dateComponents([.year, .month, .day], from: tomorrow)
            }
        }
        
        //通知を設定する時間のデータを作成
        var dateComponentsDay = DateComponents()
        dateComponentsDay.year = startDate.year
        dateComponentsDay.month = startDate.month
        dateComponentsDay.day = startDate.day
        dateComponentsDay.hour = component.hour
        dateComponentsDay.minute = component.minute
        
        print(dateComponentsDay)
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
                    switchUserNotification(isOn: false)
                }
            }
        }
    }
}

