//
//  PopupVC.swift
//  VisualEffects
//
//  Created by yanghongyan on 15/1/29.
//  Copyright (c) 2015年 yanghongyan. All rights reserved.
//

import UIKit

class PopupVC: UIViewController {
//    var blurView : UIVisualEffectView!
    @IBOutlet weak var contentView: UIView!

    @IBOutlet weak var leftButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        addAffects()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addAffects(){
        // 1
        let blurEffect = UIBlurEffect(style: .Light)
        // 2
        let blurView = UIVisualEffectView(effect: blurEffect)
        // 3
        blurView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        view.insertSubview(blurView, atIndex: 0)
        
        // 1
        let vibrancyEffect = UIVibrancyEffect(forBlurEffect: blurEffect)
        // 2
        let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyView.setTranslatesAutoresizingMaskIntoConstraints(false)
        // 3
        vibrancyView.contentView.addSubview(contentView)
        // 4
        blurView.contentView.addSubview(vibrancyView)
        
//        layoutBlurView()
        contentView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        var constraints = [NSLayoutConstraint]()
        constraints.append(NSLayoutConstraint(item: view, attribute: .Height, relatedBy: .Equal,
            toItem: contentView, attribute: .Height, multiplier: 1, constant: 0))
        
        constraints.append(NSLayoutConstraint(item: view, attribute: .Width, relatedBy: .Equal,
            toItem: contentView, attribute: .Width, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: contentView, attribute: .Top, relatedBy: .Equal,
            toItem: view, attribute: .Top, multiplier: 1, constant: 0))
        
        constraints.append(NSLayoutConstraint(item: blurView,
            attribute: .Height, relatedBy: .Equal, toItem: view,
            attribute: .Height, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: blurView,
            attribute: .Width, relatedBy: .Equal, toItem: view,
            attribute: .Width, multiplier: 1, constant: 0))
        
        
        constraints.append(NSLayoutConstraint(item: vibrancyView,
            attribute: .Height, relatedBy: .Equal,
            toItem: view, attribute: .Height,
            multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: vibrancyView,
            attribute: .Width, relatedBy: .Equal,
            toItem: view, attribute: .Width,
            multiplier: 1, constant: 0))
        
        view.addConstraints(constraints)

    }
}
