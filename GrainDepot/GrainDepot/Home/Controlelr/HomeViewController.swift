//
//  HomeViewController.swift
//  GrainDepot
//
//  Created by shuaitong du on 2017/11/2.
//  Copyright © 2017年 EdisonDu. All rights reserved.
//

import UIKit
import MBProgressHUD
import MJRefresh
import YYModel

class HomeViewController: BaseViewController1,UIWebViewDelegate {
    @IBOutlet weak var webView: UIWebView!
    private var mbHud: MBProgressHUD?
    
    @IBOutlet weak var tabV: UITableView!
    fileprivate var recordBtn: UIButton?
    var sourceArray: [[String: Any]]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configNavView()
        configWeb()
        mbHud = Alert.showProgressView(text: "加载中")
        getWarehouseList()
        
    }
    
    func getWarehouseList() {
        Net.get(url: RequestPort.getWarehouseList(), success: {
            let res = $0 as! [String:[String:Any]]
            guard let array111 = res["_embedded"]?["stores"] else {
                return
            }
            self.sourceArray = array111 as! NSArray as? [[String : Any]]
            self.tabV.reloadData()
        }) {
            
        }
    }
    
    func configWeb() {
        webView.delegate = self
        webView.backgroundColor = UIColor.clear
        webView.isOpaque = false
        let u = URL(string: RequestPort.home())
        if u == nil { return }
        let str = UserDefaults.standard.string(forKey: appCookie) ?? ""
        var request = URLRequest(url: u!)
        request.addValue(str, forHTTPHeaderField: "cookie")
        webView.loadRequest(request)
        configRefresh()
    }
    func configRefresh() {
        webView.scrollView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.webView.reload()
        })
    }
    func webViewDidStartLoad(_ webView: UIWebView) {
        
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        mbHud?.hide(animated: true)
        webView.scrollView.mj_header.endRefreshing()
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        mbHud?.hide(animated: true)
        webView.scrollView.mj_header.endRefreshing()
    }
}
extension HomeViewController {
    func configNavView() {
        configNavBar()
        let bu = createBtn(frame: CGRect(x: 0, y: 0, width: screen_width / 2, height: 44), title: "智能化粮库")
        navigationController?.navigationBar.addSubview(bu)
        bu.isSelected = true
        recordBtn = bu
        bu.backgroundColor = #colorLiteral(red: 0.1764705882, green: 0.5882352941, blue: 0.9843137255, alpha: 1)
        
        let bu2 = createBtn(frame: CGRect(x: screen_width / 2, y: 0, width: screen_width / 2, height: 44), title: "监控")
        navigationController?.navigationBar.addSubview(bu2)
    }
    
    func createBtn(frame: CGRect,title: String) -> UIButton {
        let btn = UIButton(type: .system)
        btn.frame = frame
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(UIColor.white, for: .selected)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.tintColor = UIColor.clear
        btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        btn.backgroundColor = #colorLiteral(red: 0, green: 0.4745098039, blue: 1, alpha: 1)
        return btn
    }
    func configNavBar() {
        navigationController?.navigationBar.viewWithTag(1000)?.removeFromSuperview()
    }
    @objc func btnClick(btn: UIButton) {
        
        if btn.currentTitle == "监控" {
            tabV.isHidden = false
            webView.isHidden = true
        } else {
            tabV.isHidden = true
            webView.isHidden = false
        }
        recordBtn?.isSelected = false
        recordBtn?.backgroundColor = #colorLiteral(red: 0, green: 0.4745098039, blue: 1, alpha: 1)
        
        btn.isSelected = true
        btn.backgroundColor = #colorLiteral(red: 0.1764705882, green: 0.5882352941, blue: 0.9843137255, alpha: 1) 
        
        recordBtn = btn
        
    }
}
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       let play = AppUtil.getViewController(storyBoard: "Home", identify: "play") as! PlayViewController
        let n = sourceArray?[indexPath.row]["codeId"]
        play.num = "\(n ?? "")"
        play.name = sourceArray?[indexPath.row]["name"] as? String
        navigationController?.pushViewController(play, animated: true)
    }
}
extension HomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sourceArray?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellid")
        cell?.selectionStyle = .none
        let v = cell?.contentView.viewWithTag(40)
        v?.layer.borderWidth = 1
        v?.layer.borderColor = #colorLiteral(red: 0.9450980392, green: 0.9450980392, blue: 0.9450980392, alpha: 1)
        let lab = cell?.contentView.viewWithTag(21) as? UILabel
        
        let text = sourceArray?[indexPath.row]["name"] as? String
        lab?.text = text
        
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
    }
}
