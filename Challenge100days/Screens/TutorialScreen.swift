//
//  TutorialView.swift
//  Challenge100days
//
//  Created by koala panda on 2023/02/14.
//

import SwiftUI


///チュートリアル共通項目
struct TutorialScreen: View {
    
    ///ViewModel用の変数
    @EnvironmentObject var store:Store
    @StateObject private var tutorialVM = TutorialViewModel()
    
    
    var body: some View {
        NavigationView {

            VStack{
                //上部のページ番号
                Text("\(tutorialVM.page) / 3")
                    .padding(.top)
                    .font(.title.weight(.bold))
                    .foregroundColor(.primary)
                    .accessibilityLabel("3ページ中、\(tutorialVM.page)ページ目")
                
                //ページに応じたチュートリアルを表示
                switch tutorialVM.page{
                case 1:
                    TutorialView1(tutorialVM: tutorialVM)
                case 2:
                    TutorialView2(tutorialVM: tutorialVM)
                default:
                    TutorialView3(tutorialVM: tutorialVM)
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
            TutorialScreen()
                .environment(\.locale, Locale(identifier:"ja"))
            TutorialScreen()
                .environment(\.locale, Locale(identifier:"en"))
        }
        .environmentObject(Store())
    }
}

