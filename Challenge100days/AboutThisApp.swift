//
//  AboutThisApp.swift
//  Challenge100days
//
//  Created by koala panda on 2023/02/15.
//

import SwiftUI

struct AboutThisApp: View {
    ///ページ全体のカラー情報を格納
    @AppStorage("colorkeyTop") var storedColorTop: Color = .blue
    @AppStorage("colorkeyBottom") var storedColorBottom: Color = .green
    
    var body: some View {
        ///ページに応じたチュートリアルを表示
        VStack{

            
            Text("AAA")
            
        }
        
        ///ここからは背景の設定
        .frame(maxWidth: .infinity, maxHeight: AppSetting.screenHeight / 1.3)
        .background(.thinMaterial)
        .cornerRadius(15)
        
        .padding(.horizontal)
        
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.secondary)
        .foregroundStyle(
            .linearGradient(
                colors: [storedColorTop, storedColorBottom],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
}

struct AboutThisApp_Previews: PreviewProvider {
    static var previews: some View {
        AboutThisApp()
    }
}
