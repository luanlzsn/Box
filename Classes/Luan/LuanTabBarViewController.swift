//
//  FMTabBarViewController.swift
//  Tocos
//
//  Created by luan on 2018/11/7.
//  Copyright © 2018 luan. All rights reserved.
//

import UIKit

class LuanTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        delegate = self
        tabBar.isTranslucent = false
        
        let storyboardNameArray = ["Home", "Task", "Mine"]
        let imageNameArray = ["home_icon", "task_icon", "mine_icon"]
        let selectImageNameArray = ["home_icon_select", "task_icon_select", "mine_icon_select"]
        let itemTitleArray = ["首页", "任务中心", "我的"]
        
        var controllerArray = [UIViewController]()
        
        for i in 0..<storyboardNameArray.count {
            let nav = UIStoryboard(name: storyboardNameArray[i], bundle: Bundle.main).instantiateInitialViewController()!
            let item = UITabBarItem(title: itemTitleArray[i], image: UIImage(named: imageNameArray[i])?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: selectImageNameArray[i])?.withRenderingMode(.alwaysOriginal))
            nav.tabBarItem = item
            controllerArray.append(nav)
        }
        viewControllers = controllerArray
    }
    
}

extension LuanTabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
}
