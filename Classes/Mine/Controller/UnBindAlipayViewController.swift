//
//  UnBindAlipayViewController.swift
//  Box
//
//  Created by luan on 2018/11/27.
//  Copyright © 2018 luan. All rights reserved.
//

import UIKit
import RxSwift

class UnBindAlipayViewController: LuanViewController {

    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var codeField: UITextField!
    @IBOutlet weak var codeBtn: UIButton!
    @IBOutlet weak var confirmBtn: UIButton!
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        accountLabel.text = LuanManage.userInfo?.zfbPhone
        bind()
    }
    
    @IBAction func didTapSendCode() {
        loginService.rx.request(.sendCode(LuanManage.userInfo?.vipPhone ?? "")).mapObject(LuanResult.self).validate().showToastWhenFailured().subscribe(onSuccess: { [weak self] (_) in
            self?.count = 60
            self?.countDown()
        }).disposed(by: disposeBag)
    }
    
    @IBAction func didTapConfirm() {
        userService.rx.request(.unbindAlipay((LuanManage.userInfo?.zfbPhone ?? ""), (LuanManage.userInfo?.vid ?? 0), (codeField.text ?? ""))).mapObject(LuanResult.self).validate().showToastWhenFailured().subscribe(onSuccess: { [weak self] (_) in
            kWindow?.makeToast("解绑成功")
            self?.navigationController?.popToRootViewController(animated: true)
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
        codeField.rx.text.orEmpty.map { (text) -> Bool in
            return text.count == 4
        }.subscribe(onNext: { [weak self] (isBool) in
            self?.confirmBtn.isEnabled = isBool
            self?.confirmBtn.backgroundColor = isBool ? kMainColor : UIColor.lightGray
        }).disposed(by: disposeBag)
    }

}
