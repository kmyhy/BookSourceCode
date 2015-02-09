//
//  Question.swift
//  PresentationDemo
//
//  Created by yanghongyan on 14/10/19.
//  Copyright (c) 2014年 yanghongyan. All rights reserved.
//

import Foundation

class Question: NSObject {
    var quizQuestion: String = ""
    var quizAnswers: [String] = []
    
    class func questions() ->NSArray {
        let plistFile =
        NSBundle.mainBundle().pathForResource("questions",
            ofType: "plist")
        let plistArray = NSArray(contentsOfFile: plistFile!)
        
        var questionArray = NSMutableArray()
        
        for item in plistArray! {
            var question = Question();
            if let array = item as? NSArray {
                if array.count > 1 {
                    question.quizQuestion = item[0] as String
                    
                    for var i=1; i<array.count; i++ {
                        question.quizAnswers.append(array[i] as String)
                    }
                    
                }
            }
            questionArray.addObject(question)
        }
        
        return NSArray(array: questionArray)
    }
    
}