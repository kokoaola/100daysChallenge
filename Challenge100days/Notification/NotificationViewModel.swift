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
    ///通知用変数
    let content = UNMutableNotificationContent()
    let notificationCenter = UNUserNotificationCenter.current()
    
    ///通知を送る時間を格納する変数
    @Published var userSettingNotificationTime: Date
    ///通知を送る曜日を格納する変数
    @Published var userSettingNotificationDays = Weekday.allCases.reduce(into: [Weekday: Bool]()) { $0[$1] = true }
    @Published var selectAllDays = true
    
    ///ユーザーが通知を設定したかを格納する変数
    var isNotificationOn: Bool
    
    ///端末設定でアプリの通知許可がONになっているかの状態の格納用変数
    @Published var isNotificationEnabled = false
    ///通知をお願いするアラート表示用のフラグ（設定画面への遷移ボタン）
    @Published var showNotificationAlert = false
    
    ///ユーザーデフォルト用変数
    private let defaults = UserDefaults.standard
    
    
    init(){
        self.isNotificationOn = defaults.bool(forKey: UserDefaultsConstants.isNotificationOnKey)
        
        if isNotificationOn{
            self.userSettingNotificationTime = defaults.object(forKey: UserDefaultsConstants.userSettingNotificationTimeKey) as? Date ?? Date()
        }else{
            var components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
            components.hour = 19
            components.minute = 0
            self.userSettingNotificationTime = Calendar.current.date(from: components) ?? Date()
        }
        
        //アプリ起動時はユーザーデフォルトからデータを取得
        let array = defaults.object(forKey: UserDefaultsConstants.userSettingNotificationDayKey) as? [Int] ?? []
        //保存されたデータを読み込む
        // `num` 値のセットから `[Weekday: Bool]` 辞書を作成する
        var newWeekdays: [Weekday: Bool] = [:]
        // 全ての曜日をループして、各曜日が activeWeekdaysNums セット内にあるかどうかをチェック
        for weekday in Weekday.allCases {
            newWeekdays[weekday] = array.contains(weekday.num)
        }
        userSettingNotificationDays = newWeekdays
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
        defaults.set(isOn, forKey: "notificationOn")
    }
    
    ///通知を送る時間と曜日を保存するメソッド
    func saveUserSelectedTime(){
        defaults.set(userSettingNotificationTime, forKey: "notificationTime")
        // 曜日の状態をIntとBoolのペアの配列として保存
        let weekdaysStatusToSave = userSettingNotificationDays.map { ["weekday": $0.key.rawValue, "status": $0.value] as [String : Any] }
        defaults.set(weekdaysStatusToSave, forKey: UserDefaultsConstants.userSettingNotificationDayKey)
    }
    
    ///通知を全てキャンセルするメソッド
    func resetNotification(){
        notificationCenter.removeAllPendingNotificationRequests()
        switchUserNotification(isOn: false)

        var components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        components.hour = 19
        components.minute = 0
        DispatchQueue.main.async {
            
            self.userSettingNotificationTime = Calendar.current.date(from: components) ?? Date()
            self.userSettingNotificationDays = Weekday.allCases.reduce(into: [Weekday: Bool]()) { $0[$1] = false }
        }
        saveUserSelectedTime()
    }
    
    /// すべての曜日の状態をチェックし、selectAllを更新する関数
    func checkAndUpdateSelectAll() {
        let allSelected = Weekday.allCases.allSatisfy { weekday in
            userSettingNotificationDays[weekday] ?? false
        }
        
        let noneSelected = Weekday.allCases.allSatisfy { weekday in
            !(userSettingNotificationDays[weekday] ?? false)
        }
        
        if allSelected {
            selectAllDays = true
        } else if noneSelected {
            selectAllDays = false
        }
    }
    
    
    ///通知をセットするメソッド（当日のタスクが達成済みなら翌日から開始する）
    func setNotification(isFinishTodaysTask: Bool) async{
        // 設定されている曜日のnum値を格納するセットを作成
        let activeWeekdaysNums = Set(userSettingNotificationDays.filter { $0.value }.map { $0.key.num })
        //曜日が選択されていなければ通知を全てキャンセル
        if activeWeekdaysNums.isEmpty{
            resetNotification()
            return
        }else{
            //ユーザーが選択した日時を保存
            saveUserSelectedTime()
        }
        
        //すでに予約されている通知の設定をすべて削除
        notificationCenter.removeAllPendingNotificationRequests()
        
        //通知音と文言の設定
        content.sound = UNNotificationSound.default
        content.title = "100日チャレンジ継続中！"
        content.body = "本日のタスクが未達成です。挑戦を続けて、新たな習慣を築きましょう。"
        
        // 通知時刻を指定
        let component = Calendar.current.dateComponents([.hour, .minute], from: self.userSettingNotificationTime)
        var startDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: Date())
        //今日のタスク完了済みなら明日から
        if isFinishTodaysTask{
            if let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date()) {
                startDate = Calendar.current.dateComponents([.year, .month, .day], from: tomorrow)
                print(startDate)
            }
        }
        
        //通知を設定する時間のデータを作成
        var dateComponentsDay = DateComponents()
        dateComponentsDay.year = startDate.year
        dateComponentsDay.month = startDate.month
        dateComponentsDay.day = startDate.day
        dateComponentsDay.hour = component.hour
        dateComponentsDay.minute = component.minute
        
        
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
                    switchUserNotification(isOn: true)
                } catch {
                    switchUserNotification(isOn: false)
                }
            }
        }
    }
}

