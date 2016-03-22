//
//  SpitVC.swift
//  SplitDemo
//
//  Created by chen neng on 14-10-7.
//  Copyright (c) 2014年 kmyhy. All rights reserved.
//

import UIKit

class SplitVC: UISplitViewController, UISplitViewControllerDelegate {
    override func viewDidLoad() {
    super.viewDidLoad()
    delegate = self
    }
   
    func splitViewController(splitController: UISplitViewController, collapseSecondaryViewController secondaryViewController:
        UIViewController,
        ontoPrimaryViewController primaryViewController:
        UIViewController) -> Bool {
        if let selectionCont = primaryViewController as?
        PaletteSelectionContainer {
        if let displayCont = secondaryViewController as?
        PaletteDisplayContainer {
        let selectedPalette = selectionCont.selectedPalette()
        let displayedPalette = displayCont.displayingPalette()
        if selectedPalette != nil && selectedPalette == displayedPalette {
            return false
        }
        } }
        // We don't want anything to happen. Say we've dealt with it
        return true
    }
    
    func splitViewController(splitViewController: UISplitViewController,
    separateSecondaryViewControllerFromPrimaryViewController primaryViewController: UIViewController) -> UIViewController? {
        if let paletteDisplayCont = primaryViewController as? PaletteDisplayContainer {
        if paletteDisplayCont.displayingPalette() != nil{
        return nil
        }
        }
        let vc = (storyboard? .instantiateViewControllerWithIdentifier(
        "NoPaletteSelected"))! as UIViewController
        return NavigationController(rootViewController: vc)
    }
}
