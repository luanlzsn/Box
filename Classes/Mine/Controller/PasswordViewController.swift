//
//  PasswordViewController.swift
//  Box
//
//  Created by luan on 2018/11/26.
//  Copyright © 2018 luan. All rights reserved.
//

import UIKit
import RxSwift

class PasswordViewController: LuanViewController {

    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var newField: UITextField!
    @IBOutlet weak var confirmField: UITextField!
    @IBOutlet weak var updateBtn: UIButton!
    var isPaymnet = false//是否是修改支付密码
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isPaymnet {
            navigationItem.title = "修改支付密码"
        }
        bind()
    }
    
    @IBAction func didTapUpdate(_ sender: UIButton) {
        view.endEditing(true)
        if (newField.text ?? "") != (confirmField.text ?? "") {
            view.makeToast("两次密码不一致，请重新输入")
            return
        }
        if isPaymnet {
            kWindow?.makeToast("密码修改成功")
            navigationController?.popViewController()
        } else {
            userService.rx.request(.editPassword((LuanManage.userInfo?.token ?? ""), (passwordField.text ?? ""), (newField.text ?? ""))).mapObject(LuanResult.self).validate().showToastWhenFailured().subscribe(onSuccess: { [weak self] (_) in
                kWindow?.makeToast("密码修改成功")
                self?.navigationController?.popViewController()
            }).disposed(by: disposeBag)
        }
    }
    
    func bind() {
        let passwordSignal = passwordField.rx.text.orEmpty.map { (text) -> Bool in
            return text.count >= 6 && text.count <= 20
        }
        let newSignal = newField.rx.text.orEmpty.map { (text) -> Bool in
            return text.count > 0
        }
        let confirmSignal = confirmField.rx.text.orEmpty.map { (text) -> Bool in
            return text.count >= 6 && text.count <= 20
        }
        Observable.combineLatest(passwordSignal, newSignal, confirmSignal).map { $0 && $1 && $2 }.bind(onNext: { [weak self] (isBool) in
            self?.updateBtn.isEnabled = isBool
            self?.updateBtn.backgroundColor = isBool ? kMainColor : UIColor.lightGray
        }).disposed(by: self.disposeBag)
    }

}
