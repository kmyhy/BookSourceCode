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
}

