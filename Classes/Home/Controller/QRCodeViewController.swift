//
//  QRCodeViewController.swift
//  Box
//
//  Created by luan on 2018/11/24.
//  Copyright © 2018 luan. All rights reserved.
//

import UIKit

class QRCodeViewController: LuanViewController {

    @IBOutlet weak var qrCodeImage: UIImageView!
    @IBOutlet var codeArray: [UILabel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let code = LuanManage.userInfo?.code ?? ""
        for i in 0..<codeArray.count {
            if code.count > i {
                codeArray[i].text = code.nsString.substring(with: NSRange(location: i, length: 1))
            } else {
                codeArray[i].text = ""
            }
        }
        qrCodeImage.image = Common.setupQRCodeImage(kBasePath.absoluteString + "regist/registerIndex?code=\((LuanManage.userInfo?.code ?? ""))", size: 140)
    }
    
    @IBAction func didTapCopyShareAddress() {
        let str = kBasePath.absoluteString + "regist/registerIndex?code=\((LuanManage.userInfo?.code ?? ""))"
        UIPasteboard.general.string = str
        view.makeToast("复制成功")
    }

}
