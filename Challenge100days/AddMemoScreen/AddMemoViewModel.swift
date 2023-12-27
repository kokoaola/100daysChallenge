//
//  AddMemoViewModel.swift
//  Challenge100days
//
//  Created by koala panda on 2023/12/27.
//

import Foundation


final class AddMemoViewModel: ViewModelBase{
    ///編集文章格納用
    @Published var editText = ""
    
    var isLengthValid: Bool{
        self.editText.count < AppSetting.maxLengthOfMemo
    }
    
    ///引数で受け取った日のメモを更新するメソッド、データがnilなら最新のメモを更新
    func updateDataMemo(data: DailyData? ,completion: @escaping () -> Void) async{
        data?.memo = editText
        
        // 変更を保存
        PersistenceController.shared.saveAsync{_ in
                // 保存成功
                completion()
            }
        }
    }

