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
        ScrollView{
            VStack{
                
                Text("""


アプリをインストールしてくださって、ありがとうございます。
このアプリは、目標に向かって進む人を応援、お手伝いしたいという思いで作りました。

特徴としては以下の2点があります。


""").font(.body)
                
                Text("①100日までのカウントアップ機能")
                
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 10)
                
                
                Text("""
コンプリートボタンを押すことで、開始してから100日に到達するまでカウントし続けます。
毎日カウントが可能ですが、連続で取り組まないとダメという機能は備わっていません。
極端な話、1週間休んでも1ヶ月休んでも、再開してボタンを押せば問題なく記録が積み上がるように設計されています。
                 
100日は意外と長い道のりです。
その中で、心と体を守りながら続けていくことこそ1番大切だと思います。
                 
あなたは、何か新しいことに挑戦しようと考え、しかも実際に行動に移しています。
それだけでも賞賛に値する大変素晴らしいことです。
                 
休んだからといって、積み上げた努力がゼロになることなんてありません。
いつでもまた戻って再開すれば問題ないのです。
休むことを挫折と捉えないでください。

このアプリの中では完璧主義を忘れて、「今日はできた！」の完了主義で取り組んでもらえれば嬉しいです。


""")
                
                
                Text("②シェア用オリジナル画像の生成")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 10)
                
                
                Text("""
よく言われることですが、SNSで世界に公開しながら何かに取り組むと、挫折しづらくなるそうです。

その手助けになればと思い、シェア用の画像の生成機能をつけました。
宣伝っぽくなるのが少し嫌でアプリ名とかは入ってませんので、気軽に共有してください。

写真は全てunsplashという素材サイトからお借りし、二次加工・再配布OKという利用規約の元で使用しております。
(写真の撮影者様のクレジットのみ記載してあります。)


初めてのリリースでまだ未熟な点の多いアプリですが、ご意見などありましたらお問い合わせフォームから気軽にご連絡ください。



"""
                )
            }
            //.padding(.horizontal)
        }
        //.background()
        .multilineTextAlignment(.leading)
        //.padding(.horizontal, 5)
        //.frame(width: AppSetting.screenWidth * 0.9)
        //.font(.body)
        .foregroundColor(.primary)
        //.padding(.top, 50)
        ///ここからは背景の設定
        //        .frame(maxWidth: .infinity, maxHeight: AppSetting.screenHeight / 1.3)
        //        .background(.thinMaterial)
        //        .cornerRadius(15)
        
        .padding(.horizontal)
        .userSettingGradient(colors: [storedColorTop, storedColorBottom])
//        .background(.secondary)
//        .foregroundStyle(
//            .linearGradient(
//                colors: [storedColorTop, storedColorBottom],
//                startPoint: .topLeading,
//                endPoint: .bottomTrailing
//            )
//        )
        .navigationTitle("このアプリについて")
    }
}

struct AboutThisApp_Previews: PreviewProvider {
    static var previews: some View {
        AboutThisApp()
    }
}
