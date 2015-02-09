//
//  UIView+Extension.swift
//  PresentationController
//
//  Created by yanghongyan on 14/10/31.
//  Copyright (c) 2014年 yanghongyan. All rights reserved.
//

import UIKit

extension UIView {
    
    func pb_takeSnapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.mainScreen().scale);
        
        self.drawViewHierarchyInRect(self.bounds, afterScreenUpdates: true)
        
        // old style: self.layer.renderInContext(UIGraphicsGetCurrentContext())
        
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image;
    }
}