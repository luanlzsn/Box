//
//  LoginViewController.swift
//  Box
//
//  Created by luan on 2018/11/20.
//  Copyright © 2018 luan. All rights reserved.
//

import UIKit
import RxSwift

class LoginViewController: LuanViewController {

    @IBOutlet weak var logoBgView: UIView!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet var eyeBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        checkLogoBgViewColor()
        
        passwordField.rightViewMode = .always
        passwordField.rightView = eyeBtn
        
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func didTapChangePassword() {
        eyeBtn.isSelected = !eyeBtn.isSelected
        passwordField.isSecureTextEntry = !eyeBtn.isSelected
    }
    
    @IBAction func didTapLogin() {
        view.endEditing(true)
        loginService.rx.request(.login((phoneField.text ?? ""), (passwordField.text ?? ""))).mapObject(DicResult.self).validate().showToastWhenFailured().subscribe(onSuccess: { (result) in
            if let vip = result.data?["vip"] as? [String : Any] {
                LuanManage.userInfo = UserModel(JSON: vip)
                let appdelegate = UIApplication.shared.delegate as? AppDelegate
                appdelegate?.window?.rootViewController = LuanTabBarViewController()
                kWindow?.makeToast("登录成功")
            }
        }).disposed(by: disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Forget" {
            let register = segue.destination as? RegisterViewController
            register?.isForget = true
        }
    }
    
    func checkLogoBgViewColor() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = logoBgView.bounds
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        //设置渐变的主颜色
        gradientLayer.colors = [UIColor(hexString: "ABDCFF")!.cgColor, kMainColor.cgColor]
        logoBgView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func bind() {
        let phoneSignal = phoneField.rx.text.orEmpty.map { (text) -> Bool in
            return Common.isValidateMobile(mobile: text)
        }
        let passSignal = passwordField.rx.text.orEmpty.map { (text) -> Bool in
            return text.count >= 6 && text.count <= 20
        }
        Observable.combineLatest(phoneSignal, passSignal).map { $0 && $1 }.bind(onNext: { [weak self] (isBool) in
            self?.loginBtn.isEnabled = isBool
            self?.loginBtn.backgroundColor = isBool ? kMainColor : UIColor.lightGray
        }).disposed(by: self.disposeBag)
    }

}
