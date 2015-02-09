//
//  Utils.swift
//  Splicer
//
//  Created by yanghongyan on 15/1/16.
//  Copyright (c) 2015年 yanghongyan. All rights reserved.
//

import Foundation
import Photos
import CoreGraphics

let spliceWidth = 900
let maxPhotosOfSplice = 6

let adjustmentFormatID = NSBundle.mainBundle().bundleIdentifier

func createNewSplice(assets: [PHAsset], inCollection collection: PHAssetCollection) {
    // 1
    let image = createSpliceImageFromAssets(assets)
    
    // 2
    var spliceRef: PHObjectPlaceholder!
    PHPhotoLibrary.sharedPhotoLibrary().performChanges({
        // 3
        let assetChangeRequest =
        PHAssetChangeRequest.creationRequestForAssetFromImage(
            image)
        spliceRef =
            assetChangeRequest.placeholderForCreatedAsset
        
        // 4
        let assetCollectionChangeRequest =
        PHAssetCollectionChangeRequest(
            forAssetCollection: collection, assets: nil)
        assetCollectionChangeRequest.addAssets(
            [spliceRef])
        }, completionHandler: nil)
}

func editSpliceContent(spliceAsset: PHAsset, image: UIImage, assets: [PHAsset]) {
    
}

func loadAssetsInSplice(asset: PHAsset, completion: [PHAsset] -> ()) {
    
}

func createSpliceImageFromAssets(assets: [PHAsset]) -> UIImage {
    var assetCount = assets.count
    
    assetCount =  assetCount > maxPhotosOfSplice ? maxPhotosOfSplice:assetCount
    
    let placementRects = placementRectsForAssetCount(assetCount)
    
    let scale = UIScreen.mainScreen().scale
    UIGraphicsBeginImageContextWithOptions(CGSize(width: spliceWidth, height: spliceWidth), true, scale)
    
    let options = PHImageRequestOptions()
    options.synchronous = true
    options.resizeMode = .Exact
    options.deliveryMode = .HighQualityFormat
    
    for (i: Int, asset: PHAsset) in enumerate(assets) {
        if (i >= assetCount) {
            break
        }
        let rect = placementRects[i]
        let targetSize = CGSize(width: CGRectGetWidth(rect)*scale, height: CGRectGetHeight(rect)*scale)
        PHImageManager.defaultManager().requestImageForAsset(asset, targetSize:targetSize, contentMode:.AspectFill, options:options) { result, _ in
            if result.size != targetSize {
                let croppedResult = cropImageToCenterSquare(result, targetSize)
                croppedResult.drawInRect(rect)
            } else {
                result.drawInRect(rect)
            }
        }
    }
    
    // Grab results
    let result = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return result
}

func placementRectsForAssetCount(count: Int) -> [CGRect] {
    var rects: [CGRect] = []
    
    var evenCount: Int
    var oddCount: Int
    if count % 2 == 0 {
        evenCount = count
        oddCount = 0
    } else {
        oddCount = 1
        evenCount = count - oddCount
    }
    
    let rectHeight = spliceWidth / (evenCount / 2 + oddCount)
    let evenWidth = spliceWidth / 2
    let oddWidth = spliceWidth
    
    for i in 0..<evenCount {
        let rect = CGRect(x: i%2 * evenWidth, y: i/2 * rectHeight, width: evenWidth, height: rectHeight)
        rects.append(rect)
    }
    
    if oddCount > 0 {
        let rect = CGRect(x: 0, y: evenCount/2 * rectHeight, width: oddWidth, height: rectHeight)
        rects.append(rect)
    }
    
    return rects
}

func cropImageToCenterSquare(image: UIImage, size: CGSize) -> UIImage {
    let ratio = min(image.size.width / size.width, image.size.height / size.height)
    
    let newSize = CGSize(width: image.size.width / ratio, height: image.size.height / ratio)
    let offset = CGPoint(x: 0.5 * (size.width - newSize.width), y: 0.5 * (size.height - newSize.height))
    let rect = CGRect(origin: offset, size: newSize)
    
    UIGraphicsBeginImageContext(size)
    image.drawInRect(rect)
    let output = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return output
}
