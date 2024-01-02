//
//  Contact.swift
//  Challenge100days
//
//  Created by koala panda on 2023/05/06.
//

import SwiftUI
import WebKit


///コンタクト用のフォームをHTMLで直接表示する
struct ContactWebView: UIViewRepresentable {
    let html = """
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1.0, user-scaleble=no" />
<style> body { font-size: 150%; } </style>
</head>
<body>

<iframe src="https://docs.google.com/forms/d/e/1FAIpQLSe-be31H9hOUG3Aa6SzyHygmJi7MnosddohuFbpcRELb77P7Q/viewform?embedded=true" width="100%" height="1000" frameborder="0" marginheight="0" marginwidth="0">読み込んでいます…</iframe>
</body>
</html>
"""
    
    func makeUIView(context: Context) -> WKWebView{
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(html, baseURL: nil)
    }
}



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



struct Contact_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            ContactWebView()
                .environment(\.locale, Locale(identifier:"en"))
            ContactWebView()
                .environment(\.locale, Locale(identifier:"ja"))
        }
    }
}
