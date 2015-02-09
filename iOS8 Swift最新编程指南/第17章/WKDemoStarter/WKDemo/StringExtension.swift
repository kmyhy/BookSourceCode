//
//  StringExtension.swift
//  YDQX
//
//  Created by yanghongyan on 14/12/4.
//  Copyright (c) 2014年 yanghongyan. All rights reserved.
//

import Foundation

extension String{
    func urlEncode()->String?{
        return self.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)?
    }
    func isMatch(pattern:String)->Bool{
        var rx = NSRegularExpression(pattern: pattern)
        return rx.isMatch(self)
    }
    func dateFromFormatter(formatString:String)->NSDate?{
        let formatter = NSDateFormatter()
        formatter.dateFormat = formatString
        return formatter.dateFromString(self)
    }
    
    func leftString(charToGet: Int) ->String{
        var indexCount = 0
        let strLen = countElements(self)
        
        if charToGet > strLen { indexCount = strLen } else { indexCount = charToGet }
        if charToGet < 0 { indexCount = 0 }
        
        let index: String.Index = advance(self.startIndex, indexCount)
        let mySubstring:String = self.substringToIndex(index)
        return mySubstring
    }
    func rightString(charToGet: Int) ->String{
        
        var indexCount = 0
        let strLen = countElements(self)
        var charToSkip = strLen - charToGet
        
        if charToSkip > strLen { indexCount = strLen } else { indexCount = charToSkip }
        if charToSkip < 0 { indexCount = 0 }
        
        let index: String.Index = advance(self.startIndex, indexCount)
        let mySubstring:String = self.substringFromIndex(index)
        
        return mySubstring
    }
    func midString(startPos: Int, charToGet: Int) ->String{
        
        let strLen = countElements(self)
        var rightCharCount = strLen - startPos
        
        var mySubstring = self.rightString(rightCharCount)
        mySubstring = mySubstring.leftString(charToGet)
        
        return mySubstring
    }
    func insertString(pos:Int,_ strToInsert:String)->String{
        let left = leftString(pos)
        let right = rightString(countElements(self) - pos)
        return "\(left)\(strToInsert)\(right)"
    }
}