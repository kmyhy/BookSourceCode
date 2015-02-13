//
//  ViewController.swift
//  VisualEffects
//
//  Created by yanghongyan on 15/1/29.
//  Copyright (c) 2015年 yanghongyan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var popwinShowing = false
        
    @IBOutlet weak var containerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    func setPopwinHidden(hidden:Bool,animated:Bool){
        
        popwinShowing = !hidden;
        let height = CGRectGetHeight(containerView.bounds)
        var constant = containerBottomConstraint.constant
        constant = hidden ? (constant - height) : (constant + height)
        view.layoutIfNeeded()
        
        if animated {
            UIView.animateWithDuration(0.2,
                delay: 0,
                usingSpringWithDamping: 0.95,
                initialSpringVelocity: 1,
                options: .AllowUserInteraction | .BeginFromCurrentState,
                animations: {
                    self.containerBottomConstraint.constant = constant
                    self.view.layoutIfNeeded()
                }, completion: nil)
        } else {
            containerBottomConstraint.constant = constant
        }
    }
    @IBAction func popupWin(sender: AnyObject) {
        setPopwinHidden(popwinShowing, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



    func addVibrancyEffects(blurEffect:UIBlurEffect,blurView:UIVisualEffectView){
        // 1
        let vibrancyEffect = UIVibrancyEffect(forBlurEffect: blurEffect)
        // 2
        let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyView.setTranslatesAutoresizingMaskIntoConstraints(false)
        // 3
        vibrancyView.contentView.addSubview(containerView)
        // 4
        blurView.contentView.addSubview(vibrancyView)
        
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(NSLayoutConstraint(item: vibrancyView,
            attribute: .Height, relatedBy: .Equal,
            toItem: blurView, attribute: .Height,
            multiplier: 0.5, constant: 0))
        constraints.append(NSLayoutConstraint(item: vibrancyView,
            attribute: .Width, relatedBy: .Equal,
            toItem: blurView, attribute: .Width,
            multiplier: 1, constant: 0))
        blurView.addConstraints(constraints)
    }
}

