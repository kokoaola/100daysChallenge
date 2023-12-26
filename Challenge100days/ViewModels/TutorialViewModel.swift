//
//  TutorialViewModel.swift
//  Challenge100days
//
//  Created by koala panda on 2023/12/27.
//

import Foundation


class TutorialViewModel: ObservableObject{
    
    ///表示中のページ番号を格納する変数
    @Published var page = 1
    ///入力したテキストを格納するプロパティ
    @Published var longTermEditText = ""
    @Published var shortTermEditText = ""
}
