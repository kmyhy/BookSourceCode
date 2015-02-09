//
//  SpliceListVC.swift
//  Splicer
//
//  Created by yanghongyan on 15/1/16.
//  Copyright (c) 2015年 yanghongyan. All rights reserved.
//

import UIKit
import Photos

let reuseIdentifier = "Cell"

class SpliceListVC: UICollectionViewController ,PhotoPickerDelegate{

    private var thumbnailSize = CGSizeZero
    private var splices: PHFetchResult!
    private var spliceCollection: PHAssetCollection!

    @IBOutlet weak var addButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        PHPhotoLibrary.requestAuthorization { status in
            dispatch_async(dispatch_get_main_queue()) {
                switch status {
                case .Authorized:
                    // 1
                    let options = PHFetchOptions()
                    options.predicate = NSPredicate(format: "title = %@", "拼接图册")
                    let collections = PHAssetCollection.fetchAssetCollectionsWithType(.Album,
                        subtype: .AlbumRegular, options: options)
                    // 2
                    if collections.count > 0 {
                        self.spliceCollection = collections[0] as PHAssetCollection
                        // 3
                        self.splices =
                            PHAsset.fetchAssetsInAssetCollection(self.spliceCollection,
                                options: nil)
                        self.collectionView!.reloadData()
                    } else {
                        // 1
                        var assetPlaceholder: PHObjectPlaceholder?
                        // 2
                        PHPhotoLibrary.sharedPhotoLibrary().performChanges({
                            // 3
                            let changeRequest =
                            PHAssetCollectionChangeRequest.creationRequestForAssetCollectionWithTitle("拼接图册")
                            assetPlaceholder =
                                changeRequest.placeholderForCreatedAssetCollection
                            }, completionHandler: { success, error in
                                // 4
                                if !success {
                                    println("Failed to create album")
                                    println(error)
                                    return
                                }
                                // 5
                                let collections = PHAssetCollection.fetchAssetCollectionsWithLocalIdentifiers(
                                    [assetPlaceholder!.localIdentifier], options: nil)
                                if collections.count > 0 {
                                    self.spliceCollection =
                                        collections[0] as PHAssetCollection
                                    self.splices = PHAsset.fetchAssetsInAssetCollection(
                                        self.spliceCollection, options: nil)
                                    self.collectionView!.reloadData()

                                }
                        })
                    }
                default:
                    self.addButton.enabled = false
                    
                    self.showNoAccessAlert()
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func showNoAccessAlert() {
        let alert = UIAlertController(title: "权限未授予", message: "请在设置/隐私中授予App访问照片权限", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "设置", style: .Default, handler: { action in
            UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
            return
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }

    // MARK: UICollectionViewDataSource

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var thumbsPerRow: Int
        switch collectionView.bounds.size.width {
        case 0..<400:
            thumbsPerRow = 2
        case 400..<800:
            thumbsPerRow = 4
        case 800..<1200:
            thumbsPerRow = 5
        default:
            thumbsPerRow = 3
        }
        let width = collectionView.bounds.size.width / CGFloat(thumbsPerRow)
        return CGSize(width: width,height: width)
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return splices?.count ?? 0
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("idCell", forIndexPath: indexPath) as AssetListCell
        
        // Configure the Cell
        let reuseCount = ++cell.reuseCount
        
        let options = PHImageRequestOptions()
        options.networkAccessAllowed = true
        
        let asset = splices[indexPath.item] as PHAsset
        PHImageManager.defaultManager().requestImageForAsset(asset,
            targetSize: thumbnailSize,
            contentMode: .AspectFill,
            options: options) { result, info in
                if reuseCount == cell.reuseCount {
                    cell.imageView.image = result
                }
        }
        return cell
    }
    // MARK: PhotoPickerDelegate
    func didSelect(selectedAssets: [PHAsset]) {
        dismissViewControllerAnimated(true, completion: nil)

        if (selectedAssets.count > 0) {
            // Create new Stitch
            createNewSplice(selectedAssets,
                inCollection: spliceCollection)
        }
    }
    func didCancel() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    // mark:Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "idPhotoPicker"{
            let nav = segue.destinationViewController as UINavigationController
            let dest = nav.viewControllers[0] as CollectionListVC
            dest.delegate = self
        }else{
            let dest = segue.destinationViewController as SpliceVC
            let indexPath = collectionView!.indexPathForCell(sender as UICollectionViewCell)!
            dest.asset = splices[indexPath.item] as PHAsset
        }
    }
}