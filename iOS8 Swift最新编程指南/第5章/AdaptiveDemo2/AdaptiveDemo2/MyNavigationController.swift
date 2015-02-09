//
//  MyNavigationController.swift
//  AdaptiveDemo2
//
//  Created by chen neng on 14-10-3.
//  Copyright (c) 2014年 kmyhy. All rights reserved.
//

import UIKit

class MyNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        var traitOverride: UITraitCollection?
        if traitCollection.userInterfaceIdiom == UIUserInterfaceIdiom.Pad
            && size.height < 1000 {
            traitOverride = UITraitCollection(verticalSizeClass: .Compact)
            
        }
        for vc in childViewControllers as [UIViewController] {
                setOverrideTraitCollection(traitOverride,
            forChildViewController: vc)
        }
        
    }
    override func supportedInterfaceOrientations() -> Int {
            return Int(UIInterfaceOrientationMask.All.toRaw())
    }
    
    private func prepareNavigationBarAppearance() {
        let font = UIFont(name: "HelveticaNeue-Light", size: 30)
        let regularVertical = UITraitCollection(verticalSizeClass: .Regular)
        UINavigationBar.appearanceForTraitCollection(regularVertical).titleTextAttributes = [NSFontAttributeName: font]
        let compactVertical = UITraitCollection(verticalSizeClass: .Compact)
        UINavigationBar.appearanceForTraitCollection(compactVertical).titleTextAttributes = [NSFontAttributeName:font.fontWithSize(20)]
    
    }
    
    override func awakeFromNib(){
        prepareNavigationBarAppearance()
    }
}
