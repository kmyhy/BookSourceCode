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
    
    var snapshot: UIImageView = UIImageView(
        frame: CGRect(origin: CGPointZero,
        size: CGSize(width: 160.0, height: 93.0)))
    var selectedItem: SelectedItem?
    var isAnimating = false
    var imageView:UIImageView!
    
    override init?(presentedViewController: UIViewController!, presentingViewController: UIViewController!) {
        super.init(presentedViewController:presentedViewController,presentingViewController:presentingViewController)
        // 3
        dimmingView.backgroundColor = UIColor.clearColor()
        
        imageView = UIImageView(image: UIImage(named: "3_iphone"))
        dimmingView.addSubview(imageView)
        
        snapshot.contentMode = UIViewContentMode.ScaleAspectFill
    }
    func configureWithSelectionObject(item: SelectedItem) {
            self.selectedItem = item
            snapshot.image = item.snapshot
            snapshot.frame = item.originRect
    }
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        // 1
        isAnimating = true
        moveSnapshot(false)
        // 2
        dimmingView.addSubview(snapshot)
        containerView.addSubview(dimmingView)
        animateSnapshot(true)
    }
    override func dismissalTransitionWillBegin() {super.dismissalTransitionWillBegin()
            isAnimating = true
            animateSnapshot(false)
    
    }
    override func frameOfPresentedViewInContainerView() -> CGRect {
                    return containerView.bounds
    }
    
    override func containerViewWillLayoutSubviews() {
                dimmingView.frame = containerView.bounds;
        imageView.frame=containerView.bounds
                presentedView().frame = containerView.bounds;
    }
    override func shouldPresentInFullscreen() -> Bool {
                    return true
    }
    // MARK: -  UIAdaptivePresentationControllerDelegate
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle{
                return UIModalPresentationStyle.OverFullScreen
    }
     func scaleSnapshot() {
        var frame = snapshot.frame
        var containerFrame = containerView.frame
        var size = selectedItem!.originRect.size
        var yScale: CGFloat = 0.0
        
        frame.size.width = size.width * 1.8
        frame.size.height = size.height * 1.8
        yScale = 0.333
        frame.origin.x = (containerFrame.size.width / 2) - (frame.size.width / 2)
        frame.origin.y = (containerFrame.size.height * yScale) - (frame.size.height / 2)
        snapshot.frame = frame
    }
    func moveSnapshot(presentedPosition: Bool) {
        let containerFrame = containerView.frame
        if presentedPosition {
            // 1
            scaleSnapshot()
        } else {
            // 2
            var frame = selectedItem!.originRect;
            snapshot.frame = frame
        }
    }
    func animateSnapshot(presentedPosition: Bool) {
                let coordinator =
                presentedViewController.transitionCoordinator()
                coordinator!.animateAlongsideTransition({
                (context: UIViewControllerTransitionCoordinatorContext!)
                -> Void in
                self.moveSnapshot(presentedPosition)
                }, completion: {
                (context: UIViewControllerTransitionCoordinatorContext!) -> Void in
                self.isAnimating = false
                })
    }
}



