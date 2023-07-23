//
//  NotificationViewModel.swift
//  Challenge100days
//
//  Created by koala panda on 2023/07/20.
//

import Swift
import Foundation
import CoreData
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
        self.userSettingNotificationTime = defaults.object(forKey:"notificationTime") as? Date ?? Date()
        let array = defaults.object(forKey:"notificationDay") as? [Int] ?? [1, 2, 3, 4, 5, 6, 7]
        self.userSettingNotificationDay = Set(array)
        self.isNotificationOn = defaults.bool(forKey: "notificationOn")
    }
    
    
    func checkTodaysTask(item: DailyData?) -> Bool{
        guard let item else {return false}
        if Calendar.current.isDate(Date.now, equalTo: item.date ?? Date.now, toGranularity: .day){
            return true
        }else{
            return false
        }
    }
    
    func getAll(){
        let context = DataController()
        let cc = context.container.viewContext
        let req = NSFetchRequest<DailyData>(entityName: "DailyData")
        do{
            let tasks = try cc.fetch(req)
            print(tasks)
        }catch{
            fatalError()
        }
    }
    
    ///通知のオンオフを切り替える
    func switchUserNotification(isOn: Bool){
        defaults.set(isOn, forKey: "notificationOn")
    }
    ///通知を送る時間を保存する
    func saveUserSelectedTime(){
        defaults.set(userSettingNotificationTime, forKey: "notificationTime")
    }
    ///通知を送る時間を取り出す
    func getUserSelectedTime() -> Date{
        return defaults.object(forKey:"notificationTime") as? Date ?? Date()
    }
    ///通知を送る曜日を保存する
    func saveUserSelectedDays(){
        let array = Array(userSettingNotificationDay)
        defaults.set(array, forKey: "notificationDay")
    }
    ///通知を送る曜日を取得する
    func getUserSelectedDays() ->  Set<Int>{
        let array = defaults.object(forKey:"notificationDay") as? [Int] ?? [1, 2, 3, 4, 5, 6, 7]
        return Set(array)
    }
    ///通知を全てキャンセルする
    func resetNotification(){
        notificationCenter.removeAllPendingNotificationRequests()
        switchUserNotification(isOn: false)
        self.userSettingNotificationDay = [1, 2, 3, 4, 5, 6, 7]
        saveUserSelectedDays()
    }
    
    ///通知をセットする
    func setNotification(item: DailyData?){
        resetNotification()
        
        saveUserSelectedDays()
        saveUserSelectedTime()
        
        //日付にひとつもチェックが入っていなければ通知をOFFにしてreturn
        if self.userSettingNotificationDay.isEmpty{
            switchUserNotification(isOn: false)
            return
        }else{
            switchUserNotification(isOn: true)
        }
        
//        print(self.checkTodaysTask(item: item))
        content.sound = UNNotificationSound.default
        // MARK: -
        content.title = "100日チャレンジ継続中！"
        // MARK: -
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
//                    print("Error \(error.localizedDescription)")
                    return
                }
            }
        }
    }
    
}

