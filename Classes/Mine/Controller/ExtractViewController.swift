//
//  ExtractViewController.swift
//  Box
//
//  Created by luan on 2018/11/27.
//  Copyright © 2018 luan. All rights reserved.
//

import UIKit
import RxSwift

class ExtractViewController: LuanViewController {

    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var extractBtn: UIButton!
    var userInfo: PersonalModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        accountLabel.text = LuanManage.userInfo?.zfbPhone
        moneyLabel.text = String(format: "%.2f", (userInfo?.allAsset ?? 0))
        bind()
    }
    
    @IBAction func didTapExtractAll() {
        textField.text = "\((moneyLabel.text?.int ?? 0))"
        bind()
    }
    
    @IBAction func didTapExtract() {
        view.endEditing(true)
        let money = textField.text?.double() ?? 0
        if money / 100 > (money / 100).int.double || money == 0 {
            view.makeToast("请输入100的倍数")
            return
        }
        let alert = UIAlertController(title: "提示", message: "金额将提现到支付宝[\((LuanManage.userInfo?.zfbPhone ?? ""))]。是否确定提现？", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { [weak self] (_) in
            self?.extract()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func extract() {
        userService.rx.request(.extract((LuanManage.userInfo?.vid ?? 0), (textField.text?.double()?.int ?? 0))).mapObject(DicResult.self).validate().showToastWhenFailured().subscribe(onSuccess: { [weak self] (result) in
            kWindow?.makeToast("提现成功")
            if let id = result.data?["id"] as? Int {
                self?.performSegue(withIdentifier: "ExtractDetail", sender: id)
            }
        }).disposed(by: disposeBag)
    }
    
    func bind() {
        textField.rx.text.orEmpty.map { (text) -> Bool in
            return text.isNumeric
        }.subscribe(onNext: { [weak self] (isBool) in
            self?.extractBtn.isEnabled = isBool
            self?.extractBtn.backgroundColor = isBool ? kMainColor : UIColor.lightGray
        }).disposed(by: disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ExtractDetail" {
            let detail = segue.destination as? ExtractDetailViewController
            detail?.detailId = (sender as? Int) ?? 0
        }
    }

}
