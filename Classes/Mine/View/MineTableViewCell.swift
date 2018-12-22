//
//  MineTableViewCell.swift
//  Box
//
//  Created by luan on 2018/11/22.
//  Copyright © 2018 luan. All rights reserved.
//

import UIKit

class MineTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
