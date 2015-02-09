//
//  PaletteContainer.swift
//  SplitDemo
//
//  Created by chen neng on 14-10-7.
//  Copyright (c) 2014年 kmyhy. All rights reserved.
//

import Foundation

@objc protocol PaletteDisplayContainer {
    func displayingPalette() -> ColorPalette?
}
@objc protocol PaletteSelectionContainer {
    func selectedPalette() -> ColorPalette?
}