//
//  WebView.swift
//  WebtoonAssistant_Coredata
//
//  Created by 박규림 on 2021/02/23.
//

import SwiftUI
import WebKit

struct WebView : UIViewRepresentable {
    var urlToLoad : String
    
    func makeUIView(context: Context) -> WKWebView {
        guard let url = URL(string : self.urlToLoad) else {
            return WKWebView()
        }
        
        let webview = WKWebView()
    
        webview.load(URLRequest(url : url))
    
        return webview
    }
    
    func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<WebView>) {
        
    }
}
