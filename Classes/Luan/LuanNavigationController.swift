//
//  FMNavigationController.swift
//  Tocos
//
//  Created by luan on 2018/11/1.
//  Copyright © 2018 luan. All rights reserved.
//

import UIKit

class LuanNavigationController: UINavigationController {
    
    let controllerNameArray = ["HomeViewController", "TaskViewController", "MineViewController"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationBar.isTranslucent = false
        if responds(to: #selector(getter: interactivePopGestureRecognizer)) {
            interactivePopGestureRecognizer?.delegate = self
            delegate = self
        }
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.responds(to: #selector(getter: interactivePopGestureRecognizer)) {
            interactivePopGestureRecognizer?.isEnabled = false
        }
        if controllerNameArray.contains(String(describing: viewController.classForCoder)) == false {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
        if viewControllers.count > 1 {
            checkItem(viewController)
        }
    }
    
    func checkItem(_ viewController: UIViewController) {
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: R.image.nav_back()!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), style: UIBarButtonItem.Style.plain, target: self, action: #selector(backSuperiorController))
    }
    
    @objc func backSuperiorController() {
        popViewController(animated: true)
    }

}

extension LuanNavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if responds(to: #selector(getter: interactivePopGestureRecognizer)) {
            interactivePopGestureRecognizer?.isEnabled = true
        }
    }
}

extension LuanNavigationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
