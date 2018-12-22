//
//  ExtractDetailViewController.swift
//  Box
//
//  Created by luan on 2018/11/26.
//  Copyright © 2018 luan. All rights reserved.
//

import UIKit
import ObjectMapper

class ExtractDetailViewController: LuanViewController {
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    var detailId = 0
    var model: ExtractModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        getExtractDetail()
    }
    
    func getExtractDetail() {
        userService.rx.request(.extractDetail(detailId)).mapObject(DicResult.self).validate().showToastWhenFailured().subscribe(onSuccess: { [weak self] (result) in
            if let info = result.data?["tixian"] as? [String : Any] {
                self?.model = Mapper<ExtractModel>().map(JSON: info)
                self?.refreshInfo()
            }
        }) { [weak self] (_) in
            self?.navigationController?.popViewController()
        }.disposed(by: disposeBag)
    }
    
    func refreshInfo() {
        numberLabel.text = model?.orderNum
        timeLabel.text = model?.time
        moneyLabel.text = String(format: "￥%.2f", (model?.money ?? 0))
        typeLabel.text = "提现"
        statusLabel.text = ((model?.status ?? 0) == 1) ? "已完成" : "执行中"
    }

}
