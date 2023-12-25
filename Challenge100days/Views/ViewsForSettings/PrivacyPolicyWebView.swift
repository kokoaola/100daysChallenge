//
//  PrivacyPolicyWebView.swift
//  Challenge100days
//
//  Created by koala panda on 2023/05/06.
//


import SwiftUI
import WebKit


///ウェブ上のプライバシーポリシーを表示する
struct PrivacyPolicyWebView: UIViewRepresentable {
    ///URL
    var urlString = "https://kokoaola.github.io/privacyPolicy/privacy100days.html"
    
    func makeUIView(context: Context) -> WKWebView{
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let url = URL(string: urlString)!
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}


struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            PrivacyPolicyWebView()
                .environment(\.locale, Locale(identifier:"en"))
            PrivacyPolicyWebView()
                .environment(\.locale, Locale(identifier:"ja"))
        }
    }
}
