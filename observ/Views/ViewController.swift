//
//  ViewController.swift
//  observ
//
//  Created by unkonow on 2020/11/22.
//

import UIKit
import PTCardTabBar

class ViewController: PTCardTabBarController {

    override func viewDidLoad() {
        let vc1 = HomeViewController()
        let vc2 =  LabelViewController(title: "test")
        
        vc1.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "home"), tag: 1)
        vc2.tabBarItem = UITabBarItem(title: "Fav", image: UIImage(named: "calendar"), tag: 2)
        
        self.viewControllers = [vc1, vc2]
        
        super.viewDidLoad()
    }
}
