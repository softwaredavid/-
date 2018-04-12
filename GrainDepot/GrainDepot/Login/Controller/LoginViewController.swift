//
//  LoginViewController.swift
//  GrainDepot
//
//  Created by shuaitong du on 2017/11/2.
//  Copyright © 2017年 EdisonDu. All rights reserved.
// userName.text = "toyla"
//passWord.text = "x1Y2I3ng"

import UIKit

class LoginViewController: BaseViewController1 {
    @IBOutlet weak var passWord: UITextField! {
        didSet {
            passWord.border(width: 1, color: #colorLiteral(red: 0.9450980392, green: 0.9450980392, blue: 0.9450980392, alpha: 1))
            passWord.layer.masksToBounds = true
            passWord.layer.cornerRadius = 5
            passWord.leftViewMode = .always
        }
    }
    @IBOutlet weak var userName: UITextField! {
        didSet {
            userName.border(width: 1, color: #colorLiteral(red: 0.9450980392, green: 0.9450980392, blue: 0.9450980392, alpha: 1))
            userName.layer.masksToBounds = true
            userName.layer.cornerRadius = 5
            userName.leftViewMode = .always
        }
    }
    @IBOutlet weak var loginBtn: UIButton! {
        didSet {
            loginBtn.layer.masksToBounds = true
            loginBtn.layer.cornerRadius = 5
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        userName.leftView = createLeftView(imgName: "user")
        passWord.leftView = createLeftView(imgName: "pass")
    }
    @IBAction func login(_ sender: Any) {
        if userName.text == nil || userName.text!.isEmpty {
            Alert.show(text: "用户名不能为空")
            return;
        }
        if passWord.text == nil || passWord.text!.isEmpty {
            Alert.show(text: "密码不能为空")
            return;
        }
        let hub = Alert.showProgressView(text: "请稍后")
        NetObject().postUserName(userName.text!, password: passWord.text!, success: {
            hub?.hide(animated: true)
            let app = UIApplication.shared.delegate as? AppDelegate
              app?.switchRootVc()
        }) {
            hub?.hide(animated: true)
            Alert.show(text: "用户名或密码错误")
        }
        
    }
    func createLeftView(imgName:String) -> UIView {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 44))
        let img = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        img.center = v.center
        img.image = UIImage(named: imgName)
        v.addSubview(img)
        return v
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        view.y = -64
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        view.y = 0
        return true
    }
}
