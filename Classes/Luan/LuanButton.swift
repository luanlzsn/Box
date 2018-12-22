//
//  FMButton.swift
//  Tocos
//
//  Created by luan on 2018/11/9.
//  Copyright © 2018 luan. All rights reserved.
//

import UIKit

class LuanButton: UIButton {

    var padding: CGFloat = 2.5 {
        didSet {
            layoutIfNeeded()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel?.frame.origin.x = (width - (titleLabel?.frame.size.width)! - (imageView?.frame.size.width)! - padding) / 2.0
        imageView?.frame.origin.x = titleLabel!.frame.size.width + titleLabel!.frame.origin.x + padding
    }
}
