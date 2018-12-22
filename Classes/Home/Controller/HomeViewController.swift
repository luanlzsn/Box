//
//  HomeViewController.swift
//  Box
//
//  Created by luan on 2018/11/20.
//  Copyright © 2018 luan. All rights reserved.
//

import UIKit
import SwifterSwift
import SDCycleScrollView
import ObjectMapper

class HomeViewController: LuanViewController {

    @IBOutlet weak var collection: UICollectionView!
    let menuArray = ["home_one", "home_two", "home_three", "home_four", "home_five", "home_six", "home_seven", "home_eight", "home_nine"]
    let identifierArray = ["Vip", "QRCode", "Commission", "Course", "", "", "", "", "CustomerService"]
    var bannerArray = [BannerModel]()
    var newArray = [NewsModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "首页"
        getBannerInfo()
    }
    
    func getBannerInfo() {
        bannerService.rx.request(.homeBanner).mapObject(DicResult.self).validate().showToastWhenFailured().subscribe(onSuccess: { [weak self] (result) in
            if let list = result.data?["list"] as? [[String : Any]] {
                self?.bannerArray = Mapper<BannerModel>().mapArray(JSONArray: list)
                self?.collection.reloadData()
            }
        }).disposed(by: disposeBag)
        bannerService.rx.request(.news).mapObject(DicResult.self).validate().showToastWhenFailured().subscribe(onSuccess: { [weak self] (result) in
            if let news = result.data?["news"] as? [[String : Any]] {
                self?.newArray = Mapper<NewsModel>().mapArray(JSONArray: news)
                self?.collection.reloadData()
            }
        }).disposed(by: disposeBag)
    }
    
}

extension HomeViewController: SDCycleScrollViewDelegate {
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {
        if let url = bannerArray[index].url, url.isEmpty == false {
            let web = LuanWebViewController()
            web.urlStr = url
            navigationController?.pushViewController(web)
        }
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (SwifterSwift.screenWidth - 10) / 3.0
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: SwifterSwift.screenWidth, height: SwifterSwift.screenWidth / 375 * 200 + 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HomeCollectionReusableView", for: indexPath) as! HomeCollectionReusableView
            header.bannerView.bannerImageViewContentMode = .scaleAspectFill
            header.bannerView.delegate = self
            
            header.bannerView.imageURLStringsGroup = bannerArray.map({ (bannerModel) -> String in
                if bannerModel.cover?.isValidUrl == true {
                    return bannerModel.cover ?? ""
                } else {
                    return kImagePath + (bannerModel.cover ?? "")
                }
            })
            var str = ""
            for newsModel in newArray {
                str += ((newsModel.content ?? "") + "\n")
            }
            header.checkNotice(text: str)
            
            return header
        } else {
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
        cell.imgView.image = UIImage(named: menuArray[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if identifierArray[indexPath.row] != "" {
            if identifierArray[indexPath.row] == "Vip" {
                if LuanManage.userInfo?.vipLevel ?? 0 > 2 {
                    performSegue(withIdentifier: "Payment", sender: nil)
                } else {
                    performSegue(withIdentifier: "Vip", sender: nil)
                }
            } else if identifierArray[indexPath.row] == "QRCode" {
                if LuanManage.userInfo?.vipLevel ?? 0 > 0 {
                    performSegue(withIdentifier: "QRCode", sender: nil)
                } else {
                    performSegue(withIdentifier: "Vip", sender: nil)
                }
            } else {
                performSegue(withIdentifier: identifierArray[indexPath.row], sender: nil)
            }
        } else {
            view.makeToast("功能正在研发中,\n请等待...")
        }
    }
}
