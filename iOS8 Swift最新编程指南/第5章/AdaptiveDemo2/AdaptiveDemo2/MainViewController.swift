//
//  MainViewController.swift
//  AdaptiveDemo2
//
//  Created by chen neng on 14-10-3.
//  Copyright (c) 2014年 kmyhy. All rights reserved.
//

import UIKit

protocol PostCollectionContainer {
    var post: Post? { get set }
}
class MainViewController: UIViewController,PostCollectionContainer {
        var post:Post?{
    didSet{
    for vc in childViewControllers {
            if let postVC = vc as? PostViewController
        {
            postVC.post=post
            
            }
    }
    }
        }
    override func viewDidLoad() {
        super.viewDidLoad()
                title="Main View Controller"
    }
  
        func configureContainter(container:PostCollectionContainer?){
            for vc in childViewControllers{
        if let postCollectionVC = vc as? ViewController{
            postCollectionVC.container=container
        }
            }
        }
        
        override func traitCollectionDidChange(previousTraitCollection: UITraitCollection) {
            if traitCollection.verticalSizeClass == UIUserInterfaceSizeClass.Compact {
                configureContainter(self)
            }else{
                configureContainter(nil)
            }
        }
        
}
