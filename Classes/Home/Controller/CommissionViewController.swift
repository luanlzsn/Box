//
//  CommissionViewController.swift
//  Box
//
//  Created by luan on 2018/11/24.
//  Copyright © 2018 luan. All rights reserved.
//

import UIKit
import SwifterSwift

class CommissionViewController: LuanViewController {

    @IBOutlet weak var descLabel: YYLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        descLabel.preferredMaxLayoutWidth = SwifterSwift.screenWidth - 24
        
        let attr = NSMutableAttributedString(string: "")
        let stepAttr = NSMutableAttributedString(string: "使用步骤")
        stepAttr.yy_font = UIFont(name: "PingFangSC-Medium", size: 16)
        stepAttr.yy_color = UIColor(hexString: "333333")
        attr.append(stepAttr)
        attr.yy_appendString("\n")
        attr.append(createAttributedString(oneStr: "第一步：", twoStr: "扫码下载APP"))
        attr.append(createAttributedString(oneStr: "第二步：", twoStr: "支付158成红钻VIP；支付328成黄钻VIP；支付498成蓝钻VIP"))
        attr.append(createAttributedString(oneStr: "第三步：", twoStr: "[任务中心]领取任务发朋友圈保留两小时以上"))
        attr.append(createAttributedString(oneStr: "第四步：", twoStr: "[提交任务] 按照任务模板截图上传"))
        attr.append(createAttributedString(oneStr: "第五步：", twoStr: "红钻VIP赚取10元/天；黄钻VIP赚取20元/天；蓝钻VIP赚取30元/天"))
        
        attr.yy_lineSpacing = 10
        descLabel.attributedText = attr
    }
    
    func createAttributedString(oneStr: String, twoStr: String) -> NSMutableAttributedString {
        let attr = NSMutableAttributedString(string: "")
        let oneAttr = NSMutableAttributedString(string: oneStr)
        oneAttr.yy_color = kMainColor
        
        let twoAttr = NSMutableAttributedString(string: twoStr)
        twoAttr.yy_color = UIColor(hexString: "333333")
        
        attr.append(oneAttr)
        attr.append(twoAttr)
        attr.yy_font = UIFont.systemFont(ofSize: 15)
        attr.yy_appendString("\n")
        
        return attr
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
