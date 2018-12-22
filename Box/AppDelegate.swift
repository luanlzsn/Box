//
//  AppDelegate.swift
//  Box
//
//  Created by luan on 2018/11/20.
//  Copyright © 2018 luan. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Toast_Swift
import Rswift
import SwifterSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //导航栏返回按钮颜色
        UINavigationBar.appearance().tintColor = UIColor(hexString: "333333")
        //导航栏背景颜色
        UINavigationBar.appearance().barTintColor = UIColor.white
        //导航栏字体设置
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor(hexString: "333333")!, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18)]
        
        //设置tabber颜色
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.init(hexString: "999999")!], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : kMainColor], for: .selected)
        
        //重置推送角标为零
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        setupToast()
        
        if let userData = UserDefaults.standard.object(forKey: kUserInfo) as? Data {
            LuanManage.userInfo = NSKeyedUnarchiver.unarchiveObject(with: userData) as? UserModel
        }
        
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white
        
        if LuanManage.isLogin {
            self.window?.rootViewController = LuanTabBarViewController()
        } else {
            self.window?.rootViewController = R.storyboard.login().instantiateInitialViewController()
        }
        
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    func setupToast() {
        ToastManager.shared.style.messageFont = UIFont.systemFont(ofSize: 14)
        ToastManager.shared.style.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        ToastManager.shared.style.cornerRadius = 5
        ToastManager.shared.style.verticalPadding = 6
        ToastManager.shared.position = .center
        ToastManager.shared.duration = 2
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

