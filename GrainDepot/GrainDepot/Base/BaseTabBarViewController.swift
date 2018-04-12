//
//  BaseTabBarViewController.swift
//  PartOfXib
//
//  Created by Apple on 2017/6/26.
//  Copyright © 2017年 WangDaoLeTu. All rights reserved.
//

import UIKit

struct TabBarPara {
    var title: String!
    var image: String!
    var selectImage: String!
    var vcName: String!
}
class BaseTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = 0
        addController()
    }
    
    private func addController() {
        addChildViewController(para: TabBarPara(title: "首页", image: "home", selectImage: "home_select", vcName: "Home"))
        addChildViewController(para: TabBarPara(title: "我的", image: "me", selectImage: "me_select", vcName: "Me"))
    }
    
    private func addChildViewController(para: TabBarPara) {
        
        let sb = UIStoryboard(name: para.vcName, bundle: nil)
        let vc = sb.instantiateInitialViewController()
        guard let v = vc else { return }
        
        v.tabBarItem.image = UIImage(named: para.image)
        v.tabBarItem.selectedImage = UIImage(named: para.selectImage)
        v.tabBarItem.title = para.title
        let nav = BaseNavigationViewController(rootViewController: v)
        addChildViewController(nav)
    }
}
