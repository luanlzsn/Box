//
//  SubmitTaskCollectionViewCell.swift
//  Box
//
//  Created by luan on 2018/11/25.
//  Copyright © 2018 luan. All rights reserved.
//

import UIKit

@objc protocol SubmitTaskCollectionViewCellDelegate {
    func deletePhoto(row: Int)
}

class SubmitTaskCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var deleteBtn: UIButton!
    weak var delegate: SubmitTaskCollectionViewCellDelegate?
    
    @IBAction func didTapDeletePhoto(_ sender: UIButton) {
        delegate?.deletePhoto(row: tag)
    }
    
}
