//
//  SubmitTaskViewController.swift
//  Box
//
//  Created by luan on 2018/11/25.
//  Copyright © 2018 luan. All rights reserved.
//

import UIKit
import TZImagePickerController
import SwifterSwift
import JXPhotoBrowser

class SubmitTaskViewController: LuanViewController {

    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var submitBtn: UIButton!
    var numberStr = ""
    var taskModel: TaskRecordModel?
    var selectImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(R.nib.submitTaskCollectionViewCell(), forCellWithReuseIdentifier: "SubmitTaskCollectionViewCell")
        numberLabel.text = numberStr
        titleLabel.text = taskModel?.tName
    }
    
    @IBAction func didTapSubmitTask() {
        uploadImage()
    }
    
    func uploadImage() {
        taskService.rx.request(.uploadImg([selectImage!])).mapObject(DicResult.self).validate().showToastWhenFailured().subscribe(onSuccess: { [weak self] (result) in
            if let list = result.data?["list"] as? [[String : Any]], let path = list.first?["path"] as? String {
                self?.submitTask(path: path)
            }
        }).disposed(by: disposeBag)
    }
    
    func submitTask(path: String) {
        taskService.rx.request(.submitTask((taskModel?.id ?? 0), path)).mapObject(LuanResult.self).validate().showToastWhenFailured().subscribe(onSuccess: { [weak self] (_) in
            kWindow?.makeToast("任务提交成功\n请等待审核")
            self?.navigationController?.popViewController()
        }).disposed(by: disposeBag)
    }
    
}

extension SubmitTaskViewController: SubmitTaskCollectionViewCellDelegate {
    func deletePhoto(row: Int) {
        selectImage = nil
        submitBtn.isEnabled = false
        submitBtn.backgroundColor = submitBtn.isEnabled ? kMainColor : UIColor.lightGray
        collectionView.reloadData()
    }
}

extension SubmitTaskViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (SwifterSwift.screenWidth - 30 - 24) / 4.0
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubmitTaskCollectionViewCell", for: indexPath) as! SubmitTaskCollectionViewCell
        cell.tag = indexPath.row
        cell.delegate = self
        if selectImage != nil {
            cell.imgView.image = selectImage
            cell.deleteBtn.isHidden = false
        } else {
            cell.imgView.image = R.image.add_photo()
            cell.deleteBtn.isHidden = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectImage == nil {
            let picker = TZImagePickerController(maxImagesCount: 1, columnNumber: 3, delegate: self)!
            picker.allowPickingVideo = false
            present(picker, animated: true, completion: nil)
        } else {
            let dataSource = JXLocalDataSource(numberOfItems: {
                return 1
            }, localImage: { [unowned self] index -> UIImage? in
                return self.selectImage
            })
            // 打开浏览器
            JXPhotoBrowser(dataSource: dataSource).show(pageIndex: indexPath.item)
        }
    }
}

extension SubmitTaskViewController: TZImagePickerControllerDelegate {
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        selectImage = photos.first
        submitBtn.isEnabled = true
        submitBtn.backgroundColor = submitBtn.isEnabled ? kMainColor : UIColor.lightGray
        collectionView.reloadData()
    }
}
