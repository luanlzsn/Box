//
//  CycleScrollView.swift
//  MoFan
//
//  Created by luan on 2017/2/7.
//  Copyright © 2017年 luan. All rights reserved.
//

import UIKit
import Kingfisher
import SwifterSwift

@objc protocol CycleScrollView_Delegate {
    func didSelectBanner(index: Int)
}

class CycleScrollView: UIView, UIScrollViewDelegate {
    
    var totalPage = 0//图片总张数
    var curPage = 0//当前滚的是第几张
    var scrollTimer : Timer?
    var scrollView = UIScrollView()
    var imagesArray = [String]()
    var curImages = [String]()
    var pageControl = UIPageControl()
    weak var delegate : CycleScrollView_Delegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        scrollView.backgroundColor = UIColor.clear
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: SwifterSwift.screenWidth * 3.0, height: height)
        insertSubview(scrollView, at: 0)
        
        pageControl.pageIndicatorTintColor = UIColor.init(white: 1, alpha: 0.5)
        pageControl.currentPageIndicatorTintColor = UIColor.white
        addSubview(pageControl)
        
        refreshScrollView()
    }
    
    //MARK: - 设置banner数据
    func setBannerWithUrlArry(urlArry: [String]) {
        totalPage = urlArry.count
        curPage = 1
        imagesArray = urlArry
        pageControl.numberOfPages = totalPage
        pageControl.currentPage = curPage - 1
        refreshScrollView()
        if totalPage > 1 {
            starTimer()
            scrollView.isScrollEnabled = true
        } else {
            stopTimer()
            scrollView.isScrollEnabled = false
        }
    }
    
    //MARK: - 点击banner
    @objc func handleTap() {
        delegate?.didSelectBanner(index: curPage - 1)
    }
    
    func refreshScrollView() {
        if imagesArray.isEmpty {
            return
        }
        let views = scrollView.subviews
        for subView in views {
            subView.removeFromSuperview()
        }
        getDisplayImagesWithCurpage(page: curPage)
        
        for i in 0..<3 {
            let imageView = UIImageView(frame: CGRect(x: SwifterSwift.screenWidth * CGFloat(i), y: 0, width: SwifterSwift.screenWidth, height: height))
            imageView.isUserInteractionEnabled = true
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFill
            imageView.kf.setImage(with: URL(string: curImages[i]))
            let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
            imageView.addGestureRecognizer(singleTap)
            scrollView.addSubview(imageView)
        }
        scrollView.setContentOffset(CGPoint(x: SwifterSwift.screenWidth, y: 0), animated: false)
    }
    
    func getDisplayImagesWithCurpage(page: Int) {
        let pre = validPageValue(value: curPage - 1)
        let last = validPageValue(value: curPage + 1)
        if !curImages.isEmpty {
            curImages.removeAll()
        }
        curImages.append(imagesArray[pre - 1])
        curImages.append(imagesArray[curPage - 1])
        curImages.append(imagesArray[last - 1])
    }
    
    func validPageValue(value: Int) -> Int {
        var pageValue = value
        if value == 0 {
            pageValue = totalPage
        }
        if value == totalPage + 1 {
            pageValue = 1
        }
        return pageValue
    }
    
    //MARK: - 停止计时器
    func stopTimer() {
        if scrollTimer != nil {
            scrollTimer?.invalidate()
            scrollTimer = nil
        }
    }
    
    //MARK: - 启动计时器
    func starTimer() {
        if scrollTimer == nil {
            createTimer()
        }
    }
    
    //MARK: - 创建计时器
    func createTimer() {
        scrollTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(refreshScroller), userInfo: nil, repeats: true)
    }
    
    @objc func refreshScroller() {
        scrollView.setContentOffset(CGPoint(x: SwifterSwift.screenWidth * 2, y: 0), animated: true)
    }
    
    //MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x >= SwifterSwift.screenWidth * 2 {
            curPage = validPageValue(value: curPage + 1)
            refreshScrollView()
        }
        if scrollView.contentOffset.x <= 0 {
            curPage = validPageValue(value: curPage - 1)
            refreshScrollView()
        }
        pageControl.currentPage = curPage - 1
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //手动滑动图片时停止计时器
        stopTimer()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //手动滑动结束后开启计时器
        starTimer()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.frame = bounds
        pageControl.frame = CGRect(x: SwifterSwift.screenWidth - pageControl.width - 30, y: height - 30, width: pageControl.width, height: 20)
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
