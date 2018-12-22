//
//  LuanTool.swift
//  Box
//
//  Created by luan on 2018/11/20.
//  Copyright © 2018 luan. All rights reserved.
//

let LuanManage = LuanTool.sharedInstance

class LuanTool: NSObject {
    
    static let sharedInstance = LuanTool()
    
    @objc dynamic var isLogin = false
    var userInfo: UserModel? {
        didSet {
            if userInfo == nil {
                UserDefaults.standard.removeObject(forKey: kUserInfo)
                UserDefaults.standard.synchronize()
                isLogin = false
            } else {
                UserDefaults.standard.setValue(NSKeyedArchiver.archivedData(withRootObject: userInfo!), forKey: kUserInfo)
                UserDefaults.standard.synchronize()
                if isLogin == false {
                    isLogin = true
                }
            }
        }
    }
    
}
