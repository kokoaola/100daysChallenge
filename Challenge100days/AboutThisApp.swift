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
    
    let about = "アプリをインストールしてくださって、ありがとうございます。\nこのアプリは、目標に向かって進む人を応援、お手伝いしたいという思いで作りました。\n特徴としては以下の2点があります。"
    
    let headline1 = "①100日までのカウントアップ機能"
    let string1 = "コンプリートボタンを押すことで、開始してから100日に到達するまでカウントし続けます。\n毎日カウントが可能ですが、連続で取り組まないとダメという機能は備わっていません。\n極端な話、1週間休んでも1ヶ月休んでも、再開してボタンを押せば問題なく記録が積み上がるように設計されています。\n100日は意外と長い道のりです。\nその中で、心と体を守りながら続けていくことこそ1番大切だと思います。\n\nあなたは、何か新しいことに挑戦しようと考え、しかも実際に行動に移しています。\nそれだけでも賞賛に値する大変素晴らしいことです。\n\n休んだからといって、積み上げた努力がゼロになることなんてありません。\nいつでもまた戻って再開すれば問題ないのです。\n休むことを挫折と捉えないでください。\n\nこのアプリの中では完璧主義を忘れて、「今日はできた！」の完了主義で取り組んでもらえれば嬉しいです。"
    
    let headline2 = LocalizedStringKey("②シェア用オリジナル画像の生成")
    let string2 = LocalizedStringKey("よく言われることですが、SNSで世界に公開しながら何かに取り組むと、挫折しづらくなるそうです。\n\nその手助けになればと思い、シェア用の画像の生成機能をつけました。宣伝っぽくなるのが少し嫌でアプリ名とかは入ってませんので、気軽に共有してください。\n\n写真は全てunsplashという素材サイトからお借りし、二次加工・再配布OKという利用規約の元で使用しております。(写真の撮影者様のクレジットのみ記載してあります。)\n\n\n初めてのリリースでまだ未熟な点の多いアプリですが、ご意見などありましたらお問い合わせフォームから気軽にご連絡ください。")
    
    var body: some View {
        ///ページに応じたチュートリアルを表示
        ScrollView{
            VStack(alignment: .leading){
                
                
                Text(LocalizedStringKey(about))
                    .padding(.vertical, 30)
                
                
                
                Text(LocalizedStringKey(headline1))
                    .font(.headline)
                    .padding(.bottom, 5)
                
                Text(LocalizedStringKey(string1))
                    .padding(.bottom, 30)
                
                
                
                Text(headline2)
                    .font(.headline)
                //                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 5)
                
                
                Text(string2)
                    .padding(.bottom, 30)
            }
            
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
//        .multilineTextAlignment(.leading)
        .foregroundColor(.primary)
        .background(.thinMaterial)
        .cornerRadius(15)
        
        .padding(.horizontal)
        .userSettingGradient(colors: [storedColorTop, storedColorBottom])
        .navigationTitle("このアプリについて")
    }
}




struct AboutThisApp_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            AboutThisApp()
                .environment(\.locale, Locale(identifier:"en"))
            AboutThisApp()
                .environment(\.locale, Locale(identifier:"ja"))
        }
    }
}
