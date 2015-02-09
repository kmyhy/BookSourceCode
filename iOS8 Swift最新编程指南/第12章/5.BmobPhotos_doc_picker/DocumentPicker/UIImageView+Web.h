//
//  UIImageView+Web.h
//  LTWebImageView
//
//  Created by ltebean on 14/10/13.
//  Copyright (c) 2014年 ltebean. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImageView(Web)

-(void) setImageWithUrl:(NSURL*) url completionHandler:(void (^)(UIImage*)) handler;

@end
