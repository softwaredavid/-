//
//  BaseNavigationViewController.swift
//  PartOfXib
//
//  Created by Apple on 2017/6/26.
//  Copyright © 2017年 WangDaoLeTu. All rights reserved.
//

import UIKit

class BaseNavigationViewController: UINavigationController,UIGestureRecognizerDelegate,UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.isEnabled = true
        interactivePopGestureRecognizer?.delegate = self
        delegate = self
        configNavBar()
    }
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return viewControllers.count > 1
    }
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: true)
        
    }
    func configNavBar() {
        createTitle()
        let bar = UINavigationBar.appearance()
        bar.isTranslucent = false
        navigationBar.barTintColor = #colorLiteral(red: 0.1882352941, green: 0.2470588235, blue: 0.6235294118, alpha: 1)
        let dic = [NSAttributedStringKey.foregroundColor:UIColor.white,NSAttributedStringKey.font:UIFont.systemFont(ofSize: 16)]
        bar.titleTextAttributes = dic
    }
    func createTitle() {
        let la = UILabel(frame: CGRect(x: 20, y: 12, width: screen_heigh - 20, height: 20))
        la.text = "智能化粮库综合信息系统"
        la.textColor = UIColor.white
        la.font = UIFont.boldSystemFont(ofSize: 18)
        la.tag = 1000
        navigationBar.addSubview(la)
    }
}
