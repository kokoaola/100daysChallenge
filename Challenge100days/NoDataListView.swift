//
//  NoDataListView.swift
//  Challenge100days
//
//  Created by koala panda on 2023/03/23.
//

import SwiftUI

struct NoDataListView: View {

    var body: some View {
        
        
        VStack(spacing: 5){
            
                
                    
                    HStack{
                        
                        
                        ///メモの内容を表示（プレビュー用のため改行はスペースに変換）
                        VStack(alignment: .leading){
                            Text("まだデータがありません")
                                .lineSpacing(1)
                                .multilineTextAlignment(.leading)
                                .foregroundColor(Color(UIColor.label))
                            
                            
                        }.font(.footnote)
                        
                    }
                    ///１行あたり最大150pxまで大きくなれる
                    .frame(maxHeight: 150)
                    .fixedSize(horizontal: false, vertical: true)
                    
                
                
                
        }
        
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
