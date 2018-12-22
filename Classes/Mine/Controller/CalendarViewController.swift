//
//  CalendarViewController.swift
//  Box
//
//  Created by luan on 2018/11/25.
//  Copyright © 2018 luan. All rights reserved.
//

import UIKit

class CalendarViewController: LuanViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    var confirm: ConfirmBlock?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(white: 0, alpha: 0.3)
        datePicker.maximumDate = Date()
    }
    
    @IBAction func didTapCancel(_ sender: UIBarButtonItem) {
        if confirm != nil {
            confirm = nil
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapEmpty(_ sender: UIBarButtonItem) {
        if confirm != nil {
            confirm!("")
            confirm = nil
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapConfirm(_ sender: UIBarButtonItem) {
        if confirm != nil {
            confirm!(Common.obtainStringWithDate(date: datePicker.date, formatterStr: "yyyy-MM-dd"))
            confirm = nil
        }
        dismiss(animated: true, completion: nil)
    }

}
