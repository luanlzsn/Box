//
//  TeamDetailViewController.swift
//  Box
//
//  Created by luan on 2018/11/26.
//  Copyright © 2018 luan. All rights reserved.
//

import UIKit
import ObjectMapper

class TeamDetailViewController: LuanViewController {

    @IBOutlet weak var avaterImage: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var levelImage: UIImageView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var model: UserModel?
    var userArray = [UserModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(R.nib.teamListTableViewCell(), forCellReuseIdentifier: "TeamListTableViewCell")
        refreshInfo()
        getTeamDetail()
    }
    
    func getTeamDetail() {
        userService.rx.request(.teamDetail((model?.vid ?? 0))).mapObject(DicResult.self).validate().showToastWhenFailured().subscribe(onSuccess: { [weak self] (result) in
            if let info = result.data?["vips"] as? [String : Any] {
                if let list = info["data"] as? [[String : Any]] {
                    self?.userArray = Mapper<UserModel>().mapArray(JSONArray: list)
                    self?.tableView.reloadData()
                }
                if let vip = info["vip"] as? [String : Any] {
                    self?.model = Mapper<UserModel>().map(JSON: vip)
                    self?.refreshInfo()
                }
            }
        }) { [weak self] (_) in
            self?.navigationController?.popViewController()
        }.disposed(by: disposeBag)
    }
    
    func refreshInfo() {
        avaterImage.kf.setImage(with: URL(string: kImagePath + (model?.head ?? "")), placeholder: R.image.avater_default())
        nicknameLabel.text = model?.vipName
        levelImage.image = model?.getVipImage()
        numberLabel.text = "\(userArray.count)人"
    }
    
}

extension TeamDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamListTableViewCell", for: indexPath) as! TeamListTableViewCell
        let user = userArray[indexPath.row]
        cell.avaterImage.kf.setImage(with: URL(string: kImagePath + (user.head ?? "")), placeholder: R.image.avater_default())
        cell.nicknameLabel.text = user.vipName
        cell.levelImage.image = user.getVipImage()
        if user.vipPhone?.count ?? 0 > 8 {
            cell.phoneLabel.text = user.vipPhone?.nsString.replacingCharacters(in: NSRange(location: 3, length: 4), with: "****")
        } else {
            cell.phoneLabel.text = user.vipPhone
        }
        return cell
    }

}
