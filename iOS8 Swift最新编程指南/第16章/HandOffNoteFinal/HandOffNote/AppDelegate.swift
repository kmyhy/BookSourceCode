//
//  AppDelegate.swift
//  HandOffNote
//
//  Created by yanghongyan on 15/1/23.
//  Copyright (c) 2015年 yanghongyan. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    func application(application: UIApplication, willContinueUserActivityWithType userActivityType: String!) ->
        Bool {
        return true
    }
    func application(application:UIApplication!,didFailToContinueUserActivityWithType userActivityType: String!,
        error: NSError!) {
            if error.code != NSUserCancelledError {
                let message = "与另一个设备的连接已断开，请重试。\(error.localizedDescription)"
                let alertView = UIAlertView(title: "Handoff 错误", message:
                    message, delegate: nil, cancelButtonTitle: "关闭")
                alertView.show()
            }
    }
    func application(application: UIApplication!, continueUserActivity userActivity: NSUserActivity!, restorationHandler: (([AnyObject]!) -> Void)!) -> Bool {
        let activityType = userActivity.activityType
        println("activity type :\(activityType),userInfo:\(userActivity.userInfo)")
        let navController = window?.rootViewController as UINavigationController
        let viewVC = viewController(navController)
        let editVC = editController(navController)
        if activityType == ActivityTypeView {
            if viewVC != navController.topViewController {
                navController.popToRootViewControllerAnimated(true)
            }
            viewVC?.restoreUserActivityState(userActivity)
        } else {
            var note : Note?
            if let item = userActivity.userInfo?["item"] as? Note {
                note = item
            }
            if viewVC == navController.topViewController {
                viewVC?.performSegueWithIdentifier("idEditNote", sender: note)
            }
            
            editVC?.restoreUserActivityState(userActivity)
        }
        return true
    }
    func viewController(navController:UINavigationController)->UIViewController?{
        
        var viewController:UIViewController?
        for controller in navController.viewControllers {
            if controller is NoteListVC {
                viewController = controller as? UIViewController
                break
            }
        }
        return viewController
    }
    func editController(navController:UINavigationController)->UIViewController?{
        let navController = window?.rootViewController as UINavigationController
        var editController:UIViewController?
        for controller in navController.viewControllers {
            if controller is NoteEditingVC {
                editController = controller as? UIViewController
                break
            }
        }
        return editController
    }
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

