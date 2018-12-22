//
//  InfoViewController.swift
//  Box
//
//  Created by luan on 2018/11/27.
//  Copyright © 2018 luan. All rights reserved.
//

import UIKit
import TZImagePickerController

class InfoViewController: LuanViewController {

    @IBOutlet weak var avaterImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        avaterImage.kf.setImage(with: URL(string: kImagePath + (LuanManage.userInfo?.head ?? "")), placeholder: R.image.avater_default())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameLabel.text = LuanManage.userInfo?.vipName
    }
    
    @IBAction func didTapAvater(_ sender: UITapGestureRecognizer) {
        let picker = TZImagePickerController(maxImagesCount: 1, columnNumber: 3, delegate: self)!
        picker.allowPickingVideo = false
        present(picker, animated: true, completion: nil)
    }
    
    func uploadAvater(avater: UIImage) {
        taskService.rx.request(.uploadImg([avater])).mapObject(DicResult.self).validate().showToastWhenFailured().subscribe(onSuccess: { [weak self] (result) in
            if let list = result.data?["list"] as? [[String : Any]], let path = list.first?["path"] as? String {
                self?.editAvater(url: path, avater: avater)
            }
        }).disposed(by: disposeBag)
    }
    
    func editAvater(url: String, avater: UIImage) {
        userService.rx.request(.editHead((LuanManage.userInfo?.token ?? ""), url)).mapObject(LuanResult.self).validate().showToastWhenFailured().subscribe(onSuccess: { [weak self] (_) in
            self?.avaterImage.image = avater
            self?.view.makeToast("头像修改成功")
        }).disposed(by: disposeBag)
    }
}

extension InfoViewController: TZImagePickerControllerDelegate {
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        uploadAvater(avater: photos[0])
    }
}
