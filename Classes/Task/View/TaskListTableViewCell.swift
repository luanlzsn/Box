//
//  TaskListTableViewCell.swift
//  Box
//
//  Created by luan on 2018/11/24.
//  Copyright © 2018 luan. All rights reserved.
//

import UIKit

@objc protocol TaskListCellDelegate {
    func receiveTask(section: Int)
}

class TaskListTableViewCell: UITableViewCell {

    @IBOutlet weak var numberBgImage: UIImageView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var statusBtn: UIButton!
    weak var delegate: TaskListCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func didTapReceive(_ sender: UIButton) {
        delegate?.receiveTask(section: tag)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
