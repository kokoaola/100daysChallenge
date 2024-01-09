//
//  NotificationModel.swift
//  Challenge100days
//
//  Created by koala panda on 2024/01/02.
//

import Foundation

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
