//
//  NavigationController.swift
//  SplitDemo
//
//  Created by chen neng on 14-10-7.
//  Copyright (c) 2014年 kmyhy. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController, PaletteDisplayContainer,PaletteSelectionContainer {
    func displayingPalette() -> ColorPalette? {
    if let tvc = topViewController as? PaletteDisplayContainer {
        return tvc.displayingPalette()
    }
    return nil
    }
    
    func selectedPalette() -> ColorPalette? {
        if let tvc = topViewController as? PaletteSelectionContainer {
            return tvc.selectedPalette()
        }
        return nil
    }
}