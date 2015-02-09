//
//  UserInfo.swift
//  PhotoShare
//
//  Created by yanghongyan on 15/1/7.
//  Copyright (c) 2015年 yanghongyan. All rights reserved.
//

import UIKit
import CloudKit

class UserInfo: NSObject {
    var userRecordID : CKRecordID!
    
    func userLoginStatus(completion : (accountStatus : CKAccountStatus, error : NSError?) -> ()) {
        container.accountStatusWithCompletionHandler() { (status : CKAccountStatus, error : NSError!) in
            completion(accountStatus: status, error: error)
        }
    }
    
    func userID(completion: (userRecordID: CKRecordID!, error: NSError!)->()) {
        if userRecordID != nil {
            completion(userRecordID: userRecordID, error: nil)
        } else {
            container.fetchUserRecordIDWithCompletionHandler() {
                recordID, error in
                if recordID != nil {
                    self.userRecordID = recordID
                }
                completion(userRecordID: recordID, error: error)
            }
        }
    }
    
    func userInfo(completion: (userInfo: CKDiscoveredUserInfo!, error: NSError!)->()) {
        requestDiscoverability() { discoverable in
            self.userID() { recordID, error in
                if error != nil {
                    completion(userInfo: nil, error: error)
                } else {
                    container.discoverUserInfoWithUserRecordID(recordID,
                        completionHandler:completion)
                }
            }
        }
    }
    
    func requestDiscoverability(completion: (discoverable: Bool) -> ()) {
        container.statusForApplicationPermission(
            .PermissionUserDiscoverability) {
                status, error in
                if error != nil || status == CKApplicationPermissionStatus.Denied {
                    completion(discoverable: false)
                } else {
                    container.requestApplicationPermission(.PermissionUserDiscoverability) { status, error in
                        completion(discoverable: status == .Granted)
                    }
                }
        }
    }
}
