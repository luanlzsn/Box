//
//  PasswordManageTableViewController.swift
//  Box
//
//  Created by luan on 2018/11/26.
//  Copyright © 2018 luan. All rights reserved.
//

import UIKit

class PasswordManageTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PaymentPassword" {
            let password = segue.destination as? PasswordViewController
            password?.isPaymnet = true
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }

}
