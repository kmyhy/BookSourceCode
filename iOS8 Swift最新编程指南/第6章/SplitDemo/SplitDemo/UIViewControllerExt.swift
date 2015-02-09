//
//  UIViewControllerExt.swift
//  SplitDemo
//
//  Created by yanghongyan on 14-10-14.
//  Copyright (c) 2014年 kmyhy. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showVCWillPush(sender: AnyObject?) -> Bool {
        if let target = targetViewControllerForAction("showVCWillPush:",
        sender: sender) {
            return target.showVCWillPush(sender)
        } else {
            return false
        }
    }
    
    func showDetailVCWillPush(sender: AnyObject?) -> Bool {
    if let target = targetViewControllerForAction("showDetailVCWillPush:", sender: sender) {
            return target.showDetailVCWillPush(sender)
        } else {
            return false
        }
    }
}

extension UINavigationController {

                override func showVCWillPush(sender: AnyObject?)
                -> Bool {
                return true
                }
}

extension UISplitViewController {
        override func showDetailVCWillPush(sender:AnyObject?) -> Bool {
        if collapsed {
            if let primaryVC = viewControllers.last as? UIViewController {
                return primaryVC.showVCWillPush(sender)
            }
            return false
        } else {
            return false
        }
    }
}


