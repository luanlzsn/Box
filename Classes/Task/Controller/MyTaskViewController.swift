//
//  MyTaskViewController.swift
//  Box
//
//  Created by luan on 2018/11/25.
//  Copyright © 2018 luan. All rights reserved.
//

import UIKit
import ObjectMapper

class MyTaskViewController: LuanViewController {

    @IBOutlet weak var tableView: UITableView!
    var taskArray = [TaskRecordModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getMyTask()
    }
    
    func getMyTask() {
        taskService.rx.request(.putTaskList(LuanManage.userInfo?.token ?? "")).mapObject(DicResult.self).validate().showToastWhenFailured().subscribe(onSuccess: { [weak self] (result) in
            if let list = result.data?["list"] as? [[String : Any]] {
                self?.taskArray = Mapper<TaskRecordModel>().mapArray(JSONArray: list)
                self?.tableView.reloadData()
            }
        }).disposed(by: disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SubmitTask" {
            let submit = segue.destination as? SubmitTaskViewController
            let section = (sender as? Int) ?? 0
            submit?.taskModel = taskArray[section]
            submit?.numberStr = "任务" + Common.intIntoString(number: section + 1)
        }
    }

}

extension MyTaskViewController: UITableViewDataSource, UITableViewDelegate {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyTaskTableViewCell", for: indexPath) as! MyTaskTableViewCell
        cell.tag = indexPath.section
        let task = taskArray[indexPath.section]
        cell.titleLabel.text = task.tName
        cell.numberLabel.text = "任务" + Common.intIntoString(number: indexPath.section + 1)
        cell.statusLabel.text = taskStatusArray[task.status ?? 0]
        if indexPath.section % 2 == 0 {
            cell.numberBgImage.image = R.image.task_green()?.tint(UIColor(hexString: "EE4036")!, blendMode: CGBlendMode.overlay)
        } else {
            cell.numberBgImage.image = R.image.task_green()
        }
        return cell
    }

}
