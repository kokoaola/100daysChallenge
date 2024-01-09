//
//  Date+Extension.swift
//  LoanTrackerApp
//
//  Created by koala panda on 2023/12/26.
//

import Foundation

///年号だけを取得する拡張機能
extension Date {
    
    /// 日付を特定のフォーマットの文字列に変換するメソッド
    func formatAsString() -> String {
        let formatter = DateFormatter()
        // 時間フォーマットを設定（例: "hh:mm a"）
        formatter.dateFormat = "hh:mm a"
        // 日付を指定したフォーマットの文字列に変換
        return formatter.string(from: self)
    }
}

