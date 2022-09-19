//
//  WebViewController.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 9/20/22.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    var webView: WKWebView!
    var destinationURL: String = ""
    
    override func loadView() {
        let webConfig = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfig)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = webView

        DispatchQueue.main.async {
            self.openWebPage(url: self.destinationURL)
        }
    }

    func openWebPage(url: String) {
        guard let newsurl = URL(string: destinationURL) else { return }
        let request = URLRequest(url: newsurl)
        webView.load(request)
    }

}
