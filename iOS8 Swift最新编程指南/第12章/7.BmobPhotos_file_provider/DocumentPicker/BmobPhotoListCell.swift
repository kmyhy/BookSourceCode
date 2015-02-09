//
//  BmobPhotoListCell.swift
//  BmobPhotos
//
//  Created by yanghongyan on 14/12/21.
//  Copyright (c) 2014年 yanghongyan. All rights reserved.
//

import UIKit

class BmobPhotoListCell: UITableViewCell {

    @IBOutlet weak var thumbnailImageView:UIImageView!
    @IBOutlet weak var label:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
