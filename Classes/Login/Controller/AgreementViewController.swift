//
//  AgreementViewController.swift
//  Box
//
//  Created by luan on 2018/11/21.
//  Copyright © 2018 luan. All rights reserved.
//

import UIKit
import WebKit
import SwifterSwift

class AgreementViewController: LuanViewController {

    var webView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.frame = CGRect(x: 0, y: 0, width: SwifterSwift.screenWidth, height: (SwifterSwift.screenHeight - SwifterSwift.statusBarHeight - (SwifterSwift.statusBarHeight == 20 ? 0 : 34)))
        webView.backgroundColor = UIColor.white
        view.addSubview(webView)
        let path = Bundle.main.path(forResource: "圆子盒用户服务及免责条款", ofType: "doc")
        let url = URL(fileURLWithPath: path!)
        webView.loadFileURL(url, allowingReadAccessTo: url)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
