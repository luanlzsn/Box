//
//  EditNameViewController.swift
//  Box
//
//  Created by luan on 2018/11/27.
//  Copyright © 2018 luan. All rights reserved.
//

import UIKit
import RxSwift

class EditNameViewController: LuanViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameField.text = LuanManage.userInfo?.vipName
        bind()
    }
    
    @IBAction func didTapSubmit() {
        userService.rx.request(.editName((LuanManage.userInfo?.token ?? ""), (nameField.text ?? ""))).mapObject(LuanResult.self).validate().showToastWhenFailured().subscribe(onSuccess: { [weak self] (_) in
            kWindow?.makeToast("名称修改成功")
            LuanManage.userInfo?.vipName = self?.nameField.text
            self?.navigationController?.popViewController()
        }).disposed(by: disposeBag)
    }
    
    func bind() {
        nameField.rx.text.orEmpty.map { (text) -> Bool in
            return text.count > 0
        }.subscribe(onNext: { [weak self] (isBool) in
            self?.submitBtn.isEnabled = isBool
            self?.submitBtn.backgroundColor = isBool ? kMainColor : UIColor.lightGray
        }).disposed(by: disposeBag)
    }

}

