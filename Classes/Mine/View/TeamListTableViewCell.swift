//
//  TeamListTableViewCell.swift
//  Box
//
//  Created by luan on 2018/11/26.
//  Copyright © 2018 luan. All rights reserved.
//

import UIKit

class TeamListTableViewCell: UITableViewCell {

    @IBOutlet weak var avaterImage: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var levelImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
