//
//  NoDataListView.swift
//  Challenge100days
//
//  Created by koala panda on 2023/03/23.
//

import SwiftUI

struct NoDataListView: View {
    
    var body: some View {
        
        
        
        ///メモの内容を表示（プレビュー用のため改行はスペースに変換）
        VStack(alignment: .center){
            Text("まだデータがありません")
                .lineSpacing(1)
                .foregroundColor(Color(UIColor.label))
        }
        ///１行あたり最大150pxまで大きくなれる
            .frame(maxWidth: .infinity, alignment: .leading)
            .fixedSize(horizontal: false, vertical: true)
            .padding()
            .background(.thinMaterial)
            .cornerRadius(15)
        
    }
}


struct NoDataListView_Previews: PreviewProvider {
    static var previews: some View {
        NoDataListView()
    }
}
