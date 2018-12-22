//
//  BindAlipayViewController.swift
//  Box
//
//  Created by luan on 2018/11/27.
//  Copyright © 2018 luan. All rights reserved.
//

import UIKit
import RxSwift

class BindAlipayViewController: LuanViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var accountField: UITextField!
    @IBOutlet weak var codeField: UITextField!
    @IBOutlet weak var codeBtn: UIButton!
    @IBOutlet weak var bindBtn: UIButton!
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bind()
    }
    
    @IBAction func didTapSendCode() {
        loginService.rx.request(.sendCode(LuanManage.userInfo?.vipPhone ?? "")).mapObject(LuanResult.self).validate().showToastWhenFailured().subscribe(onSuccess: { [weak self] (_) in
            self?.count = 60
            self?.countDown()
        }).disposed(by: disposeBag)
    }
    
    @IBAction func didTapBindAlipay() {
        view.endEditing(true)
        let alert = UIAlertController(title: "警告", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { [weak self] (_) in
            self?.bindAlipay()
        }))
        let attr = NSMutableAttributedString(string: "请准确核对真实姓名和支付宝账号是否正确，以免造成资金损失。是否确认绑定？")
        let rangOne = attr.string.nsString.range(of: "真实姓名")
        let rangTwo = attr.string.nsString.range(of: "支付宝账号")
        attr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: rangOne)
        attr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: rangTwo)
        alert.setValue(attr, forKey: "attributedMessage")
        present(alert, animated: true, completion: nil)
    }
    
    func bindAlipay() {
        userService.rx.request(.bindAlipay((accountField.text ?? ""), (LuanManage.userInfo?.vid ?? 0), (nameField.text ?? ""), (codeField.text ?? ""))).mapObject(LuanResult.self).validate().showToastWhenFailured().subscribe(onSuccess: { [weak self] (_) in
            kWindow?.makeToast("支付宝绑定成功")
            self?.navigationController?.popViewController()
        }).disposed(by: disposeBag)
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
        let nameSignal = nameField.rx.text.orEmpty.map { (text) -> Bool in
            return text.count > 0
        }
        let accountSignal = accountField.rx.text.orEmpty.map { (text) -> Bool in
            return text.count > 0
        }
        let codeSignal = codeField.rx.text.orEmpty.map { (text) -> Bool in
            return text.count == 4
        }
        Observable.combineLatest(nameSignal, accountSignal, codeSignal).map { $0 && $1 && $2 }.bind(onNext: { [weak self] (isBool) in
            self?.bindBtn.isEnabled = isBool
            self?.bindBtn.backgroundColor = isBool ? kMainColor : UIColor.lightGray
        }).disposed(by: self.disposeBag)
    }

}
