//
//  SelectedItem.swift
//  PresentationController
//
//  Created by yanghongyan on 14/10/31.
//  Copyright (c) 2014年 yanghongyan. All rights reserved.
//

import UIKit

class SelectedItem: NSObject {
    var originRect: CGRect
    var snapshot: UIImage
    
    init(snapshot:UIImage, originRect: CGRect) {
        self.snapshot = snapshot
        self.originRect = originRect
    }
    
}
