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
    
    @IBOutlet weak var webView: UIWebView!
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: name)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.backgroundColor = UIColor.clear
        view.backgroundColor = UIColor.clear
        webView.scrollView.minimumZoomScale = 1.0
        webView.scrollView.maximumZoomScale = 1.0
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            if let fullUrl = self?.urlString,
                let url = URL(string: fullUrl){
                let request = URLRequest(url: url)
                self?.webView.loadRequest(request)
            }
        } 
    }
    
    deinit {
        print("deinit GameDetailMasterWebViewController")
    }
    
}
