//
//  GameDetailMasterWebViewController.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 8/21/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import UIKit
import WebKit
import XLPagerTabStrip

class GameDetailWebViewController: UIViewController, IndicatorInfoProvider {

    var urlString = ""
    var name = ""

    var webView: WKWebView!

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: name)
    }

    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.global().async { [weak self] in
            if let fullUrl = self?.urlString,
                let url = URL(string: fullUrl) {
                let request = URLRequest(url: url)
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                _ = self?.webView.load(request)
            }
        }

    }

    deinit {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

}

extension GameDetailWebViewController: WKUIDelegate {

}

extension GameDetailWebViewController: WKNavigationDelegate {

    func webViewDidStartLoad(_ webView: UIWebView) {

    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
