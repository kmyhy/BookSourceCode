//
//  StringExtension.swift
//  YDQX
//
//  Created by yanghongyan on 14/12/4.
//  Copyright (c) 2014年 yanghongyan. All rights reserved.
//

import Foundation

extension String{
    func isMatch(pattern:String)->Bool{
        var rx = NSRegularExpression(pattern: pattern)
        return rx.isMatch(self)
    }
}