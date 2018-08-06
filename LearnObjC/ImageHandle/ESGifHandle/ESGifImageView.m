//
//  ESGifImageView.m
//  EShoreAppLib
//
//  Created by eshore on 2017/8/8.
//  Copyright © 2017年 EShore. All rights reserved.
//

#import "ESGifImageView.h"
#import "UIImage+ESGIF.h"

@implementation ESGifImageView

- (instancetype)initWithGifData:(NSData *)gifData
{
    self = [super init];
    UIImage *gifImage = [UIImage animatedGIFWithData:gifData];
    if (!gifImage) {
        NSLog(@"could not load image data");
        return self;
    }
    self.image = gifImage;
    [self sizeToFit];
    return self;
}

- (instancetype)initWithGifFilePath:(NSString *)filePath
{
    self = [super init];
    NSData *gifData = [NSData dataWithContentsOfFile:filePath];
    if (!gifData) {
        NSLog(@"could not load data from filePath");
        return self;
    }
    UIImage *gifImage = [UIImage animatedGIFWithData:gifData];
    if (!gifData) {
        NSLog(@"could not load image from filePath");
    }
    self.image = gifImage;
    [self sizeToFit];
    return self;
}

@end
