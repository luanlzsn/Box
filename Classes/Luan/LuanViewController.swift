//
//  FMViewController.swift
//  Tocos
//
//  Created by luan on 2018/11/1.
//  Copyright © 2018 luan. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class LuanViewController: UIViewController {

    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = UIColor(hexString: "F8F8F8")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        view.endEditing(true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
