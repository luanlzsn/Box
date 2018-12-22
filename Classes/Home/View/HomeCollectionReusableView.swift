//
//  HomeCollectionReusableView.swift
//  Box
//
//  Created by luan on 2018/12/5.
//  Copyright © 2018 luan. All rights reserved.
//

import UIKit
import SDCycleScrollView
import SwifterSwift

class HomeCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var bannerView: SDCycleScrollView!
    @IBOutlet weak var bgView: UIView!
    var isRefresh = false
    
    func checkNotice(text: String) {
        if text.isEmpty == false, isRefresh == false {
            isRefresh = true
            let noticeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: bgView.width, height: bgView.height))
            noticeLabel.textColor = UIColor(hexString: "666666")
            noticeLabel.font = UIFont.systemFont(ofSize: 15)
            bgView.addSubview(noticeLabel)
            noticeLabel.text = text
            noticeLabel.sizeToFit()
            //开始动画
            UIView.beginAnimations("Marquee", context: nil)
            UIView.setAnimationDuration(20.0)
            UIView.setAnimationCurve(.linear)
            UIView.setAnimationRepeatAutoreverses(false)
            UIView.setAnimationRepeatCount(HUGE)
            
            var frame = noticeLabel.frame
            frame.origin.x = -frame.size.width
            frame.size.height = bgView.height
            noticeLabel.frame = frame
            
            //与begin对应,结束动画
            UIView.commitAnimations()
        }
    }
        
}
