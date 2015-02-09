//
//  CKPhoto.swift
//  PhotoShare
//
//  Created by yanghongyan on 15/1/7.
//  Copyright (c) 2015年 yanghongyan. All rights reserved.
//

import UIKit
import CoreLocation
import CloudKit


class CKPhoto {
   var record: CKRecord
    var poster: String? {
        get {
            return record.objectForKey("poster") as? String
        }
        set {
            record.setObject(newValue, forKey: "poster")
        }
    }
    
    var description: String? {
        get {
            return record.objectForKey("description") as? String
        }
        set {
            record.setObject(newValue, forKey: "description")
        }
    }
    
    var location: CLLocation? {
        get {
            return record.objectForKey("location") as? CLLocation
        }
        set {
            record.setObject(newValue, forKey: "location")
        }
    }

    var asset: NSURL? {
        get {
            let _asset = record.objectForKey("asset") as? CKAsset
            return _asset?.fileURL
        }
        set {
            let _asset = CKAsset(fileURL: newValue)
            record.setObject(_asset, forKey: "asset")
        }
    }
    
    var id: String? {
        return record.recordID.recordName
    }
    
    var createdAt: NSDate {
        return record.creationDate
    }
    
    var lastModifiedAt: NSDate {
        return record.modificationDate
    }
    
    init(record: CKRecord) {
        self.record = record
    }
    
    init() {
        record = CKRecord(recordType: "Photo")
     }
    
    func processAsset(records: [NSObject : AnyObject]!,
        error: NSError!, completion:(image: UIImage!) -> ()) {
            // 1
            if error != nil {
                completion(image: nil)
                return
            }
            // 2
            let updatedRecord = records[self.record.recordID]
                as CKRecord
            // 3
            if let asset = updatedRecord.objectForKey("asset")
                as? CKAsset {
                    // 4
                    let url = asset.fileURL
                    let im = UIImage(contentsOfFile: url.path!)
                    // 5
                    NSFileManager.defaultManager().copyItemAtPath(url.path!,
                        toPath: imageCachePath(self.id!), error: nil)
                    // 6
                    dispatch_async(dispatch_get_main_queue()) {
                        completion(image: im)
                    }
            } else {
                dispatch_async(dispatch_get_main_queue()) {
                    completion(image: nil)
                }
            }
    }
    func loadImage(completion:(image: UIImage!) -> ()) {
        let backgroundQueue = dispatch_get_global_queue(
            DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)
        // 1
        dispatch_async(backgroundQueue) {
            // 2
            let imagePath = imageCachePath(self.id!)
            // 3
            if NSFileManager.defaultManager()
                .fileExistsAtPath(imagePath) {
                    // 4
                    let image = UIImage(contentsOfFile: imagePath)
                    // 5
                    dispatch_async(dispatch_get_main_queue()) {
                        completion(image: image)
                    }
            } else {
                // 6
                let fetchOp = CKFetchRecordsOperation(recordIDs:
                    [self.record.recordID])
                // 7
                fetchOp.desiredKeys = ["asset"]
                fetchOp.fetchRecordsCompletionBlock = {
                    records, error in
                    // 8
                    self.processAsset(records, error: error,
                        completion: completion)
                }
                // 9
                publicDB.addOperation(fetchOp)
            }
        }
    }
}
