//
//  File.swift
//  NiceLoo
//
//  Created by NiceLoo on 2017/8/21.
//  Copyright © 2017年 张书鹏. All rights reserved.
//

import UIKit

extension AppDelegate {
    func switchRootVc() {
        let sb = UIStoryboard(name: "Home", bundle: nil)
        let vc = sb.instantiateInitialViewController()
        let nav = BaseNavigationViewController(rootViewController: vc!)
        window?.rootViewController = nav
    }
}
