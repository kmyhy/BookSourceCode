//
//  SpiceVC.swift
//  Splicer
//
//  Created by yanghongyan on 15/1/16.
//  Copyright (c) 2015年 yanghongyan. All rights reserved.
//

import UIKit
import Photos

class SpliceVC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var favoriteButon: UIBarButtonItem!
    var asset: PHAsset!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool)  {
        super.viewWillAppear(animated)
        
        displayImage()
    }
    @IBAction func favoriteAction(sender: AnyObject) {
    }
    @IBAction func deleteAction(sender: AnyObject) {
    }
    @IBAction func editAction(sender: AnyObject) {
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func displayImage() {
        // 1
        let scale = UIScreen.mainScreen().scale
        let targetSize = CGSize(
            width: CGRectGetWidth(imageView.bounds) * scale,
            height: CGRectGetHeight(imageView.bounds) * scale)
        // 2
        let options = PHImageRequestOptions()
        options.deliveryMode = .HighQualityFormat
        options.networkAccessAllowed = true;
        // 3
        PHImageManager.defaultManager().requestImageForAsset(asset,
            targetSize: targetSize,
            contentMode: .AspectFill,
            options: options)
            { result, info in
                if (result != nil) {
                    self.imageView.image = result
                }
        }
    }

}
