//
//  IncomeListViewController.swift
//  Box
//
//  Created by luan on 2018/11/25.
//  Copyright © 2018 luan. All rights reserved.
//

import UIKit
import MJRefresh
import ObjectMapper

class IncomeListViewController: LuanViewController {

    @IBOutlet weak var typeBtn: LuanButton!
    @IBOutlet weak var calendarBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var isTodayIncome = false//是否是今日收益
    var incomeArray = [BonusRecord]()
    var pageNo = 1
    var date = ""
    var type = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorInset = .zero
        tableView.register(R.nib.incomeListTableViewCell(), forCellReuseIdentifier: "IncomeListTableViewCell")
        if isTodayIncome == true {
            navigationItem.title = "今日收入明细"
            calendarBtn.isEnabled = false
            calendarBtn.setImage(nil, for: .normal)
            calendarBtn.setTitle(Common.obtainStringWithDate(date: Date(), formatterStr: "yyyy-MM-dd"), for: .normal)
            date = calendarBtn.currentTitle ?? ""
        }
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            self?.getIncomeList(page: 1)
        })
        tableView.mj_footer = MJRefreshAutoFooter(refreshingBlock: { [weak self] in
            self?.getIncomeList(page: (self?.pageNo ?? 0) + 1)
        })
        getIncomeList(page: 1)
    }
    
    func getIncomeList(page: Int) {
        userService.rx.request(.incomeList((LuanManage.userInfo?.vipPhone ?? ""), date, page, type)).mapObject(DicResult.self).validate().showToastWhenFailured().subscribe(onSuccess: { [weak self] (result) in
            self?.tableView.mj_header.endRefreshing()
            self?.tableView.mj_footer.endRefreshing()
            self?.pageNo = page
            if page == 1 {
                self?.incomeArray.removeAll()
            }
            if let rows = result.data?["rows"] as? [[String : Any]] {
                let array = Mapper<BonusRecord>().mapArray(JSONArray: rows)
                self?.incomeArray.append(contentsOf: array)
                self?.tableView.mj_footer.isHidden = (array.count < 20)
            } else {
                self?.tableView.mj_footer.isHidden = true
            }
            self?.tableView.reloadData()
        }) { [weak self] (_) in
            self?.tableView.mj_header.endRefreshing()
            self?.tableView.mj_footer.endRefreshing()
        }.disposed(by: disposeBag)
    }
    
    @IBAction func didTapType(_ sender: LuanButton) {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let array = ["全部", "直推奖金", "间推奖金", "直推佣金", "间推佣金", "任务奖金", "团队奖金"]
        for i in 0..<array.count {
            sheet.addAction(UIAlertAction(title: array[i], style: .default, handler: { [weak self] (_) in
                self?.typeBtn.setTitle(array[i], for: .normal)
                self?.type = i - 1
                self?.getIncomeList(page: 1)
            }))
        }
        sheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        present(sheet, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Calendar" {
            let calendar = segue.destination as! CalendarViewController
            calendar.confirm = { [weak self] (result) in
                if let dateStr = result as? String {
                    if dateStr.isEmpty {
                        self?.calendarBtn.setTitle("", for: .normal)
                        self?.calendarBtn.setImage(R.image.calendar(), for: .normal)
                    } else {
                        self?.calendarBtn.setTitle(dateStr, for: .normal)
                        self?.calendarBtn.setImage(nil, for: .normal)
                    }
                    self?.date = dateStr
                    self?.getIncomeList(page: 1)
                }
            }
        } else if segue.identifier == "IncomeDetail" {
            let detail = segue.destination as? IncomeDetailViewController
            detail?.detailId = (sender as? Int) ?? 0
        }
    }
}

extension IncomeListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return incomeArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IncomeListTableViewCell", for: indexPath) as! IncomeListTableViewCell
        let model = incomeArray[indexPath.row]
        let typeArray = ["直推奖金", "间推奖金", "直推佣金", ":间推佣金", "任务奖金", "团队奖金"]
        if model.type ?? 0 < typeArray.count {
            cell.typeLabel.text = typeArray[model.type ?? 0]
        } else {
            cell.typeLabel.text = ""
        }
        cell.incomeLabel.text = String(format: "+%.2f", (model.money ?? 0))
        cell.balanceLabel.text = String(format: "%.2f", (model.balance ?? 0))
        cell.timeLabel.text = model.grantTime
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "IncomeDetail", sender: incomeArray[indexPath.row].id)
    }
}
