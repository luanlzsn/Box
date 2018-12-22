//
//  FMDefault.swift
//  Tocos
//
//  Created by luan on 2018/11/1.
//  Copyright © 2018 luan. All rights reserved.
//

import UIKit

func LuanLog<N>(_ message:N,fileName:String = #file,methodName:String = #function,lineNumber:Int = #line) {
    #if DEBUG
        print("类\(fileName as NSString)的\(methodName)方法第\(lineNumber)行:\(message)");
    #endif
}

let kWindow = UIApplication.shared.keyWindow
let kMainColor = UIColor(hexString: "0396FF")!

let kBasePath = URL(string: "http://39.98.62.198/yuanzihe/api/")!
let kImagePath = "http://39.98.62.198"

let kVipLevelImageArray = ["diamond_gray", "diamond_red", "diamond_yellow", "diamond_blue", "diamond_black"]//会员等级图片数组

let taskStatusArray = ["待提交", "待审核", "已完成", "审核失败"]

//NSUserDefaults
let kUserInfo = "kUserInfo"
let kWalletAddress = "kWalletAddress"

typealias ConfirmBlock = (_ value: Any) ->()
typealias CancelBlock = () ->()
