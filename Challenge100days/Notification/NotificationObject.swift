//
//  NotificationObject.swift
//  Challenge100days
//
//  Created by koala panda on 2024/01/10.
//

import Foundation


///通知に関する情報の型
struct NotificationObject: Equatable {
    var date: [Weekday: Bool] 
    var time: Date
    ///時間をフォーマットして返すプロパティ
    var formattedTime: String{
        time.formatAsString()
    }
    ///曜日をフォーマットして返すプロパティ
    var formattedDate: String{
        //activeDaysからtrueのものだけ取り出し、名前を配列に格納
        let activeDays: [Weekday] = date.filter { $0.value == true }.map { $0.key }.sorted(by: { ldate, rdate -> Bool in
            return ldate.num < rdate.num})
        let daysStringArray = activeDays.map { $0.localizedName }
        let daysString = daysStringArray.joined(separator: ", ")
        return daysString
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
