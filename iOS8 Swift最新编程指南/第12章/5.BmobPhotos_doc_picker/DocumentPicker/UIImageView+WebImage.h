//
//  UIImageView+WebImage.h
//
//  Created by Sean O'Connor on 10/07/2014.
//  Copyright (c) 2014 Mojito Fridays. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFHTTPRequestOperation.h"
#import <AWSS3/AWSS3.h>

@interface UIImageView (WebImage) <AmazonServiceRequestDelegate>

- (void)setPlaceholderImage:(UIImage *)image;
- (void)setImageFromUrl:(NSURL *)url;
- (void)setImageFromS3withAccessKey:(NSString *)accessKey
                          secretKey:(NSString *)secretKey
                          keyString:(NSString *)keyString
                       bucketString:(NSString *)bucketString;

@end
