//
//  TutorialView.swift
//  Challenge100days
//
//  Created by koala panda on 2023/02/14.
//

import SwiftUI

struct TutorialTopView: View {
    ///ページ全体のカラー情報を格納
    @AppStorage("colorkeyTop") var storedColorTop: Color = .blue
    @AppStorage("colorkeyBottom") var storedColorBottom: Color = .green
    
    ///現在のページ
    @State var page = 1
    
    
    var body: some View {
        NavigationView {
            
            ///ページに応じたチュートリアルを表示
            VStack{
                Text("\(page) / 3")
                    .padding(.top)
                    .font(.title.weight(.bold))
                    .foregroundColor(.primary)
                
                switch page{
                case 1:
                    TutorialView1(page: $page)
                case 2:
                    TutorialView2(page: $page)
                default:
                    TutorialView3(page: $page)
                }
            }
            
            ///ここからは背景の設定
            .frame(maxHeight: AppSetting.screenHeight / 1.3)
            .background(.thinMaterial)
            .cornerRadius(15)
            
            .padding(.horizontal)
            
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            .userSettingGradient(colors: [storedColorTop, storedColorBottom])
            
        }
        
        .navigationViewStyle(.stack)
    }
}

struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            TutorialTopView()
                .environment(\.locale, Locale(identifier:"ja"))
            TutorialTopView()
                .environment(\.locale, Locale(identifier:"en"))
        }
    }
}

