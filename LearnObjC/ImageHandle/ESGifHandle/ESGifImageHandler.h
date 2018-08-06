//
//  ESGifImageHandler.h
//  EShoreAppLib
//
//  Created by eshore on 2017/8/9.
//  Copyright © 2017年 EShore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ESGifImageHandler : NSObject

/**
 creat gif with images array

 @param imageArray images array
 @param delayTime delay time for each image
 @return an UIImage of animation image
 */
+ (UIImage *)createGifWithImageArray:(NSArray<UIImage *> *)imageArray delayTime:(CGFloat)delayTime;


/**
 creat gif with images array in a specific size

 @param imageArray imageArray images array
 @param delayTime delayTime delay time for each image
 @param imagesize result image size
 @return an UIImage of animation image
 */
+ (UIImage *)createGifWithImageArray:(NSArray<UIImage *> *)imageArray delayTime:(CGFloat)delayTime imageSize:(CGSize)imagesize;


/**
 creat a image with a specific size an origin image

 @param imageSize specific size
 @param originImage origin image
 @return UIImage
 */
+ (UIImage *)imageScaleWithSize:(CGSize)imageSize fromImage:(UIImage *)originImage;

@end
