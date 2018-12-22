//
//  PaymentViewController.swift
//  Box
//
//  Created by luan on 2018/12/16.
//  Copyright © 2018 luan. All rights reserved.
//

import UIKit

class PaymentViewController: LuanViewController {

    @IBOutlet weak var qrCodeImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        userService.rx.request(.alipayQrCode).mapObject(DicResult.self).validate().showToastWhenFailured().subscribe(onSuccess: { [weak self] (result) in
            if let image = result.data?["image"] as? String {
                if image.isValidUrl == true {
                    self?.qrCodeImage.kf.setImage(with: URL(string: image))
                } else {
                    self?.qrCodeImage.kf.setImage(with: URL(string: kImagePath + image))
                }
            }
        }) { [weak self] (_) in
            self?.navigationController?.popViewController()
        }.disposed(by: disposeBag)
    }
    
    @IBAction func didTapSaveQrCodeImage() {
        if let image = qrCodeImage.image {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(image:didFinishSavingWithError:contextInfo:)), nil)
        } else {
            view.makeToast("保存失败")
        }
    }
    
    @objc private func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        if error != nil {
            view.makeToast(error?.localizedDescription)
            return
        }
        view.makeToast("保存成功")
    }
    
}
