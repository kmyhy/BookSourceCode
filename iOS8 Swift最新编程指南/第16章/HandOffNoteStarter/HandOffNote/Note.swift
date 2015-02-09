//
//  Note.swift
//  HandOffNote
//
//  Created by yanghongyan on 15/1/23.
//  Copyright (c) 2015年 yanghongyan. All rights reserved.
//

import UIKit

class Note: NSObject,NSCoding {
    var NoteID:String!
    var createTime:NSDate!
    var content:String!
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(NoteID, forKey: "note_id")
        aCoder.encodeObject(createTime, forKey: "create_time")
        aCoder.encodeObject(content, forKey: "content")
    }
    required init(coder aDecoder: NSCoder) {
        NoteID = aDecoder.decodeObjectForKey("note_id") as String
        createTime = aDecoder.decodeObjectForKey("create_time") as NSDate
        content = aDecoder.decodeObjectForKey("content") as String
    }
    override init(){
        NoteID = NSUUID().UUIDString
    }
    var createTimeString:String?{
        if createTime != nil {
            return dateFormater().stringFromDate(createTime!)
        }else{
            return nil
        }
    }
    private func dateFormater()->NSDateFormatter{
        let df = NSDateFormatter()
        df.dateFormat = "yyyy年M月d日 HH:mm"
        return df
    }
}
