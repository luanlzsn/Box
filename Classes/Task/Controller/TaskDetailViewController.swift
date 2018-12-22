//
//  TaskDetailViewController.swift
//  Box
//
//  Created by luan on 2018/11/25.
//  Copyright © 2018 luan. All rights reserved.
//

import UIKit
import SwifterSwift
import ObjectMapper

class TaskDetailViewController: LuanViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var copyBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var receiveHeight: NSLayoutConstraint!
    var taskModel: TaskModel?
    var heightDic = [String : CGFloat]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshTaskDetail()
    }
    
    @IBAction func didTapCopy() {
        UIPasteboard.general.string = descLabel.text
        view.makeToast("复制成功")
    }
    
    @IBAction func didTapReceiveTask() {
        if LuanManage.userInfo?.vipLevel ?? 0 > 0 {
            taskService.rx.request(.receiveTask((LuanManage.userInfo?.token ?? ""), (taskModel?.tid ?? 0))).mapObject(DicResult.self).validate().showToastWhenFailured().subscribe(onSuccess: { [weak self] (result) in
                self?.view.makeToast("领取成功")
                if let task = result.data?["task"] as? [String : Any] {
                    self?.taskModel = Mapper<TaskModel>().map(JSON: task)
                    self?.refreshTaskDetail()
                }
            }).disposed(by: disposeBag)
        } else {
            let vip = R.storyboard.home().instantiateViewController(withIdentifier: "VipViewController") as! VipViewController
            navigationController?.pushViewController(vip)
        }
    }
    
    func refreshTaskDetail() {
        receiveHeight.constant = ((taskModel?.status ?? 0) == 1) ? 0 : 49
        copyBtn.isEnabled = ((taskModel?.status ?? 0) == 1)
        titleLabel.text = taskModel?.tName
        descLabel.text = taskModel?.content
        tableView.reloadData()
    }
    
    func refreshTableHeight() {
        var tableH: CGFloat = 0
        for height in heightDic.values {
            tableH += height
        }
        tableHeight.constant = tableH
    }

}

extension TaskDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskModel?.image?.components(separatedBy: ",").count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let url = taskModel?.image?.components(separatedBy: ",")[indexPath.row] ?? ""
        if heightDic.keys.contains(url) {
            return heightDic[url] ?? 0
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskDetailTableViewCell", for: indexPath) as! TaskDetailTableViewCell
        let url = taskModel?.image?.components(separatedBy: ",")[indexPath.row] ?? ""
        let imgUrl: URL?
        if url.isValidUrl == true {
            imgUrl = URL(string: url)
        } else {
            imgUrl = URL(string: kImagePath + url)
        }
        if heightDic.keys.contains(url) {
            cell.imgView.kf.setImage(with: imgUrl)
        } else {
            cell.imgView.kf.setImage(with: imgUrl) { [weak self] (image, error, _, _) in
                if error == nil {
                    let size = image?.size ?? .zero
                    self?.heightDic[url] = (SwifterSwift.screenWidth - 30) * size.height / size.width
                    self?.refreshTableHeight()
                    self?.tableView.reloadData()
                } else {
                    self?.heightDic[url] = 0
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let alert = UIAlertController(title: "系统提示", message: "保存图片到系统相册", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { [unowned self] (_) in
            let cell = tableView.cellForRow(at: indexPath) as? TaskDetailTableViewCell
            if let image = cell?.imgView?.image {
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(image:didFinishSavingWithError:contextInfo:)), nil)
            } else {
                self.view.makeToast("保存失败")
            }
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        if error != nil {
            view.makeToast(error?.localizedDescription)
            return
        }
        view.makeToast("保存成功")
    }
}
