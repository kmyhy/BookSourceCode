//
//  PhotoListCell.swift
//  PhotoShare
//
//  Created by yanghongyan on 15/1/8.
//  Copyright (c) 2015年 yanghongyan. All rights reserved.
//

import UIKit

class PhotoListCell: UITableViewCell {

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var posterLabel: UILabel!
    @IBOutlet weak var createAtLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureCell(photo:CKPhoto){
        if let url = photo.asset {
            thumbnailImageView.image = UIImage(data: NSData(contentsOfURL: photo.asset!)!)
        }
        posterLabel.text = photo.poster
        descriptionLabel.text = photo.description
        createAtLabel.text = photo.createdAt.descriptionWithLocale(NSLocale.currentLocale())
    }
}
