//
//  TaskRecordViewController.swift
//  Box
//
//  Created by luan on 2018/11/25.
//  Copyright © 2018 luan. All rights reserved.
//

import UIKit
import MJRefresh
import ObjectMapper

class TaskRecordViewController: LuanViewController {

    @IBOutlet weak var typeBtn: LuanButton!
    @IBOutlet weak var tableView: UITableView!
    var recordArray = [TaskRecordModel]()
    var taskStatus = -1
    var pageNo = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorInset = .zero
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            self?.getTaskRecord(page: 1)
        })
        tableView.mj_footer = MJRefreshAutoFooter(refreshingBlock: { [weak self] in
            self?.getTaskRecord(page: (self?.pageNo ?? 0) + 1)
        })
        getTaskRecord(page: 1)
    }
    
    @IBAction func didTapType(_ sender: LuanButton) {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let array = ["全部", "待提交", "待审核", "已完成", "审核失败"]
        for i in 0..<array.count {
            sheet.addAction(UIAlertAction(title: array[i], style: .default, handler: { [weak self] (_) in
                self?.typeBtn.setTitle(array[i], for: .normal)
                self?.taskStatus = i - 1
                self?.getTaskRecord(page: 1)
            }))
        }
        sheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        present(sheet, animated: true, completion: nil)
    }
    
    func getTaskRecord(page: Int) {
        taskService.rx.request(.taskRecord((LuanManage.userInfo?.vipPhone ?? ""), taskStatus, page)).mapObject(DicResult.self).validate().showToastWhenFailured().subscribe(onSuccess: { [weak self] (result) in
            self?.tableView.mj_header.endRefreshing()
            self?.tableView.mj_footer.endRefreshing()
            self?.pageNo = page
            if page == 1 {
                self?.recordArray.removeAll()
            }
            if let rows = result.data?["rows"] as? [[String : Any]] {
                let array = Mapper<TaskRecordModel>().mapArray(JSONArray: rows)
                self?.recordArray.append(contentsOf: array)
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

}

extension TaskRecordViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskRecordTableViewCell", for: indexPath) as! TaskRecordTableViewCell
        let record = recordArray[indexPath.row]
        cell.nameLabel.text = record.tName
        cell.timeLabel.text = record.putTime
        cell.moneyLabel.isHidden = record.status != 2
        cell.moneyLabel.text = "￥" + String(format: "%.2f", (record.money ?? 0))
        cell.statusLabel.text = taskStatusArray[record.status ?? 0]
        if record.status == 1 || record.status == 3 {
            cell.statusLabel.textColor = UIColor(hexString: "666666")
        } else if record.status == 2 {
            cell.statusLabel.textColor = UIColor(red: 50, green: 174, blue: 147)
            cell.moneyLabel.isHidden = false
        } else if record.status == 0 {
            cell.statusLabel.textColor = UIColor(red: 238, green: 104, blue: 35)
        }
        return cell
    }

}
