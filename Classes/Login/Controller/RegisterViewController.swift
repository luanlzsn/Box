//
//  RegisterViewController.swift
//  Box
//
//  Created by luan on 2018/11/21.
//  Copyright © 2018 luan. All rights reserved.
//

import UIKit
import RxSwift

class RegisterViewController: LuanViewController {

    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var codeField: UITextField!
    @IBOutlet weak var codeBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    var isForget = false//是否是忘记密码
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = isForget ? "忘记密码" : "注册"
        bind()
    }
    
    @IBAction func didTapSendCode(_ sender: UIButton) {
        loginService.rx.request(.sendCode(phoneField.text ?? "")).mapObject(LuanResult.self).validate().showToastWhenFailured().subscribe(onSuccess: { [weak self] (_) in
            self?.count = 60
            self?.countDown()
        }).disposed(by: disposeBag)
    }
    
    @IBAction func didTapNext(_ sender: UIButton) {
        if isForget {
            loginService.rx.request(.forgetPassword((phoneField.text ?? ""), (codeField.text ?? ""))).mapObject(LuanResult.self).validate().showToastWhenFailured().subscribe(onSuccess: { [weak self] (_) in
                self?.performSegue(withIdentifier: "UpdatePassword", sender: nil)
            }).disposed(by: disposeBag)
        } else {
            loginService.rx.request(.registNext((phoneField.text ?? ""), (codeField.text ?? ""))).mapObject(LuanResult.self).validate().showToastWhenFailured().subscribe(onSuccess: { [weak self] (_) in
                self?.performSegue(withIdentifier: "SetupPassword", sender: nil)
            }).disposed(by: disposeBag)
        }
    }
    
    @objc func countDown() {
        count -= 1
        if count <= 0 {
            codeBtn.isEnabled = true
            codeBtn.setTitle("获取验证码", for: .normal)
        } else {
            codeBtn.isEnabled = false
            codeBtn.setTitle("\(count)s", for: .normal)
            perform(#selector(countDown), with: nil, afterDelay: 1)
        }
    }
    
    func bind() {
        let phoneSignal = phoneField.rx.text.orEmpty.map { [weak self] (text) -> Bool in
            let isMobile = Common.isValidateMobile(mobile: text)
            self?.codeBtn.isEnabled = isMobile
            return isMobile
        }
        let codeSignal = codeField.rx.text.orEmpty.map { (text) -> Bool in
            return text.count == 4
        }
        Observable.combineLatest(phoneSignal, codeSignal).map { $0 && $1 }.bind(onNext: { [weak self] (isBool) in
            self?.nextBtn.isEnabled = isBool
            self?.nextBtn.backgroundColor = isBool ? kMainColor : UIColor.lightGray
        }).disposed(by: self.disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SetupPassword" {
            let setup = segue.destination as? SetupPasswordViewController
            setup?.phone = phoneField.text ?? ""
        } else if segue.identifier == "UpdatePassword" {
            let update = segue.destination as? UpdatePasswordViewController
            update?.phone = phoneField.text ?? ""
        }
    }
    
}
