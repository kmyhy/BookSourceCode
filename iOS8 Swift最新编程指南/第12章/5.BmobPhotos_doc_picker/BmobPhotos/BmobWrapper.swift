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
    //    registerBmob()
    let name = NSUUID().UUIDString
    let file = BmobFile(fileName:name, withFileData: filedata)
    file.saveInBackgroundByDataSharding({ (success, error) -> Void in
        if success {
            let object = BmobObject(className: "Photos")
            object.setObject(name, forKey: "name")
            object.setObject(file, forKey: "file")
            object.saveInBackgroundWithResultBlock({ (success, error) -> Void in
                if success == false {
                    println("insert row error:\(error.localizedDescription)")
                }
                completion(success,object)
            })
            
        }else{
            println("upload error:\(error.localizedDescription)")
            completion(false,nil)
        }
    })
}
func loadBmobObjects(completion:([BmobObject])->Void)->Void{
    var query = BmobQuery(className: "Photos")
    query.findObjectsInBackgroundWithBlock { (array, error) -> Void in
        if error == nil {
            if let result = array as? [BmobObject]{            completion(result)
            }
        }else{
            println("\(error.localizedDescription)")
        }
    }
}
func loadFileData(name:String,completion:(NSData)->Void){
    // 1
    var query = BmobQuery(className: "Photos")
    query.whereKey("name", equalTo: name)
    // 2
    query.findObjectsInBackgroundWithBlock { (array, error) -> Void in
        if error == nil {
            // 3
            if let firstObj = array.first as? BmobObject{
                // 4
                let file = firstObj.objectForKey("file") as BmobFile
                if let fileUrl = NSURL(string: file.url){
                    if let data = NSData(contentsOfURL: fileUrl) {
                        completion(data)
                    }
                }
            }
        }else{
            println("\(error.localizedDescription)")
        }
    }
}
