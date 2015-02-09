//
//  UIViewControllerExt.swift
//  InnerMail
//
//  Created by yanghongyan on 14-10-15.
//  Copyright (c) 2014年 kmyhy. All rights reserved.
//

import Foundation

extension UIViewController {
        private func addHudToSubview(){
        self.closeHud()
        hud = MBProgressHUD(view: self.view)
        self.view.addSubview(hud!)
    }
    
    func closeHud(){
        if hud != nil{
            hud?.hide(true)
            hud?.removeFromSuperview()
            hud=nil
        }else{
            DLog("---------SELF VIEW IS NIL-------")
        }
    }
    
    func showHud(title:String?){
        self.addHudToSubview()
        hud?.labelText = title
        hud?.show(true)
    }

    func showHud(title:String?,delay:Double){
        self.showHud(title)
        hud?.hide(true, afterDelay: delay)
    }
    
    func showHud(){
        self.addHudToSubview()
        hud?.show(true)
    }
    
    func showHud(title:String?,delay:UInt32,completionHandler:()->Void){
        self.showHud(title)
        hud?.showAnimated(false, whileExecutingBlock: { () -> Void in
            sleep(delay)
            return
        }, completionBlock: { () -> Void in
            completionHandler()
        })
    }
    

}