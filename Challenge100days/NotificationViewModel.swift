//
//  NotificationViewModel.swift
//  Challenge100days
//
//  Created by koala panda on 2023/07/20.
//

import Swift
import Foundation
import Combine
import NotificationCenter
import SwiftUI

class NotificationViewModel: ObservableObject{
    @Published var userSettingNotificationTime: Date
    @Published var userSettingNotificationDay: Set<Int>
    let isNotificationOn: Bool
    private let defaults = UserDefaults.standard
    let content = UNMutableNotificationContent()
    let notificationCenter = UNUserNotificationCenter.current()
    
    init(){
        self.userSettingNotificationTime = Date()
        self.userSettingNotificationDay = Set(1...7)
        self.isNotificationOn = defaults.bool(forKey: "notificationOn")
    }

    
    func checkTodaysTask(item: DailyData?) -> Bool{
//    func checkTodaysTask(items: FetchedResults<DailyData>) -> Bool{
        ///アプリ起動時に今日のミッションがすでに完了しているか確認
//        let todaysData = items.filter{
//            ///CoreDataに保存されたデータの中に今日と同じ日付が存在するか確認
//            Calendar.current.isDate(Date.now, equalTo: $0.date ?? Date.now, toGranularity: .day)
//        }
        ///もし同日が存在していたら完了フラグをTrueにする
//        if todaysData.isEmpty{
//            return false
//        }else{
//            return true
//        }
        guard let item else {return false}
        if Calendar.current.isDate(Date.now, equalTo: item.date ?? Date.now, toGranularity: .day){
            return true
        }else{
            return false
        }
    }
    
    ///通知のオンオフを切り替える
    func switchUserNotification(isOn: Bool){
        defaults.set(isOn, forKey: "notificationOn")
    }
    ///通知を送る時間を保存する
    func saveUserSelectedTime(time: Date){
        defaults.set(time, forKey: "notificationTime")
    }
    ///通知を送る時間を取り出す
    func getUserSelectedTime() async -> Date{
        return defaults.object(forKey:"notificationTime") as? Date ?? Date()
    }
    ///通知を送る曜日を保存する
    func saveUserSelectedDays(day: Set<Int>){
        defaults.set(day, forKey: "notificationDay")
    }
    ///通知を送る曜日を取得する
    func getUserSelectedDays() ->  Set<Int>{
        return defaults.object(forKey:"notificationDay") as?  Set<Int> ?? []
    }
    ///通知を全てキャンセルする
    func resetNotification(){
        notificationCenter.removeAllPendingNotificationRequests()
    }
    
    ///通知をセットする
    func setNotification(item: DailyData?){
        resetNotification()
        
        //日付にひとつもチェックが入っていなければ通知をOFFにしてreturn
        if self.userSettingNotificationDay.isEmpty{
            switchUserNotification(isOn: false)
            return
        }else{
            switchUserNotification(isOn: true)
        }
        
        print(self.checkTodaysTask(item: item))
        content.sound = UNNotificationSound.default
        // MARK: -
        content.title = "100日チャレンジ継続中！"
        // MARK: -
        content.body = "今日のタスクを達成させよう"
        // 通知時刻を指定
        let component = Calendar.current.dateComponents([.hour, .minute], from: self.userSettingNotificationTime)

        var setDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
        //今日のタスク完了済みなら明日から
//        if self.checkTodaysTask(items: items){
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
                }
            }
        }
    }
    
}

