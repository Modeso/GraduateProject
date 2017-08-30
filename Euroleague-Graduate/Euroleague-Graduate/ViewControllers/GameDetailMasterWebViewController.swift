//
//  GameDetailMasterWebViewController.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 8/21/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class GameDetailMasterWebViewController: UIViewController, IndicatorInfoProvider {

    var urlString = ""
    var name = ""
    
//    @IBOutlet weak var webView: UIWebView!
    
    private var isFirst = true
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: name)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        webView.backgroundColor = UIColor.clear
//        view.backgroundColor = UIColor.clear
//        webView.scalesPageToFit = true
//        webView.scrollView.delegate = self
//        webView.delegate = self
//        webView.scrollView.isScrollEnabled = false
//        DispatchQueue.global().async { [weak self] in
//            if let fullUrl = self.urlString,
//                let url = URL(string: urlString)
//                let request = URLRequest(url: url!)
//                self.webView.loadRequest(request)
        
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isFirst {
            isFirst = false
//
        }
        
    }
    
    deinit {
        print("deinit GameDetailMasterWebViewController")
    }
    
}

extension GameDetailMasterWebViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return nil
    }
}

extension GameDetailMasterWebViewController: UIWebViewDelegate {
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        webView.scrollView.isScrollEnabled = true
    }
    
}
