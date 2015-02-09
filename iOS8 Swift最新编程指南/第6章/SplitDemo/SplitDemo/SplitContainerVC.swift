//
//  SplitContainerVC.swift
//  SplitDemo
//
//  Created by chen neng on 14-10-6.
//  Copyright (c) 2014年 kmyhy. All rights reserved.
//

import UIKit

class SplitContainerVC: UIViewController {

    override func viewWillTransitionToSize(size: CGSize,
        withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        var traitOverride: UITraitCollection? = nil
        if size.width > 320 {
            traitOverride = UITraitCollection(horizontalSizeClass: .Regular)
        }else{
            traitOverride = UITraitCollection(horizontalSizeClass: .Compact)
        }
        setOverrideTraitCollection(traitOverride,
            forChildViewController: childViewControllers[0] as UIViewController)
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    }
}
