//
//  SetupPasswordViewController.swift
//  Box
//
//  Created by luan on 2018/11/21.
//  Copyright © 2018 luan. All rights reserved.
//

import UIKit
import RxSwift

class SetupPasswordViewController: LuanViewController {

    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmField: UITextField!
    @IBOutlet weak var codeField: UITextField!
    @IBOutlet weak var selectBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    var phone = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bind()
    }
    
    @IBAction func didTapSelect(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            if (passwordField.text ?? "").count > 0, (confirmField.text ?? "").count > 0, (codeField.text ?? "").count > 0 {
                registerBtn.isEnabled = true
                registerBtn.backgroundColor = kMainColor
            } else {
                registerBtn.isEnabled = false
                registerBtn.backgroundColor = UIColor.lightGray
            }
        } else {
            registerBtn.isEnabled = false
            registerBtn.backgroundColor = UIColor.lightGray
        }
    }
    
    @IBAction func didTapRegister(_ sender: UIButton) {
        view.endEditing(true)
        if (passwordField.text ?? "") != (confirmField.text ?? "") {
            view.makeToast("两次密码不一致，请重新输入")
            return
        }
        loginService.rx.request(.regist(phone, (passwordField.text ?? ""), (codeField.text ?? ""))).mapObject(LuanResult.self).validate().showToastWhenFailured().subscribe(onSuccess: { [weak self] (_) in
            kWindow?.makeToast("注册成功")
            self?.navigationController?.popToRootViewController(animated: true)
        }).disposed(by: disposeBag)
    }
    
    func bind() {
        let passwordSignal = passwordField.rx.text.orEmpty.map { (text) -> Bool in
            return text.count >= 6 && text.count <= 20
        }
        let confirmSignal = confirmField.rx.text.orEmpty.map { (text) -> Bool in
            return text.count >= 6 && text.count <= 20
        }
        Observable.combineLatest(passwordSignal, confirmSignal).map { $0 && $1 }.bind(onNext: { [weak self] (isBool) in
            self?.registerBtn.isEnabled = isBool
            self?.registerBtn.backgroundColor = isBool ? kMainColor : UIColor.lightGray
        }).disposed(by: self.disposeBag)
    }

}
