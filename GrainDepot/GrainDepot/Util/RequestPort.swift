//
//  RequestPort.swift
//  XibProgect
//
//  Created by Apple on 2017/6/26.
//  Copyright © 2017年 WangDaoLeTu. All rights reserved.
//

import Foundation
// MARK: -------------测试环境---------------------
/// 192.168.6.253:8888 http://218.13.18.18:8000
 let baseDomain =  "http://218.13.18.18:8000"

let controlWareHouirse = "http://218.13.18.18:20013"

class RequestPort:NSObject {
    /// 首页
    class func home() -> String {
        return baseDomain + "/grm/page/index.html"
    }
    /// 登录
    class func login() -> String {
        return baseDomain + "/grm/j_spring_security_check"
    }
    /// 获取仓库列表
    class func getWarehouseList() -> String {
        return baseDomain + "/grm/api/stores"
    }
    /// 上
    class func up() -> String {
        return baseDomain + "/MyWebService.asmx?op=setUp"
    }
    /// 下
    class func down() -> String {
        return baseDomain + "/MyWebService.asmx?op=setDown"
    }
    /// 左
    class func left() -> String {
        return baseDomain + "/MyWebService.asmx?op=setLeft"
    }
    /// 右
    class func right() -> String {
        return baseDomain + "/MyWebService.asmx?op=setRight"
    }
    /// 开灯
    class func openLight() -> String {
        return baseDomain + "/MyWebService.asmx?op=startCamera"
    }
    /// 关灯
    class func closeLight() -> String {
        return baseDomain + "/MyWebService.asmx?op=stopCamera"
    }
}

