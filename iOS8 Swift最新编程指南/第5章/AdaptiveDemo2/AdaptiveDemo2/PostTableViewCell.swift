//
//  PostTableViewCell.swift
//  AdaptiveDemo2
//
//  Created by chen neng on 14-10-2.
//  Copyright (c) 2014年 kmyhy. All rights reserved.
//

import UIKit

class Post{
    var avatarImage:UIImage!=nil
    var content:String!=nil
    var title:String!=nil
    var poster:String!=nil
    var postTime:String!=nil
}

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    
    
    var post: Post? {
        didSet {
        configureCell()
        }
    }
    // MARK: - Utility methods
    private func configureCell() {
        avatarImageView.image = post?.avatarImage;
        contentLabel.text = post?.title;
    }
}

