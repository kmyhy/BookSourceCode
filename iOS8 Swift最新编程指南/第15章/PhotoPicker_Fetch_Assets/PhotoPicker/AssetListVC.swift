//
//  AssetListVC.swift
//  PhotoPickerStarter
//
//  Created by yanghongyan on 15/1/15.
//  Copyright (c) 2015年 yanghongyan. All rights reserved.
//

import UIKit

import Photos


class AssetListVC: UICollectionViewController {
    
    var fetchResults: PHFetchResult?
    var selectedAssets:[PHAsset]=[]
    
    private var thumbnailSize = CGSizeZero
    
    private let imageManager: PHImageManager =
    PHImageManager.defaultManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView!.allowsMultipleSelection = true
    }

    override func viewWillAppear(animated: Bool)  {
        super.viewWillAppear(animated)
        
        // 1
        let scale = UIScreen.mainScreen().scale
        let cellSize = (collectionViewLayout as UICollectionViewFlowLayout).itemSize
        thumbnailSize = CGSize(width: cellSize.width * scale, height: cellSize.height * scale)
        // 2
        updateSelectedItems()
        collectionView!.reloadData()
    }
    func updateSelectedItems() {
        // Select the selected items
    }
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        collectionView!.reloadData()
        updateSelectedItems()
    }
    func currentAssetAtIndex(index:NSInteger) -> PHAsset {
        if fetchResults != nil {
            return fetchResults![index] as PHAsset
        } else {
            return selectedAssets[index]
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDelegate
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)  {
        // Update selected Assets
    }
    
    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath)  {
        // Update selected Assets
    }
    
    
    // MARK: UICollectionViewDataSource
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let fetchResult = fetchResults {
            return fetchResult.count
        } else{
            return selectedAssets.count
        }
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("idCell", forIndexPath: indexPath) as AssetListCell
        
        // Populate Cell
        // 1
        let reuseCount = ++cell.reuseCount
        let asset = currentAssetAtIndex(indexPath.item)
        // 2
        let options = PHImageRequestOptions()
        options.networkAccessAllowed = true
        options.resizeMode = .Fast
        // 3
        imageManager.requestImageForAsset(asset,
            targetSize: thumbnailSize,
            contentMode: .AspectFill, options: options)
            { result, info in
                if reuseCount == cell.reuseCount {
                    cell.imageView.image = result
                }
        }

        
        return cell
    }
}
