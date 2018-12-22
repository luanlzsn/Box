//
//  TaskViewController.swift
//  Box
//
//  Created by luan on 2018/11/20.
//  Copyright © 2018 luan. All rights reserved.
//

import UIKit
import SDCycleScrollView
import ObjectMapper

class TaskViewController: LuanViewController {

    @IBOutlet weak var bannerView: SDCycleScrollView!
    var bannerArray = [BannerModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "任务中心"
        
        bannerView.bannerImageViewContentMode = .scaleAspectFill
        bannerView.delegate = self
        getBannerInfo()
    }
    
    func getBannerInfo() {
        bannerService.rx.request(.taskBanner).mapObject(DicResult.self).validate().showToastWhenFailured().subscribe(onSuccess: { [weak self] (result) in
            if let list = result.data?["list"] as? [[String : Any]] {
                self?.bannerArray = Mapper<BannerModel>().mapArray(JSONArray: list)
                self?.bannerView.imageURLStringsGroup = self?.bannerArray.map({ (bannerModel) -> String in
                    if bannerModel.cover?.isValidUrl == true {
                        return bannerModel.cover ?? ""
                    } else {
                        return kImagePath + (bannerModel.cover ?? "")
                    }
                })
            }
        }).disposed(by: disposeBag)
    }

}

extension TaskViewController: SDCycleScrollViewDelegate {
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {
        if let url = bannerArray[index].url, url.isEmpty == false {
            let web = LuanWebViewController()
            web.urlStr = url
            navigationController?.pushViewController(web)
        }
    }
}
