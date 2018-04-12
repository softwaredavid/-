//
//  Alert.swift
//  GrainDepot
//
//  Created by shuaitong du on 2017/11/2.
//  Copyright © 2017年 EdisonDu. All rights reserved.
//

import UIKit
import MBProgressHUD

struct AlertConfig {
    
    var offsetY: CGFloat = 0
    var offetX: CGFloat = 0
    var margin: CGFloat = 20
    var fontSize: CGFloat = 13
}

class Alert: NSObject {
    // MARK ---- 显示一个toast 1.5后自动消失
    static func show(text: String) {
        guard let hud = Alert.getMB(text: text) else { return }
        hud.offset.y = (screen_heigh - 64) / 2 - 100
        hud.margin = 10
        hud.removeFromSuperViewOnHide = true
        hud.hide(animated: true, afterDelay: 2)
    }
    
    // MARK ---- 显示一个toast 1.5后自动消失 加上配置
    static func show(text: String, config: AlertConfig) {
        guard let hud = Alert.getMB(text: text) else { return }
        hud.offset.y = config.offsetY
        hud.offset.x = config.offetX
        hud.label.font = UIFont.systemFont(ofSize: config.fontSize)
        hud.removeFromSuperViewOnHide = true
        hud.margin = config.margin
        hud.hide(animated: true, afterDelay: 1.5)
        
    }
    
    // MARK ---- 显示网络请求菊花
    @discardableResult
    static func showNoBackProgressView(text: String,view:UIView = AppUtil.getKeyWindow()! ) -> MBProgressHUD? {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.label.text = text
        hud.contentColor = UIColor.black
        hud.minSize = CGSize(width: 100, height: 50)
        return hud
    }
    
    // MARK ---- 显示网络请求菊花
    @discardableResult
    static func showProgressView(text: String,view:UIView = AppUtil.getKeyWindow()! ) -> MBProgressHUD? {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.label.text = text
        hud.minSize = CGSize(width: 100, height: 50)
        return hud
    }
    
    @discardableResult
    static func showProgressViewNoBack(text: String,view:UIView = AppUtil.getKeyWindow()! ) -> MBProgressHUD? {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.label.text = text
        hud.minSize = CGSize(width: 100, height: 50)
        return hud
    }
    
    private static func getMB(text: String) -> MBProgressHUD? {
        guard let window = AppUtil.getKeyWindow() else { return nil }
        let hud = MBProgressHUD.showAdded(to: window, animated: true)
        hud.mode = .text
        hud.detailsLabel.text = text
        hud.detailsLabel.font = UIFont.systemFont(ofSize: 13)
        hud.bezelView.color = UIColor.black.withAlphaComponent(0.8)
        hud.detailsLabel.textColor = UIColor.white
        return hud
    }

}
