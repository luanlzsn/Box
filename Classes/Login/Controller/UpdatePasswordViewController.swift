//
//  UpdatePasswordViewController.swift
//  Box
//
//  Created by luan on 2018/11/21.
//  Copyright © 2018 luan. All rights reserved.
//

import UIKit
import RxSwift

class UpdatePasswordViewController: LuanViewController {

    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmField: UITextField!
    @IBOutlet weak var confirmBtn: UIButton!
    var phone = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bind()
    }
    
    @IBAction func didTapConfirm(_ sender: UIButton) {
        view.endEditing(true)
        if (passwordField.text ?? "") != (confirmField.text ?? "") {
            view.makeToast("两次密码不一致，请重新输入")
            return
        }
        loginService.rx.request(.forgetNext(phone, (passwordField.text ?? ""))).mapObject(LuanResult.self).validate().showToastWhenFailured().subscribe(onSuccess: { [weak self] (_) in
            kWindow?.makeToast("密码修改成功")
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
            self?.confirmBtn.isEnabled = isBool
            self?.confirmBtn.backgroundColor = isBool ? kMainColor : UIColor.lightGray
        }).disposed(by: self.disposeBag)
    }

}
