//
//  NoteManager.swift
//  HandOffNote
//
//  Created by yanghongyan on 15/1/23.
//  Copyright (c) 2015年 yanghongyan. All rights reserved.
//

import Foundation

class NoteManager: NSObject {
    
    let savedFileName = "NoteManager"
    
    private var items = [Note]()
    
    var fileURL: NSURL? {
        get {
            var error: NSError?
            var URL: NSURL? = NSFileManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true, error: nil)
            if URL != nil {
                let docURL = URL!.URLByAppendingPathComponent(savedFileName)
                return docURL
            } else {
                NSLog("Error getting user documents directory: \(error?.localizedDescription)")
            }
            return nil
        }
    }
    
    // MARK: Public
    
    class func shareInstance() -> NoteManager {
        struct SharedInstance {
            static let instance = NoteManager()
        }
        return SharedInstance.instance
    }
    
    func fetchItems(completion: (items:[Note]) -> Void) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
            
            var unarchived: [Note]?
            if let path = self.fileURL?.relativePath {
                unarchived = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as [Note]?
            }
            if let savedItems = unarchived {
                self.items += savedItems
            }
            dispatch_async(dispatch_get_main_queue(), {
                completion(items: self.items)
            })
        })
    }
    
    func updateItems(newItems: [Note]) {
        items = newItems
    }
    
    func commit() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
            if let path = self.fileURL?.relativePath {
                let success = NSKeyedArchiver.archiveRootObject(self.items, toFile: path)
                println("Commited \(countElements(self.items)) items: \(success)")
            }
        })
    }
    
}
