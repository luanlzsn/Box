//
//  FeedbackViewController.swift
//  Box
//
//  Created by luan on 2018/11/27.
//  Copyright © 2018 luan. All rights reserved.
//

import UIKit
import TZImagePickerController
import SwifterSwift
import JXPhotoBrowser
import RxSwift

class FeedbackViewController: LuanViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var submitBtn: UIButton!
    var imgArray = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(R.nib.submitTaskCollectionViewCell(), forCellWithReuseIdentifier: "SubmitTaskCollectionViewCell")
        bind()
    }
    
    @IBAction func didTapSubmit() {
        if imgArray.count > 0 {
            uploadImage()
        } else {
            submitFeedback(images: "")
        }
    }
    
    func uploadImage() {
        taskService.rx.request(.uploadImg(imgArray)).mapObject(DicResult.self).validate().showToastWhenFailured().subscribe(onSuccess: { [weak self] (result) in
            if let list = result.data?["list"] as? [[String : Any]] {
                let pathArray = list.map({ (dic) -> String in
                    return (dic["path"] as? String) ?? ""
                })
                self?.submitFeedback(images: pathArray.joined(separator: ","))
            }
        }).disposed(by: disposeBag)
    }
    
    func submitFeedback(images: String) {
        userService.rx.request(.feedback((LuanManage.userInfo?.token ?? ""), textView.text, images)).mapObject(LuanResult.self).validate().showToastWhenFailured().subscribe(onSuccess: { [weak self] (_) in
            kWindow?.makeToast("提交成功\n感谢您的反馈")
            self?.navigationController?.popViewController()
        }).disposed(by: disposeBag)
    }
    
    func bind() {
        textView.rx.text.orEmpty.map { (text) -> Bool in
            return text.count > 0
        }.subscribe(onNext: { [weak self] (isBool) in
            self?.submitBtn.isEnabled = isBool
            self?.submitBtn.backgroundColor = isBool ? kMainColor : UIColor.lightGray
        }).disposed(by: disposeBag)
    }

}

extension FeedbackViewController: SubmitTaskCollectionViewCellDelegate {
    func deletePhoto(row: Int) {
        imgArray.remove(at: row)
        submitBtn.isEnabled = imgArray.count > 0
        submitBtn.backgroundColor = submitBtn.isEnabled ? kMainColor : UIColor.lightGray
        collectionView.reloadData()
    }
}

extension FeedbackViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (SwifterSwift.screenWidth - 30 - 24) / 4.0
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if imgArray.count < 3 {
            return imgArray.count + 1
        } else {
            return imgArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubmitTaskCollectionViewCell", for: indexPath) as! SubmitTaskCollectionViewCell
        cell.tag = indexPath.row
        cell.delegate = self
        if imgArray.count < 3 {
            if indexPath.row < imgArray.count {
                cell.imgView.image = imgArray[indexPath.row]
                cell.deleteBtn.isHidden = false
            } else {
                cell.imgView.image = R.image.add_photo()
                cell.deleteBtn.isHidden = true
            }
        } else {
            cell.imgView.image = imgArray[indexPath.row]
            cell.deleteBtn.isHidden = false
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == imgArray.count {
            let picker = TZImagePickerController(maxImagesCount: 3 - imgArray.count, columnNumber: 3, delegate: self)!
            picker.allowPickingVideo = false
            present(picker, animated: true, completion: nil)
        } else {
            let dataSource = JXLocalDataSource(numberOfItems: { [unowned self] in
                return self.imgArray.count
                }, localImage: { index -> UIImage? in
                    return self.imgArray[index]
            })
            // 打开浏览器
            JXPhotoBrowser(dataSource: dataSource).show(pageIndex: indexPath.item)
        }
    }
}

extension FeedbackViewController: TZImagePickerControllerDelegate {
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        imgArray.append(contentsOf: photos)
        collectionView.reloadData()
    }
}
