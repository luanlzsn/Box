//
//  FMWebViewController.swift
//  Tocos
//
//  Created by luan on 2018/11/7.
//  Copyright © 2018 luan. All rights reserved.
//

import UIKit
import WebKit
import SwifterSwift
import SnapKit

class LuanWebViewController: LuanViewController {

    var urlStr = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let jScript = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);"
        let wkUScript = WKUserScript(source: jScript, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let wkUController = WKUserContentController()
        wkUController.addUserScript(wkUScript)
        
        let wkWebConfig = WKWebViewConfiguration()
        wkWebConfig.userContentController = wkUController
        
        let webView = WKWebView(frame: CGRect.zero, configuration: wkWebConfig)
        webView.navigationDelegate = self
        view.addSubview(webView)
        webView.load(URLRequest(url: URL(string: urlStr)!))
        view.makeToastActivity(view.center)
        
        webView.snp.makeConstraints { [unowned self] (make) in
            make.centerX.width.top.equalTo(self.view)
            make.bottom.equalTo((SwifterSwift.statusBarHeight == 20) ? 0 : -34)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.hideToastActivity()
    }

}

extension LuanWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        view.hideToastActivity()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        view.hideToastActivity()
    }
}
