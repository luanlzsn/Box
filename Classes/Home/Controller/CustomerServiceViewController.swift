//
//  CustomerServiceViewController.swift
//  Box
//
//  Created by luan on 2018/11/24.
//  Copyright © 2018 luan. All rights reserved.
//

import UIKit

class CustomerServiceViewController: LuanViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapCallPhone(_ sender: UITapGestureRecognizer) {
        let alert = UIAlertController(title: "拨打咨询热线", message: "100-200-3000", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (_) in
            UIApplication.shared.open(URL(string: "tel://100-200-3000")!)
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
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
