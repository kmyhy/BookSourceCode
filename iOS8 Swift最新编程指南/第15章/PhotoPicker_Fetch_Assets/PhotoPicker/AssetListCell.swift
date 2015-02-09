//
//  AssetListCell.swift
//  PhotoPickerStarter
//
//  Created by yanghongyan on 15/1/15.
//  Copyright (c) 2015年 yanghongyan. All rights reserved.
//

import UIKit

class AssetListCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    var reuseCount: Int = 0
    
    @IBOutlet private var checkView: UIView?
    
    override var selected: Bool {
        didSet {
            checkView?.hidden = !selected
        }
    }

}
