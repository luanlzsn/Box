//
//  MyTaskTableViewCell.swift
//  Box
//
//  Created by luan on 2018/11/25.
//  Copyright © 2018 luan. All rights reserved.
//

import UIKit

class MyTaskTableViewCell: UITableViewCell {
    
    @IBOutlet weak var numberBgImage: UIImageView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var submitBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func didTapSubmit(_ sender: UIButton) {
        yy_viewController?.performSegue(withIdentifier: "SubmitTask", sender: tag)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
