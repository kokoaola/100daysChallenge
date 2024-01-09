//
//  MakeNewItemViewModel.swift
//  Challenge100days
//
//  Created by koala panda on 2023/12/27.
//

import Foundation


final class MakeNewItemViewModel: ObservableObject{
    
    ///入力したテキストを格納するプロパティ
    @Published var editText = ""
    
    ///選択された日付を格納するプロパティ
    @Published var userSelectedDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
    
    ///編集時のデータピッカー用の変数（未来のデータは追加できないようにするため）
    var dateClosedRange : ClosedRange<Date>{
        let min = Calendar.current.date(byAdding: .year, value: -10, to: Date())!
        let max = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        return min...max
    }
    
    ///選択された日付が有効か判定するプロパティ
    @Published var isVailedDate = false
    
    func isValidDate(allData: [DailyData], checkDate: Date){
        for item in allData{
            if Calendar.current.isDate(item.date!, equalTo: checkDate , toGranularity: .day){
                isVailedDate = false
                return
            }
        }
        //ダブりがなければisVailedをTrueにしてリターン
        isVailedDate = true
    }
    
    var isTextLengthValid: Bool{
         AppSetting.maxLengthOfMemo >= editText.count
    }
    
    var isSaveButtonValid: Bool{
        isTextLengthValid && isVailedDate
    }
    
    ///選択された日付の完了を保存するメソッド
    func saveTodaysChallenge(challengeDate: Int, completion: @escaping (Bool) -> Void) {
        //データのインスタンス生成
        let entity = DailyData(context: PersistenceController.shared.moc)
        entity.id = UUID()
        entity.date = self.userSelectedDate
        entity.memo = self.editText
        entity.num = Int16(challengeDate)
        
        // 変更を保存
        PersistenceController.shared.saveAsync { error in
            if let _ = error {
                // エラーハンドリング
                completion(false)
            } else {
                //ウィジェットを更新
                AppGroupConstants.reloadTimelines()
                // 保存成功
                completion(true)
            }
        }
    }
}
