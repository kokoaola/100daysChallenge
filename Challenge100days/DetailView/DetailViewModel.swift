//
//  DetailViewModel.swift
//  Challenge100days
//
//  Created by koala panda on 2023/12/27.
//

import Foundation


final class DetailViewModel: ObservableObject{
    var item: DailyData?
    
    ///入力したテキストを格納するプロパティ
    @Published var editText = ""
    
    ///削除ボタン押下後の確認アラート用のフラグ
    @Published var showCansel = false
    
    
    func setItem(item: DailyData){
        self.item = item
    }
    
    var isTextValid: Bool{
        AppSetting.maxLengthOfMemo >= self.editText.count
    }
    
    var isDeleteDataToday: Bool{
        if let item = item{
            let deletedData = Calendar.current.dateComponents([.year, .month, .day], from: item.wrappedDate)
            let today = Calendar.current.dateComponents([.year, .month, .day], from: Date())
            return deletedData == today
        }else{
            return false
        }
    }
    
    
    ///引数で受け取った日のメモを更新するメソッド、データがnilなら最新のメモを更新
    func updateMemo(item: DailyData){
        let oldMemo = item.memo
        
        item.memo = editText
        
        // 変更を保存
        PersistenceController.shared.saveAsync{ error in
            if let _ = error {
                // エラーハンドリング
                item.memo = oldMemo
            }
        }
    }
    
    
    ///引数で受け取ったデータを削除するメソッド
    func deleteData(data: DailyData,  completion: @escaping () -> Void) {
        // 変更を保存
        PersistenceController.shared.deleteAsync(data){ error in
            if let _ = error {
                return
            } else {
                //ウィジェットを更新
                AppGroupConstants.reloadTimelines()
                // 保存成功
                completion()
            }
        }
    }
}
