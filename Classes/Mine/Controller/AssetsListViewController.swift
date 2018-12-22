//
//  AssetsListViewController.swift
//  Box
//
//  Created by luan on 2018/12/5.
//  Copyright © 2018 luan. All rights reserved.
//

import UIKit
import MJRefresh
import ObjectMapper

class AssetsListViewController: LuanViewController {

    @IBOutlet weak var typeBtn: LuanButton!
    @IBOutlet weak var calendarBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var assetsArray = [AssetsModel]()
    var pageNo = 1
    var type = 0
    var time = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorInset = .zero
        tableView.register(R.nib.incomeListTableViewCell(), forCellReuseIdentifier: "IncomeListTableViewCell")
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            self?.getAssetsList(page: 1)
        })
        tableView.mj_footer = MJRefreshAutoFooter(refreshingBlock: { [weak self] in
            self?.getAssetsList(page: (self?.pageNo ?? 0) + 1)
        })
        getAssetsList(page: 1)
    }
    
    func getAssetsList(page: Int) {
        userService.rx.request(.assetsList((LuanManage.userInfo?.token ?? ""), page, type, time)).mapObject(DicResult.self).validate().showToastWhenFailured().subscribe(onSuccess: { [weak self] (result) in
            self?.tableView.mj_header.endRefreshing()
            self?.tableView.mj_footer.endRefreshing()
            self?.pageNo = page
            if page == 1 {
                self?.assetsArray.removeAll()
            }
            if let rows = result.data?["rows"] as? [[String : Any]] {
                let array = Mapper<AssetsModel>().mapArray(JSONArray: rows)
                self?.assetsArray.append(contentsOf: array)
                self?.tableView.mj_footer.isHidden = (array.count < 20)
            }
            self?.tableView.reloadData()
        }) { [weak self] (_) in
            self?.tableView.mj_header.endRefreshing()
            self?.tableView.mj_footer.endRefreshing()
        }.disposed(by: disposeBag)
    }

    @IBAction func didTapType() {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let array = ["全部", "收入", "提现"]
        for i in 0..<array.count {
            sheet.addAction(UIAlertAction(title: array[i], style: .default, handler: { [weak self] (_) in
                self?.typeBtn.setTitle(array[i], for: .normal)
                self?.type = i
                self?.getAssetsList(page: 1)
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
                    self?.time = dateStr
                    self?.getAssetsList(page: 1)
                }
            }
        } else if segue.identifier == "IncomeDetail" {
            let detail = segue.destination as? IncomeDetailViewController
            detail?.detailId = (sender as? Int) ?? 0
        } else if segue.identifier == "ExtractDetail" {
            let detail = segue.destination as? ExtractDetailViewController
            detail?.detailId = (sender as? Int) ?? 0
        }
    }

}

extension AssetsListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assetsArray.count
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
        let model = assetsArray[indexPath.row]
        if model.type == 1 {
            cell.typeLabel.text = "收入"
            cell.incomeLabel.text = String(format: "+%.2f", (model.money ?? 0))
            cell.incomeLabel.textColor = UIColor(hexString: "F45945")
        } else {
            cell.typeLabel.text = "提现"
            cell.incomeLabel.text = String(format: "-%.2f", (model.money ?? 0))
            cell.incomeLabel.textColor = UIColor(hexString: "29AB91")
        }
        cell.balanceLabel.text = String(format: "%.2f", (model.balance ?? 0))
        cell.timeLabel.text = model.createTime
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = assetsArray[indexPath.row]
        if model.type == 1 {
            performSegue(withIdentifier: "IncomeDetail", sender: model.id)
        } else {
            performSegue(withIdentifier: "ExtractDetail", sender: model.id)
        }
    }
}
