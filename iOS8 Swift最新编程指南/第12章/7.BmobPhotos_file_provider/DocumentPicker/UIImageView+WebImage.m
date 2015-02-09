//
//  UIImageView+WebImage.m
//
//  Created by Sean O'Connor on 10/07/2014.
//  Copyright (c) 2014 Mojito Fridays. All rights reserved.
//

#import "UIImageView+WebImage.h"

@implementation UIImageView (WebImage)

- (void)setPlaceholderImage:(UIImage *)image
{
    [self setImage:image];
}
- (void)setImageFromUrl:(NSURL *)url
{
    // CREATE THE THE NSURL REQUEST AND RETREIVE THE IMAGE
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self setImage:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Image error: %@", error);
    }];
    [requestOperation start];
}
- (void)setImageFromS3withAccessKey:(NSString *)accessKey
                          secretKey:(NSString *)secretKey
                          keyString:(NSString *)keyString
                       bucketString:(NSString *)bucketString
{
    // UPLOAD THE IMAGES TO THE AWS S3 BUCKET
    AmazonS3Client *s3 = [[AmazonS3Client alloc] initWithAccessKey:accessKey withSecretKey:secretKey];

    
    // GET THE IMAGE DATA FROM THE BUCKET AYNCHRONOUSLY
    S3TransferManager *transferManager = [S3TransferManager new];
    [transferManager setS3:s3];
    [transferManager setDelegate:self];
    [transferManager downloadFile:Nil bucket:bucketString key:keyString];
}

#pragma mark -  Amazon Service Request Response delegate protocols
- (void)request:(AmazonServiceRequest *)request didCompleteWithResponse:(AmazonServiceResponse *)response
{
    BOOL completedSuccessfully = ![response error];
    
    if (completedSuccessfully) {
        S3GetObjectResponse *getResponse = (S3GetObjectResponse *)response;
        NSData *data = getResponse.body;
        [self setImage:[UIImage imageWithData:data]];
    }
}


@end
