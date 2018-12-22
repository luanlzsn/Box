//
//  TaskListViewController.swift
//  Box
//
//  Created by luan on 2018/11/24.
//  Copyright © 2018 luan. All rights reserved.
//

import UIKit
import SwifterSwift
import ObjectMapper

class TaskListViewController: LuanViewController {

    @IBOutlet weak var tableView: UITableView!
    let descLabel = YYLabel()
    var taskArray = [TaskModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        descLabel.preferredMaxLayoutWidth = SwifterSwift.screenWidth
        descLabel.numberOfLines = 0
        descLabel.textContainerInset = UIEdgeInsets(top: 25, left: 12, bottom: 25, right: 12)
        let attr = NSMutableAttributedString(string: "")
        
        let attrOne = NSMutableAttributedString(string: "任务领取规则\n")
        attrOne.yy_font = UIFont.systemFont(ofSize: 15)
        attrOne.yy_color = UIColor(hexString: "333333")
        
        let attrTwo = NSMutableAttributedString(string: "1、vip会员可领取每天2条朋友圈发布任务。\n2、发布任务时必须与平台内的文案、图片一致【个人邀请好友海报+产品图2张】\n3、不得屏蔽微信好友查看您的朋友圈。\n4、上传图片必须是朋友圈全屏截图。")
        attrTwo.yy_font = UIFont.systemFont(ofSize: 14)
        attrTwo.yy_color = UIColor(hexString: "666666")
        
        attr.append(attrOne)
        attr.append(attrTwo)
        attr.yy_lineSpacing = 15
        descLabel.attributedText = attr
        descLabel.sizeToFit()
        tableView.tableFooterView = descLabel
        tableView.tableFooterView?.height = descLabel.height + 50
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getTaskList()
    }
    
    func getTaskList() {
        taskService.rx.request(.taskList(LuanManage.userInfo?.token ?? "")).mapObject(ArrayWrapper<TaskModel>.self).validate().showToastWhenFailured().subscribe(onSuccess: { [weak self] (result) in
            self?.taskArray = result.data ?? [TaskModel]()
            self?.tableView.reloadData()
        }) { [weak self] (_) in
            self?.navigationController?.popViewController()
        }.disposed(by: disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TaskDetail" {
            let detail = segue.destination as? TaskDetailViewController
            detail?.taskModel = sender as? TaskModel
        }
    }
    
}

extension TaskListViewController: TaskListCellDelegate {
    func receiveTask(section: Int) {
        if LuanManage.userInfo?.vipLevel ?? 0 > 0 {
            taskService.rx.request(.receiveTask((LuanManage.userInfo?.token ?? ""), (taskArray[section].tid ?? 0))).mapObject(DicResult.self).validate().showToastWhenFailured().subscribe(onSuccess: { [weak self] (result) in
                self?.view.makeToast("领取成功")
                if let task = result.data?["task"] as? [String : Any], let model = Mapper<TaskModel>().map(JSON: task) {
                    self?.taskArray[section] = model
                }
                self?.performSegue(withIdentifier: "TaskDetail", sender: self?.taskArray[section])
            }).disposed(by: disposeBag)
        } else {
            let vip = R.storyboard.home().instantiateViewController(withIdentifier: "VipViewController") as! VipViewController
            navigationController?.pushViewController(vip)
        }
    }
}

extension TaskListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return taskArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskListTableViewCell", for: indexPath) as! TaskListTableViewCell
        cell.tag = indexPath.section
        cell.delegate = self
        let task = taskArray[indexPath.section]
        cell.titleLabel.text = task.tName
        cell.timeLabel.text = task.createTime
        cell.numberLabel.text = "任务" + Common.intIntoString(number: indexPath.section + 1)
        cell.statusBtn.isEnabled = (task.status ?? 0) == 0
        if indexPath.section % 2 == 0 {
            cell.numberBgImage.image = R.image.task_green()?.tint(UIColor(hexString: "EE4036")!, blendMode: CGBlendMode.overlay)
        } else {
            cell.numberBgImage.image = R.image.task_green()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        performSegue(withIdentifier: "TaskDetail", sender: taskArray[indexPath.section])
    }
    
}
