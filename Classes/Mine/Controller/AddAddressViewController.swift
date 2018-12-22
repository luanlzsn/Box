//
//  AddAddressViewController.swift
//  Box
//
//  Created by luan on 2018/11/27.
//  Copyright © 2018 luan. All rights reserved.
//

import UIKit
import RxSwift

class AddAddressViewController: LuanViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    var address: AddressModel?
    var isEdit = false//是否是修改
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if isEdit {
            navigationItem.title = "编辑地址"
            nameField.text = address?.people
            phoneField.text = address?.phone
            addressField.text = address?.content
        }
        bind()
    }
    
    @IBAction func didTapSave() {
        view.endEditing(true)
        if isEdit {
            userService.rx.request(.saveAddress((LuanManage.userInfo?.token ?? ""), (address?.id ?? 0), (nameField.text ?? ""), (phoneField.text ?? ""), (addressField.text ?? ""))).mapObject(LuanResult.self).showToastWhenFailured().validate().subscribe(onSuccess: { [weak self] (result) in
                kWindow?.makeToast("保存成功")
                self?.navigationController?.popViewController()
            }).disposed(by: disposeBag)
        } else {
            userService.rx.request(.addAddress((LuanManage.userInfo?.token ?? ""), (nameField.text ?? ""), (phoneField.text ?? ""), (addressField.text ?? ""))).mapObject(LuanResult.self).showToastWhenFailured().validate().subscribe(onSuccess: { [weak self] (result) in
                kWindow?.makeToast("保存成功")
                self?.navigationController?.popViewController()
            }).disposed(by: disposeBag)
        }
    }
    
    func bind() {
        let nameSignal = nameField.rx.text.orEmpty.map { (text) -> Bool in
            return text.count > 0
        }
        let phoneSignal = phoneField.rx.text.orEmpty.map { (text) -> Bool in
            return Common.isValidateMobile(mobile: text)
        }
        let addressSignal = addressField.rx.text.orEmpty.map { (text) -> Bool in
            return text.count > 0
        }
        Observable.combineLatest(nameSignal, phoneSignal, addressSignal).map { $0 && $1 && $2 }.bind(onNext: { [weak self] (isBool) in
            self?.saveBtn.isEnabled = isBool
            self?.saveBtn.backgroundColor = isBool ? kMainColor : UIColor.lightGray
        }).disposed(by: self.disposeBag)
    }

}
