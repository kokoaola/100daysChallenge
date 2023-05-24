//
//  Privacy.swift
//  Challenge100days
//
//  Created by koala panda on 2023/05/06.
//


import SwiftUI
import WebKit

struct Privacy: View{
    
    ///キーボードフォーカス用変数（Doneボタン表示のため）
    @FocusState var isInputActive: Bool
    
    ///画面破棄用
    @Environment(\.dismiss) var dismiss
    
    ///編集文章格納用
    @State var string = ""
    
    @AppStorage("colorkeyTop") var storedColorTop: Color = .blue
    @AppStorage("colorkeyBottom") var storedColorBottom: Color = .green
    
    @ObservedObject  var messageAlert = MessageBalloon()
    
    var aaa: Bool{
        return isInputActive
    }
    
    var body: some View {
       // WebView(urlString: "https://kokoaola.github.io")
        VStack(alignment: .leading, spacing: 20){
            Text("次に、目標を設定してください。")
            
            
            
            ///短期目標
            VStack(alignment: .leading){
                Text("②その実現のために１００日間取り組むことはなんですか？")
                    .frame(minHeight: 60)
                // .fixedSize(horizontal: false, vertical: true)
                ZStack(alignment: .topLeading){
                    
                    ///テキストエディター
                    TextEditor(text: $string)
                        .foregroundColor(Color(UIColor.label))
                        .scrollContentBackground(Visibility.hidden)
                        .background(.ultraThinMaterial)
                        .border(.white, width: 1)
                        .focused($isInputActive)
                        .padding()
                }
            }
            
        }
        
        .frame(minHeight: AppSetting.screenHeight/1.6)
        
        
        VStack{
            //if !aaa{
                Text("このアプリにはデータを外部に保存する機能はありません。\nデータを消して最初から新しく始める際など、これまでの記録を残しておきたい場合は、このページからコピーしてデバイスへ保存をお願いいたします。")
                    .foregroundColor(.primary)
                    .padding([.top, .vertical])
                    .ignoresSafeArea(edges: .top)
           // }
            //.frame(minHeight: 0)
            
            
            ZStack {
                ///テキストエディター
                TextEditor(text: $string)
                    .foregroundColor(Color(UIColor.label))
                    .scrollContentBackground(Visibility.hidden)
                    .background(.ultraThinMaterial)
                    .border(.white, width: 1)
                    .focused($isInputActive)
                    .padding()
                
                if (messageAlert.isPreview){
                    Text("コピーしました")
                        .font(.system(size: 25))
                        .padding()
                        .background(.gray)
                        .frame(height: 300)
                        .foregroundColor(.white)
                        .opacity(messageAlert.castOpacity())
                        .cornerRadius(5)
                        .offset(x: -5, y: -20)
                }
                
            } // ZStack
            .frame(maxHeight: .infinity, alignment: .top)
            
            
            
        }
        .navigationTitle(Text("バックアップ"))
        ///グラデーション背景設定
        .background(.ultraThinMaterial)
        .userSettingGradient(colors: [storedColorTop, storedColorBottom])
//        .background(.secondary)
//        .foregroundStyle(
//            .linearGradient(
//                colors: [storedColorTop, storedColorBottom],
//                startPoint: .topLeading,
//                endPoint: .bottomTrailing
//            )
//        )
        .ignoresSafeArea()
        
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("閉じる") {
                    isInputActive = false
                }
            }
            
        }
        
        
    }
}

struct WebView: UIViewRepresentable {
    var urlString: String
    //"https://kokoaola.github.io" //表示するWEBページのURLを指定
    
    func makeUIView(context: Context) -> WKWebView{
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let url = URL(string: urlString)!
        let request = URLRequest(url: url)
        //uiView.loadHTMLString(html, baseURL: nil)
        uiView.load(request)
    }
}

struct Privacy_Previews: PreviewProvider {
    static var previews: some View {
        Privacy()
    }
}
