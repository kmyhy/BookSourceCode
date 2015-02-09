//
//  LoginVC.swift
//  PhotoShare
//
//  Created by yanghongyan on 15/1/7.
//  Copyright (c) 2015年 yanghongyan. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var label: UILabel!
    var nameText:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUserStatus()
    }
    @IBAction func login(sender: AnyObject) {
        self.performSegueWithIdentifier("idUploadVC", sender: nil)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? UploadVC {
            vc.userName = nameText
        }
    }
    func updateUserStatus() {
        showHud()
        userInfo.userLoginStatus() { //1
            accountStatus, error in
            var text  = "请先登录iCloud" //2
            if accountStatus == .Available { //3
                text = "您已登录iCloud，正在查询您的账号信息"
                userInfo.userInfo() { //4
                    userInfo, error in
                    if userInfo != nil {
                        dispatch_async(dispatch_get_main_queue()) {
                            self.nameText = "\(userInfo.firstName) \(userInfo.lastName)" //5
                            self.label.text = "当前iCloud账号为：\(self.nameText!)"
                            self.closeHud()
                            self.button.hidden = false
                        }
                    }else{
                        //6
                        text = "未找到有效的iCloud账号，请在询问您是否允许App使用您的账号信息时选择“确定”，并确认网络有效"
                        dispatch_async(dispatch_get_main_queue()) {
                            self.label.text = text
                        }
                    }
                }
            }
            //7
            dispatch_async(dispatch_get_main_queue()) {
                self.label.text = text
            }
        }
    }


}
