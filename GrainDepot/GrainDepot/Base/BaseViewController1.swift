//
//  BaseViewController.swift
//  PartOfXib
//
//  Created by Apple on 2017/6/26.
//  Copyright © 2017年 WangDaoLeTu. All rights reserved.
//

import UIKit
import MBProgressHUD

class BaseViewController1: UIViewController {
    
    private var noDataView: UIView?
    private var progressView: MBProgressHUD?
    var isHowLeftBack = true {
        didSet {
            hidenBackBtn()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
            configStatusBar()
            showLeftBackBtn()
    }
    
    func configStatusBar() {
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showLeftBackBtn()
    }
    func hiddenNoDataView() {
        noDataView?.removeFromSuperview()
        noDataView = nil
    }
    func showLeftBackBtn(image: String = "icon_back") {
        navigationItem.hidesBackButton = true
        let view = navigationController?.navigationBar.viewWithTag(99999)
        if view != nil { view?.removeFromSuperview() }
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.setImage(UIImage(named: image), for: .normal)
        btn.addTarget(self, action: #selector(back), for: .touchUpInside)
        btn.tag = 99999
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, 7, 0, 50)
        navigationController?.navigationBar.addSubview(btn)
    }
    func hidenBackBtn() {
        let hasSubviews = navigationController?.viewControllers.count != 0
        if !isHowLeftBack || !hasSubviews {
            navigationItem.leftBarButtonItem = nil
            navigationItem.hidesBackButton = true
        }
    }
    @objc func back() {
        navigationController?.popViewController(animated: true)
    }
    func hiddenLoadingView() {
        progressView?.hide(animated: true, afterDelay: 0.2)
    }
}
