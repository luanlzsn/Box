//
//  TeamListViewController.swift
//  Box
//
//  Created by luan on 2018/11/26.
//  Copyright © 2018 luan. All rights reserved.
//

import UIKit
import SwifterSwift
import ObjectMapper

class TeamListViewController: LuanViewController {

    @IBOutlet weak var directBtn: UIButton!
    @IBOutlet weak var indirectBtn: UIButton!
    @IBOutlet weak var lineLeft: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var directTable: UITableView!
    @IBOutlet weak var indirectTable: UITableView!
    var oneArray = [UserModel]()
    var twoArray = [UserModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        directTable.register(R.nib.teamListTableViewCell(), forCellReuseIdentifier: "TeamListTableViewCell")
        indirectTable.register(R.nib.teamListTableViewCell(), forCellReuseIdentifier: "TeamListTableViewCell")
        lineLeft.constant = (SwifterSwift.screenWidth / 2.0 - 110) / 2.0
        getTeamList(type: 1)
        getTeamList(type: 2)
    }
    
    func getTeamList(type: Int) {
        userService.rx.request(.myTeam((LuanManage.userInfo?.token ?? ""), type)).mapObject(DicResult.self).validate().showToastWhenFailured().subscribe(onSuccess: { [weak self] (result) in
            if type == 1 {
                if let dic = result.data?["one"] as? [String : Any], let list = dic["data"] as? [[String : Any]] {
                    self?.oneArray = Mapper<UserModel>().mapArray(JSONArray: list)
                    self?.directBtn.setTitle("直推一代（\((self?.oneArray.count ?? 0))人）", for: .normal)
                    self?.directTable.reloadData()
                }
            } else {
                if let dic = result.data?["two"] as? [String : Any], let list = dic["data"] as? [[String : Any]] {
                    self?.twoArray = Mapper<UserModel>().mapArray(JSONArray: list)
                    self?.indirectBtn.setTitle("间推二代（\((self?.twoArray.count ?? 0))人）", for: .normal)
                    self?.indirectTable.reloadData()
                }
            }
        }).disposed(by: disposeBag)
    }
    
    @IBAction func didTapDirect(_ sender: UIButton) {
        directBtn.isEnabled = false
        indirectBtn.isEnabled = true
        lineLeft.constant = (SwifterSwift.screenWidth / 2.0 - 110) / 2.0
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        directTable.reloadData()
    }
    
    @IBAction func didTapIndirect(_ sender: UIButton) {
        directBtn.isEnabled = true
        indirectBtn.isEnabled = false
        lineLeft.constant = (SwifterSwift.screenWidth / 2.0 - 110) / 2.0 + SwifterSwift.screenWidth / 2.0
        scrollView.setContentOffset(CGPoint(x: SwifterSwift.screenWidth, y: 0), animated: true)
        indirectTable.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TeamDetail" {
            let detail = segue.destination as? TeamDetailViewController
            detail?.model = sender as? UserModel
        }
    }

}

extension TeamListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (tableView == directTable) ? oneArray.count : twoArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamListTableViewCell", for: indexPath) as! TeamListTableViewCell
        let model = (tableView == directTable) ? oneArray[indexPath.row] : twoArray[indexPath.row]
        cell.avaterImage.kf.setImage(with: URL(string: kImagePath + (model.head ?? "")), placeholder: R.image.avater_default())
        cell.nicknameLabel.text = model.vipName
        cell.levelImage.image = model.getVipImage()
        if model.vipPhone?.count ?? 0 > 8 {
            cell.phoneLabel.text = model.vipPhone?.nsString.replacingCharacters(in: NSRange(location: 3, length: 4), with: "****")
        } else {
            cell.phoneLabel.text = model.vipPhone
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if tableView == directTable {
            performSegue(withIdentifier: "TeamDetail", sender: oneArray[indexPath.row])
        }
    }
}

extension TeamListViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let tag = (scrollView.contentOffset.x / SwifterSwift.screenWidth).int
        if tag == 0 {
            didTapDirect(directBtn)
        } else {
            didTapIndirect(indirectBtn)
        }
    }
}
