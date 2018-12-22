//
//  MineViewController.swift
//  Box
//
//  Created by luan on 2018/11/20.
//  Copyright © 2018 luan. All rights reserved.
//

import UIKit
import SwifterSwift
import ObjectMapper

class MineViewController: LuanViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleTop: NSLayoutConstraint!
    @IBOutlet weak var titleBgHeight: NSLayoutConstraint!
    @IBOutlet weak var avaterBtn: UIButton!//头像
    @IBOutlet weak var nickname: UIButton!//昵称
    @IBOutlet weak var phoneBtn: UIButton!//手机号
    @IBOutlet weak var levelImage: UIImageView!//等级
    @IBOutlet weak var moneyBtn: UIButton!//总资产
    @IBOutlet weak var allIncome: UILabel!//总收益
    @IBOutlet weak var todayIncome: UILabel!//今日收益
    @IBOutlet weak var extract: UILabel!//已提现
    var userInfo: PersonalModel?
    
    let titleArray = [["我的团队", "密码管理"], ["我的支付宝", "提现"], ["我的地址", "设置"]]
    let iconArray = [["team_con", "mine_password_icon"], ["alipay_icon", "extract_icon"], ["address_icon", "setup_icon"]]
    let identifierArray = [["TeamList", "PasswordManage"], ["BindAlipay", "Extract"], ["AddressList", "Setup"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "我的"
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        titleBgHeight.constant = 140 + (SwifterSwift.statusBarHeight - 20)
        tableView.tableHeaderView?.height = titleBgHeight.constant + 200
        titleTop.constant = SwifterSwift.statusBarHeight
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        getUserInfo()
        refreshUserInfo()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func getUserInfo() {
        userService.rx.request(.myIndex(LuanManage.userInfo?.token ?? "")).mapObject(DicResult.self).validate().showToastWhenFailured().subscribe(onSuccess: { [weak self] (result) in
            if let userInfo = result.data {
                self?.userInfo = Mapper<PersonalModel>().map(JSON: userInfo)
                LuanManage.userInfo = self?.userInfo?.vip
                self?.refreshUserInfo()
            }
        }).disposed(by: disposeBag)
    }
    
    func refreshUserInfo() {
        avaterBtn.kf.setImage(with: URL(string: kImagePath + (LuanManage.userInfo?.head ?? "")), for: .normal, placeholder: R.image.avater_default())
        nickname.setTitle(LuanManage.userInfo?.vipName, for: .normal)
        phoneBtn.setTitle(LuanManage.userInfo?.vipPhone, for: .normal)
        levelImage.image = LuanManage.userInfo?.getVipImage()
        moneyBtn.setTitle(String(format: "%.2f", (userInfo?.allAsset ?? 0)), for: .normal)
        allIncome.text = String(format: "%.2f", (userInfo?.allIncome ?? 0))
        todayIncome.text = String(format: "%.2f", (userInfo?.nowIncome ?? 0))
        extract.text = String(format: "%.2f", (userInfo?.tiXian ?? 0))
    }

    // MARK: - 我要升级
    @IBAction func didTapUpgrade() {
        if LuanManage.userInfo?.vipLevel ?? 0 > 2 {
            let payment = R.storyboard.home().instantiateViewController(withIdentifier: "PaymentViewController") as! PaymentViewController
            navigationController?.pushViewController(payment)
        } else {
            let vip = R.storyboard.home().instantiateViewController(withIdentifier: "VipViewController") as! VipViewController
            navigationController?.pushViewController(vip)
        }
    }
    
    @IBAction func didTapLogout() {
        let alert = UIAlertController(title: "提示", message: "是否确定注销？", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { [weak self] (_) in
            userService.rx.request(.logout(LuanManage.userInfo?.token ?? "")).mapObject(LuanResult.self).validate().showToastWhenFailured().subscribe(onSuccess: { (_) in
                LuanManage.userInfo = nil
                let appdelegate = UIApplication.shared.delegate as? AppDelegate
                appdelegate?.window?.rootViewController = R.storyboard.login().instantiateInitialViewController()
            }).disposed(by: self!.disposeBag)
            
        }))
        present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TodayIncome" {
            let income = segue.destination as? IncomeListViewController
            income?.isTodayIncome = true
        } else if segue.identifier == "Extract" {
            let extract = segue.destination as? ExtractViewController
            extract?.userInfo = userInfo
        }
    }
}

extension MineViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return (section == titleArray.count - 1) ? 10 : 0.1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MineTableViewCell", for: indexPath) as! MineTableViewCell
        cell.iconImage.image = UIImage(named: iconArray[indexPath.section][indexPath.row])
        cell.titleLabel.text = titleArray[indexPath.section][indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if identifierArray[indexPath.section][indexPath.row] == "BindAlipay" {
            if LuanManage.userInfo?.zfbPhone?.isEmpty == false {
                performSegue(withIdentifier: "MyAlipay", sender: nil)
            } else {
                performSegue(withIdentifier: "BindAlipay", sender: nil)
            }
        } else if identifierArray[indexPath.section][indexPath.row] == "Extract" {
            if LuanManage.userInfo?.zfbPhone?.isEmpty == false {
                performSegue(withIdentifier: identifierArray[indexPath.section][indexPath.row], sender: nil)
            } else {
                kWindow?.makeToast("请先绑定支付宝")
                performSegue(withIdentifier: "BindAlipay", sender: nil)
            }
        } else if identifierArray[indexPath.section][indexPath.row] != "" {
            performSegue(withIdentifier: identifierArray[indexPath.section][indexPath.row], sender: nil)
        }
    }
}
