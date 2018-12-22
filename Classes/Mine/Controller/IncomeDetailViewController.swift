//
//  IncomeDetailViewController.swift
//  Box
//
//  Created by luan on 2018/11/25.
//  Copyright © 2018 luan. All rights reserved.
//

import UIKit
import ObjectMapper

class IncomeDetailViewController: LuanViewController {

    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    var detailId = 0
    var model: IncomeModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getIncomeDetail()
    }
    
    func getIncomeDetail() {
        userService.rx.request(.incomeDetail(detailId)).mapObject(DicResult.self).validate().showToastWhenFailured().subscribe(onSuccess: { [weak self] (result) in
            if let info = result.data?["view"] as? [String : Any] {
                self?.model = Mapper<IncomeModel>().map(JSON: info)
                self?.refreshInfo()
            }
        }) { [weak self] (_) in
            self?.navigationController?.popViewController()
        }.disposed(by: disposeBag)
    }
    
    func refreshInfo() {
        nicknameLabel.text = model?.provideName
        numberLabel.text = model?.bonusRecord?.orderNum
        timeLabel.text = model?.bonusRecord?.grantTime
        moneyLabel.text = String(format: "￥%.2f", (model?.bonusRecord?.money ?? 0))
        let typeArray = ["直推奖金", "间推奖金", "直推佣金", ":间推佣金", "任务奖金", "团队奖金"]
        if model?.bonusRecord?.type ?? 0 < typeArray.count {
            typeLabel.text = typeArray[model?.bonusRecord?.type ?? 0]
        } else {
            typeLabel.text = ""
        }
    }
    

}
