//
//  AppUtil.swift
//  NiceLooCRM
//
//  Created by NiceLoo on 2017/8/28.
//  Copyright © 2017年 NiceLoo. All rights reserved.
//

import UIKit

class AppUtil: NSObject {
    // MARK: == 得到当前App的版本
    static func getCurentAppVersion() -> String {
        return "\(Bundle.main.infoDictionary!["CFBundleShortVersionString"]!)"
    }
    static func getCurrentTime() -> String {
        let dateF = DateFormatter()
        dateF.dateFormat = "YYY-MM-dd HH:mm:ss"
        return dateF.string(from: Date())
    }
    // MARK: == 从storyBoard得到ViewCntroller
    static func getViewController<T: UIViewController>(storyBoard: String, identify: String) -> T {
        let sb = UIStoryboard(name: storyBoard, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: identify) as! T
        return vc
    }
    // MARK: == 得到key Window
    static func getKeyWindow() -> UIWindow? {
        return UIApplication.shared.keyWindow
    }
}
