//
//  AddressListViewController.swift
//  Box
//
//  Created by luan on 2018/11/27.
//  Copyright © 2018 luan. All rights reserved.
//

import UIKit
import ObjectMapper

class AddressListViewController: LuanViewController {

    @IBOutlet weak var tableView: UITableView!
    var addressArray = [AddressModel]()
    @IBOutlet weak var addBtn: UIButton!
    var isRequestFirst = true//是否是第一次请求
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(deleteAddress), name: NSNotification.Name("DeleteAddress"), object: nil)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 75
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getMyAddress()
    }
    
    // MARK: - 删除地址
    @objc func deleteAddress() {
        let alert = UIAlertController(title: "提示", message: "是否删除地址？", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { [weak self] (_) in
            let address = self?.addressArray.first
            userService.rx.request(.removeAddress(address?.id ?? 0)).mapObject(LuanResult.self).validate().showToastWhenFailured().subscribe(onSuccess: { [weak self] (_) in
                self?.view.makeToast("删除成功")
                self?.addressArray.removeFirst()
                self?.addBtn.isHidden = false
                self?.tableView.reloadData()
            }).disposed(by: self!.disposeBag)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - 获取我的地址
    func getMyAddress() {
        userService.rx.request(.myAddress(LuanManage.userInfo?.token ?? "")).mapObject(DicResult.self).validate().showToastWhenFailured().subscribe(onSuccess: { [weak self] (result) in
            if let array = result.data?["address"] as? [[String : Any]] {
                self?.addressArray = Mapper<AddressModel>().mapArray(JSONArray: array)
                self?.tableView.reloadData()
                self?.addBtn.isHidden = (self?.addressArray.count ?? 0) > 0
                if self?.isRequestFirst ?? false == true, self?.addressArray.count ?? 0 == 0 {
                    self?.performSegue(withIdentifier: "AddAddress", sender: nil)
                }
                self?.isRequestFirst = false
            }
        }) { [weak self] (_) in
            self?.navigationController?.popViewController()
        }.disposed(by: disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddAddress" {
            let address = segue.destination as? AddAddressViewController
            if let row = sender as? Int {
                address?.address = addressArray[row]
                address?.isEdit = true
            }
        }
    }

}

extension AddressListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addressArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressListTableViewCell", for: indexPath) as! AddressListTableViewCell
        let address = addressArray[indexPath.row]
        cell.nameLabel.text = address.people
        cell.phoneLabel.text = address.phone
        cell.addressLabel.text = address.content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        performSegue(withIdentifier: "AddAddress", sender: indexPath.row)
    }
}
