//
//  BmobWrapper.swift
//  BmobPhotos
//
//  Created by yanghongyan on 14/12/7.
//  Copyright (c) 2014年 yanghongyan. All rights reserved.
//

import Foundation

let AppKey = "<YOUR BMOB APP KEY>"

func registerBmob(){
    Bmob.registerWithAppKey(AppKey)
}

func uploadImage(filedata:NSData,completion:(Bool,BmobObject!)->Void){
    // 1
    let name = NSUUID().UUIDString
    // 2
    let file = BmobFile(fileName:name, withFileData: filedata)
    // 3
    file.saveInBackgroundByDataSharding({ (success, error) -> Void in
        if success {
            // 4
            let object = BmobObject(className: "Photos")
            object.setObject(name, forKey: "name")
            object.setObject(file, forKey: "file")
            // 5
            object.saveInBackgroundWithResultBlock({ (success, error) -> Void in
                if success == false {
                    println("insert row error:\(error.localizedDescription)")
                }
                // 6
                completion(success,object)
            })
        }else{
            println("upload error:\(error.localizedDescription)")
            // 7
            completion(false,nil)
        }
    })
}