//
//  SpiceVC.swift
//  Splicer
//
//  Created by yanghongyan on 15/1/16.
//  Copyright (c) 2015年 yanghongyan. All rights reserved.
//

import UIKit
import Photos

class SpliceVC: UIViewController,PhotoPickerDelegate,PHPhotoLibraryChangeObserver {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var favoriteButon: UIBarButtonItem!
    var asset: PHAsset!
    private var spliceAssets:[PHAsset]?
    override func viewDidLoad() {
        super.viewDidLoad()

        PHPhotoLibrary.sharedPhotoLibrary().registerChangeObserver(
            self)
    }
    deinit {
        PHPhotoLibrary.sharedPhotoLibrary().unregisterChangeObserver(
            self)
    }
    override func viewWillAppear(animated: Bool)  {
        super.viewWillAppear(animated)
        
        displayImage()
        
        editButton.enabled = asset.canPerformEditOperation(.Content)
        favoriteButon.enabled =
            asset.canPerformEditOperation(.Properties)
        deleteButton.enabled = asset.canPerformEditOperation(.Delete)
        updateFavoriteButton()

    }
    private func updateFavoriteButton() {
        if asset.favorite {
            favoriteButon.title = "取消收藏"
        } else {
            favoriteButon.title = "收藏"
        }
    }
    @IBAction func favoriteAction(sender: AnyObject) {
        PHPhotoLibrary.sharedPhotoLibrary().performChanges ({
            let request = PHAssetChangeRequest(forAsset: self.asset)
            request.favorite = !self.asset.favorite
            }, completionHandler: nil)
    }
    @IBAction func deleteAction(sender: AnyObject) {
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({
            PHAssetChangeRequest.deleteAssets([self.asset])
            }, completionHandler: nil)
    }
    @IBAction func editAction(sender: AnyObject) {
        loadAssetsInSplice(asset) { assets in
            self.spliceAssets = assets
            dispatch_async(dispatch_get_main_queue()) {
                self.performSegueWithIdentifier("createSplices",
                    sender: self)
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func displayImage() {
        // Load a high quality image to display
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
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "createSplices" {
            let nav = segue.destinationViewController as UINavigationController
            let dest = nav.viewControllers[0] as CollectionListVC
            dest.delegate = self
            
            // Set up AssetCollectionsViewController
            if let assets = spliceAssets {
                dest.selectedAssets = SelectedAssets(assets: assets)
            } else {
                dest.selectedAssets = nil
            }
        }
    }
    // MARK: PhotoPickerDelegate
    
    func didCancel() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func didSelect(selectedAssets: [PHAsset]) {
        dismissViewControllerAnimated(true, completion: nil)
        let image =
        createSpliceImageFromAssets(selectedAssets)
        editSpliceContent(self.asset,image, selectedAssets)
    }
    // MARK: PHPhotoLibraryChangeObserver
    func photoLibraryDidChange(changeInstance: PHChange!)  {
        // 1
        dispatch_async(dispatch_get_main_queue()) {
            // 2
            if let changeDetails = changeInstance.changeDetailsForObject(self.asset) {
                // 3
                if changeDetails.objectWasDeleted {
                    self.navigationController?.popViewControllerAnimated(true)
                    return
                }
                // 4
                self.asset = changeDetails.objectAfterChanges as PHAsset
                if changeDetails.assetContentChanged {
                    self.displayImage()
                }
                self.updateFavoriteButton()
            }
        }
    }
}
