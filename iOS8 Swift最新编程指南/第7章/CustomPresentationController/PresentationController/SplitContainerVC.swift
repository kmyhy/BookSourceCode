//
//  SplitContainerVC.swift
//  PresentationController
//
//  Created by yanghongyan on 14/10/22.
//  Copyright (c) 2014年 yanghongyan. All rights reserved.
//

import UIKit

class SplitContainerVC: UIViewController {

    var viewController : UISplitViewController!
    
    func setEmbeddedViewController(splitViewController: UISplitViewController!){
        if splitViewController != nil{
        viewController = splitViewController
        
        self.addChildViewController(viewController)
        self.view.addSubview(viewController.view)
        viewController.didMoveToParentViewController(self)
        }
    }
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
    if size.width > size.height{
            self.setOverrideTraitCollection(UITraitCollection(horizontalSizeClass: UIUserInterfaceSizeClass.Regular), forChildViewController: viewController)
    }else{
            self.setOverrideTraitCollection(nil, forChildViewController: viewController)
            }
    super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    }
override func supportedInterfaceOrientations() -> Int {
    return Int(UIInterfaceOrientationMask.All.rawValue)
}
}
