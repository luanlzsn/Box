//
//  ExtractListViewController.swift
//  Box
//
//  Created by luan on 2018/11/26.
//  Copyright © 2018 luan. All rights reserved.
//

import UIKit
import MJRefresh
import ObjectMapper

class ExtractListViewController: LuanViewController {

    @IBOutlet weak var calendarBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var extractArray = [ExtractModel]()
    var time = ""
    var pageNo = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            self?.getExtractList(page: 1)
        })
        tableView.mj_footer = MJRefreshAutoFooter(refreshingBlock: { [weak self] in
            self?.getExtractList(page: (self?.pageNo ?? 0) + 1)
        })
        getExtractList(page: 1)
    }
    
    func getExtractList(page: Int) {
        userService.rx.request(.extractList((LuanManage.userInfo?.token ?? ""), page, time)).mapObject(DicResult.self).validate().showToastWhenFailured().subscribe(onSuccess: { [weak self] (result) in
            self?.tableView.mj_header.endRefreshing()
            self?.tableView.mj_footer.endRefreshing()
            self?.pageNo = page
            if page == 1 {
                self?.extractArray.removeAll()
            }
            if let rows = result.data?["rows"] as? [[String : Any]] {
                let array = Mapper<ExtractModel>().mapArray(JSONArray: rows)
                self?.extractArray.append(contentsOf: array)
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
                    self?.getExtractList(page: 1)
                }
            }
        } else if segue.identifier == "ExtractDetail" {
            let detail = segue.destination as? ExtractDetailViewController
            detail?.detailId = (sender as? Int) ?? 0
        }
    }
    
}

extension ExtractListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return extractArray.count
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExtractListTableViewCell", for: indexPath) as! ExtractListTableViewCell
        let model = extractArray[indexPath.row]
        cell.balanceLabel.text = String(format: "%.2f", model.balance ?? 0)
        cell.moneyLabel.text = String(format: "-%.2f", model.money ?? 0)
        cell.timeLabel.text = model.time
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        performSegue(withIdentifier: "ExtractDetail", sender: extractArray[indexPath.row].id)
    }
}
