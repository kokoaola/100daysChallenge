//
//  NotificationViewModel.swift
//  Challenge100days
//
//  Created by koala panda on 2023/07/20.
//

import NotificationCenter
import SwiftUI


///通知関連のビューモデル
class NotificationViewModel: ObservableObject{
    ///通知を設定する時間を格納する変数
    @Published var userSettingNotificationTime: Date
    ///通知を設定する曜日を格納する変数
    @Published var userSettingNotificationDay: Set<Int>
    ///ユーザーによる通知設定がされているかを格納する変数
    var isNotificationOn: Bool
    ///通知用変数
    let content = UNMutableNotificationContent()
    let notificationCenter = UNUserNotificationCenter.current()
    
    ///ユーザーデフォルト用変数
    private let defaults = UserDefaults.standard
    ///ユーザーデフォルト用キー：通知時間用
    private let userSettingNotificationTimeKey = "notificationTime"
    ///ユーザーデフォルト用キー：通知曜日用
    private let userSettingNotificationDayKey = "notificationDay"
    ///ユーザーデフォルト用キー：通知ON-OFF用
    private let isNotificationOnKey = "isNotificationOn"
    
    
    init(){
        //アプリ起動時はユーザーデフォルトからデータを取得
        self.userSettingNotificationTime = defaults.object(forKey: userSettingNotificationTimeKey) as? Date ?? Date()
        let array = defaults.object(forKey: userSettingNotificationDayKey) as? [Int] ?? [1, 2, 3, 4, 5, 6, 7]
        self.userSettingNotificationDay = Set(array)
        self.isNotificationOn = defaults.bool(forKey: isNotificationOnKey)
    }
    
    ///今日のタスクが終了しているか確認してBool型で返すメソッド
    func checkTodaysTask(item: DailyData?) -> Bool{
        //もしデータが空なら未達成
        guard let item else {return false}
        
        //今日の日付と引数の日付が同日ならtrueを返す
        if Calendar.current.isDate(Date.now, equalTo: item.date ?? Date.now, toGranularity: .day){
            print("今日のタスクは達成済み")
            return true
        }else{
            print("今日のタスクは未達成")
            return false
        }
    }
    
    ///通知のオンオフを切り替えるメソッド
    func switchUserNotification(isOn: Bool){
        self.isNotificationOn = isOn
        defaults.set(isOn, forKey: "notificationOn")
    }
    
    ///通知を送る時間を保存するメソッド
    func saveUserSelectedTime(){
        defaults.set(userSettingNotificationTime, forKey: "notificationTime")
    }
    
    ///通知を送る時間を取り出すメソッド
    func getUserSelectedTime() -> Date{
        return defaults.object(forKey:"notificationTime") as? Date ?? Date()
    }
    
    ///通知を送る曜日を保存するメソッド
    func saveUserSelectedDays(){
        let array = Array(userSettingNotificationDay)
        defaults.set(array, forKey: "notificationDay")
    }
    
    ///通知を送る曜日を取得するメソッド
    func getUserSelectedDays() ->  Set<Int>{
        let array = defaults.object(forKey:"notificationDay") as? [Int] ?? [1, 2, 3, 4, 5, 6, 7]
        return Set(array)
    }
    
    ///通知を全てキャンセルするメソッド
    func resetNotification(){
        notificationCenter.removeAllPendingNotificationRequests()
        switchUserNotification(isOn: false)
        self.userSettingNotificationDay = [1, 2, 3, 4, 5, 6, 7]
        saveUserSelectedDays()
    }
    
    ///通知をセットするメソッド（当日のタスクが達成済みなら翌日から開始する）
    func setNotification(item: DailyData?) async{
        //ユーザーが選択した日時を保存
        saveUserSelectedDays()
        saveUserSelectedTime()
        
        //すでに予約されている通知の設定をすべて削除
        notificationCenter.removeAllPendingNotificationRequests()
        
        //日付にひとつもチェックが入っていなければ通知をOFFにしてreturn
        if self.userSettingNotificationDay.isEmpty{
            switchUserNotification(isOn: false)
            return
        }else{
            switchUserNotification(isOn: true)
        }
        
        content.sound = UNNotificationSound.default
        content.title = "100日チャレンジ継続中！"
        content.body = "本日のタスクが未達成です。挑戦を続けて、新たな習慣を築きましょう。"
        // 通知時刻を指定
        let component = Calendar.current.dateComponents([.hour, .minute], from: self.userSettingNotificationTime)
        
        var setDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
        //今日のタスク完了済みなら明日から
        if self.checkTodaysTask(item: item){
            setDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date().addingTimeInterval(24*60*60))
        }
        
        
        var dateComponentsDay = DateComponents()
        dateComponentsDay.year = setDate.year
        dateComponentsDay.month = setDate.month
        dateComponentsDay.day = setDate.day
        dateComponentsDay.hour = component.hour
        dateComponentsDay.minute = component.minute
        
        var notificationRequests = [UNNotificationRequest]()
        
        // リクエストを作成
        for day in self.userSettingNotificationDay{
            dateComponentsDay.weekday = day  // 1が日曜日、2が月曜日、というように設定
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponentsDay, repeats: true)
            // リクエストを作成
            let uuidStringMonday = UUID().uuidString
            let request = UNNotificationRequest(identifier: uuidStringMonday,content: content, trigger: trigger)
            notificationRequests.append(request)
        }
        
        for notificationRequest in notificationRequests {
            // ローカル通知をスケジュール
            notificationCenter.add(notificationRequest) { (error) in
                if let error = error {
                    print("Error \(error.localizedDescription)")
                    return
                }
            }
        }
    }
}

