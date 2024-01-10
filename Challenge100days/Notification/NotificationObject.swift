//
//  NotificationObject.swift
//  Challenge100days
//
//  Created by koala panda on 2024/01/10.
//

import Foundation


///通知に関する情報の型
struct NotificationObject {
    
    ///通知の時間を格納するプロパティ
    var time: Date = Date()
    
    ///通知の曜日を格納するプロパティ
    var dateDic: [Weekday: Bool] = [:]
    
    ///通知の曜日番号を格納するプロパティ
    var dateArray: [Int]{
        dateDic.filter { $0.value == true }.map { $0.key.num }
    }

    ///時間をフォーマットして返すプロパティ
    var formattedTime: String{
        time.formatAsString()
    }
    
    ///曜日を一つのStringにまとめて返すプロパティ
    var formattedDate: String{
        //activeDaysからtrueのものだけ取り出し、名前を配列に格納
        let activeDays: [Weekday] = dateDic.filter { $0.value == true }.map { $0.key }.sorted(by: { ldate, rdate -> Bool in
            return ldate.num < rdate.num})
        
        let daysStringArray = activeDays.map { $0.localizedName }
        let daysString = daysStringArray.joined(separator: ", ")
        return daysString
    }

    ///曜日番号の配列を[Weekday: Bool]型に変換するメソッド
    func getDaysDic(by lowArray: [Int]) -> [Weekday: Bool]{
        // lowArray配列から[Weekday: Bool]辞書を作成する
        var newWeekdays: [Weekday: Bool] = [:]
        // 全ての曜日をループ
        for weekday in Weekday.allCases {
            newWeekdays[weekday] = lowArray.contains(weekday.num)
        }
        return newWeekdays
    }

}


///曜日データ型の定義
enum Weekday: Int, CaseIterable {
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday
    
    var name: String {
        switch self {
        case .sunday: return "日曜"
        case .monday: return "月曜"
        case .tuesday: return "火曜"
        case .wednesday: return "水曜"
        case .thursday: return "木曜"
        case .friday: return "金曜"
        case .saturday: return "土曜"
            
        }
    }
    
    var localizedName: String {
        switch self {
        case .sunday: return NSLocalizedString("日曜", comment: "")
        case .monday: return NSLocalizedString("月曜", comment: "")
        case .tuesday: return NSLocalizedString("火曜", comment: "")
        case .wednesday: return NSLocalizedString("水曜", comment: "")
        case .thursday: return NSLocalizedString("木曜", comment: "")
        case .friday: return NSLocalizedString("金曜", comment: "")
        case .saturday: return NSLocalizedString("土曜", comment: "")
        }
    }
    
    var num: Int {
        switch self {
        case .sunday: return 1
        case .monday: return 2
        case .tuesday: return 3
        case .wednesday: return 4
        case .thursday: return 5
        case .friday: return 6
        case .saturday: return 7
        }
    }
}
