//
//  Menu.swift
//  WKDemo
//
//  Created by yanghongyan on 15/1/28.
//  Copyright (c) 2015年 yanghongyan. All rights reserved.
//

import UIKit

class Menu: NSObject,Printable {
    
    var title: String = ""
    var url: String = ""
    override var description: String {
        return "title: \(title) url: \(url)"
    }
    
    init(dictionary: NSDictionary) {
        self.title = dictionary["title"] as String
        self.url = dictionary["url"] as String
        super.init()
    }
    
}