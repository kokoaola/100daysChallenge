//
//  Privacy.swift
//  Challenge100days
//
//  Created by koala panda on 2023/05/06.
//


import SwiftUI
import WebKit

struct Privacy: View{
    var body: some View {
        WebView(urlString: "https://kokoaola.github.io")
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
