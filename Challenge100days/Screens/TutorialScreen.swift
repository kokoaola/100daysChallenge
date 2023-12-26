//
//  TutorialView.swift
//  Challenge100days
//
//  Created by koala panda on 2023/02/14.
//

import SwiftUI


///チュートリアル共通項目
struct TutorialTopView: View {
    
    ///ViewModel用の変数
    @EnvironmentObject var store:Store

    ///表示中のページ番号を格納する変数
    @State private var page = 1
    
    
    var body: some View {
        NavigationView {
            

            VStack{
                //上部のページ番号
                Text("\(page) / 3")
                    .padding(.top)
                    .font(.title.weight(.bold))
                    .foregroundColor(.primary)
                    .accessibilityLabel("3ページ中、\(page)ページ目")
                
                //ページに応じたチュートリアルを表示
                switch page{
                case 1:
                    TutorialView1(page: $page)
                case 2:
                    TutorialView2(page: $page)
                default:
                    TutorialView3(page: $page)
                }
            }
            .foregroundColor(.primary)
            .environmentObject(store)
            
            //背景の設定
            .frame(maxHeight: AppSetting.screenHeight / 1.3)
            .background(.thinMaterial)
            .cornerRadius(15)
            .padding(.horizontal)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .modifier(UserSettingGradient(appColorNum: store.userSelectedColor))
            //背景の設定ここまで
            
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
        .environmentObject(Store())
    }
}

