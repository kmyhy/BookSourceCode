//
//  MyPresentationController.swift
//  PresentationController
//
//  Created by yanghongyan on 14/10/29.
//  Copyright (c) 2014年 yanghongyan. All rights reserved.
//

import UIKit

// 1
class MyPresentationController: UIPresentationController,UIAdaptivePresentationControllerDelegate{
    // 2
    var dimmingView: UIView = UIView()
    override init?(presentedViewController: UIViewController!, presentingViewController: UIViewController!) {
        super.init(presentedViewController:presentedViewController,presentingViewController:presentingViewController)
        // 3
        dimmingView.backgroundColor = UIColor(white:0.0, alpha:0.4)
        dimmingView.alpha = 0.0
    }
    override func presentationTransitionWillBegin() {
        // 1
        dimmingView.frame = self.containerView.bounds
        dimmingView.alpha = 0.0
        containerView.insertSubview(dimmingView, atIndex:0)
        // 2
        let coordinator = presentedViewController.transitionCoordinator()
        if (coordinator != nil) {
            // 3
            coordinator!.animateAlongsideTransition({ (context:UIViewControllerTransitionCoordinatorContext!) ->
            Void in
            self.dimmingView.alpha = 1.0 }, completion:nil)
        } else { dimmingView.alpha = 1.0
        }
    }
    override func dismissalTransitionWillBegin() {
            let coordinator =
            presentedViewController.transitionCoordinator()
            if (coordinator != nil) {
                coordinator!.animateAlongsideTransition({ (context:UIViewControllerTransitionCoordinatorContext!) ->
                Void in
                self.dimmingView.alpha = 0.0
                }, completion:nil)
            } else {
                dimmingView.alpha = 0.0
            }
    }
    override func containerViewWillLayoutSubviews() {
                dimmingView.frame = containerView.bounds;
                presentedView().frame = containerView.bounds;
    }
    override func shouldPresentInFullscreen() -> Bool {
                    return true
    }
    // MARK: -  UIAdaptivePresentationControllerDelegate
    func adaptivePresentationStyleForPresentationController( controller: UIPresentationController!) ->
                UIModalPresentationStyle {
                return UIModalPresentationStyle.OverFullScreen
    }
}
