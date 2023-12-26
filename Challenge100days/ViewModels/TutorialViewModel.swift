//
//  TutorialViewModel.swift
//  Challenge100days
//
//  Created by koala panda on 2023/12/27.
//

import Foundation


class TutorialViewModel: ViewModelBase{
    ///表示中のページ番号を格納する変数
    @Published var page = 1
    
    ///入力したテキストを格納するプロパティ
    @Published var longTermEditText = ""
    @Published var shortTermEditText = ""
    
    ///UIの状態を判別するプロパティ
    //２つのテキストフィールドが両方とも空白ではないことを判別するプロパティ
    var isTextFieldNotEmpty: Bool{
        !self.longTermEditText.isEmpty && !self.shortTermEditText.isEmpty
    }
    //長期目標が指定された文字数以下であることを判別するプロパティ
    var isLongTermLengthValid: Bool{
        self.longTermEditText.count <= AppSetting.maxLengthOfTerm
    }
    //短期目標が指定された文字数以下であることを判別するプロパティ
    var isShortTermLengthValid: Bool{
        self.shortTermEditText.count <= AppSetting.maxLengthOfTerm
    }
    //２つの目標が指定された文字数以下であることを判別するプロパティ
    var isTermsLengthValid: Bool{
        return isLongTermLengthValid && isShortTermLengthValid
    }
    //すべての条件が満たされて次へボタンが有効であることを判別するプロパティ
    var isNextButtonNotFade: Bool{
        self.isTextFieldNotEmpty && self.isTermsLengthValid
    }
    //すべての条件が満たされて次へボタンが有効であることを判別するプロパティ
    var isNextButtonValid: Bool{
        self.longTermEditText.isEmpty || self.shortTermEditText.isEmpty || isLongTermLengthValid || isShortTermLengthValid
    }
    
    
    ///すでに保存された目標をテキストフィールドの初期値に設定
    func setTermToTextField(){
        self.longTermEditText = longTermGoal
        self.shortTermEditText = shortTermGoal
    }
    
    ///入力された目標をユーザーデフォルトに保存する関数
    func saveTerm(){
        longTermGoal = longTermEditText
        shortTermGoal = shortTermEditText
    }
}
