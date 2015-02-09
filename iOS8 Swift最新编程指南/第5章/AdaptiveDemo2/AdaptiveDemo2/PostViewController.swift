//
//  PostViewController.swift
//  AdaptiveDemo2
//
//  Created by chen neng on 14-10-2.
//  Copyright (c) 2014年 kmyhy. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {

    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet  var contentLabel: UILabel!
    @IBOutlet var postTimeLabel: UILabel!
    @IBOutlet var posterLabel: UILabel!
    @IBOutlet var titleLable: UILabel!
    
    var tempPost:Post?
    
    var post: Post? {
        didSet {
            configureView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        post=tempPost
    }

    private func configureView() {
        avatarImageView.image = post?.avatarImage
        contentLabel.text = post?.content
        postTimeLabel.text=post?.postTime
        posterLabel.text=post?.poster
        titleLable.text=post?.title
    }
}
