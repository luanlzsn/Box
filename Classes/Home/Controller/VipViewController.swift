//
//  VipViewController.swift
//  Box
//
//  Created by luan on 2018/11/24.
//  Copyright © 2018 luan. All rights reserved.
//

import UIKit
import SwifterSwift

class VipViewController: LuanViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var descLabel: YYLabel! {
        didSet {
            descLabel.preferredMaxLayoutWidth = SwifterSwift.screenWidth - 70
        }
    }
    @IBOutlet weak var moneyLabel: UILabel!
    var vipTitleArray = ["红钻VIP", "黄钻VIP", "蓝钻VIP"]
    var vipImageArray = ["diamond_red", "diamond_yellow", "diamond_blue"]
    var vipMoneyArray = [158, 328, 498]
    var descArray = ["特权：\n自己发圈可赚10元/天\n直推一代发圈可赚6元/人/天\n间接二代发圈可赚4元/人/天", "特权：\n自己发圈可赚20元/天\n直推一代发圈可赚12元/人/天\n间接二代发圈可赚8元/人/天", "特权：\n自己发圈可赚30元/天\n直推一代发圈可赚18元/人/天\n间接二代发圈可赚12元/人/天"]
    let vipLevel = LuanManage.userInfo?.vipLevel ?? 0
    var selectSection = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if LuanManage.userInfo?.vipLevel ?? 0 > 0 {
            navigationItem.title = "升级VIP"
            selectSection = 1
            tableHeight.constant = (vipTitleArray.count - vipLevel + 1).cgFloat * 70 + 20
        } else {
            tableHeight.constant = vipTitleArray.count.cgFloat * 70 + 20
        }
        refreshInfo()
    }
    
    func refreshInfo() {
        let attr: NSMutableAttributedString!
        if vipLevel > 0 {
            let money = vipMoneyArray[selectSection + vipLevel - 1] - vipMoneyArray[vipLevel - 1]
            moneyLabel.text = "￥\(money)"
            attr = NSMutableAttributedString(string: descArray[selectSection + vipLevel - 1])
        } else {
            let money = vipMoneyArray[selectSection]
            moneyLabel.text = "￥\(money)"
            attr = NSMutableAttributedString(string: descArray[selectSection])
        }
        attr.yy_font = UIFont.systemFont(ofSize: 15)
        attr.yy_color = UIColor(hexString: "333333")
        attr.yy_lineSpacing = 10
        descLabel.attributedText = attr
    }

}

extension VipViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        if vipLevel > 0 {
            return vipTitleArray.count - vipLevel + 1
        } else {
            return vipTitleArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if vipLevel > 0, indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CurrentVipTableViewCell", for: indexPath) as! CurrentVipTableViewCell
            cell.diamondImage.image = LuanManage.userInfo?.getVipImage()
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "VipTableViewCell", for: indexPath) as! VipTableViewCell
            if vipLevel > 0 {
                cell.diamondImage.image = UIImage(named: vipImageArray[indexPath.section + vipLevel - 1])
                cell.vipTitle.text = vipTitleArray[indexPath.section + vipLevel - 1]
                cell.moneyLabel.text = "￥\(vipMoneyArray[indexPath.section + vipLevel - 1] - vipMoneyArray[vipLevel - 1])"
                cell.bgView.borderColor = (selectSection == indexPath.section) ? UIColor(hexString: "F45945")! : UIColor(hexString: "CCCCCC")!
            } else {
                cell.diamondImage.image = UIImage(named: vipImageArray[indexPath.section])
                cell.vipTitle.text = vipTitleArray[indexPath.section]
                cell.moneyLabel.text = "￥\(vipMoneyArray[indexPath.section])"
                cell.bgView.borderColor = (selectSection == indexPath.section) ? UIColor(hexString: "F45945")! : UIColor(hexString: "CCCCCC")!
            }
            cell.bgView.backgroundColor = (selectSection == indexPath.section) ? UIColor(hexString: "FEEEED") : UIColor.white
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if vipTitleArray[indexPath.section] != "", selectSection != indexPath.section {
            selectSection = indexPath.section
            tableView.reloadData()
            refreshInfo()
        }
    }
}
