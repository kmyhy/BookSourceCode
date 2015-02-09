//
//  UIImageView+Web.m
//  LTWebImageView
//
//  Created by ltebean on 14/10/13.
//  Copyright (c) 2014年 ltebean. All rights reserved.
//

#import "UIImageView+Web.h"

@implementation UIImageView (Web)
-(void) setImageWithUrl:(NSURL*) url completionHandler:(void (^)(UIImage*)) handler
{
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    spinner.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    [self addSubview:spinner];
    [spinner startAnimating];
    
    
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        [spinner removeFromSuperview];
        
        if(connectionError){
            handler(nil);
            return;
        }
        
        UIImage *image = [[UIImage alloc] initWithData:data];
        [self setImage:image];
        handler(image);
    }];
}

@end
