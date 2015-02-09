//
//  Globals.swift
//  PhotoShare
//
//  Created by yanghongyan on 15/1/7.
//  Copyright (c) 2015年 yanghongyan. All rights reserved.
//

import Foundation
import CloudKit

let container = CKContainer.defaultContainer()
let publicDB = container.publicCloudDatabase
let privateDB = container.privateCloudDatabase

let userInfo = UserInfo()

var hud:MBProgressHUD?

let DEBUG = 1

func DLog(message: String, filename: String = __FILE__, function: String = __FUNCTION__, line: Int = __LINE__) {
    if DEBUG == 1 {
        println("[\(filename.lastPathComponent):\(line)] \(function) - \(message)")
    }
}