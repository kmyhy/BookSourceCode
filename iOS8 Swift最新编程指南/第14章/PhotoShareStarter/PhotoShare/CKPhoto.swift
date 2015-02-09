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
    
}
