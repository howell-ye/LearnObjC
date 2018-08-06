//
//  ESGifImageHandler.m
//  EShoreAppLib
//
//  Created by eshore on 2017/8/9.
//  Copyright © 2017年 EShore. All rights reserved.
//

#import "ESGifImageHandler.h"
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/UTCoreTypes.h>
//#import "UIImage+ESGIF.h"

@implementation ESGifImageHandler

+ (UIImage *)createGifWithImageArray:(NSArray<UIImage *> *)imageArray delayTime:(CGFloat)delayTime
{
    if (!imageArray || imageArray.count == 0) {
        return nil;
    }
    
    UIImage *animatedImage;
    
    if (imageArray.count == 1) {
        animatedImage = imageArray[0];
    }
    else {
        NSMutableArray *images = [NSMutableArray array];
        for (UIImage *image in imageArray) {
            CGImageRef imageRef = image.CGImage;
            [images addObject:[UIImage imageWithCGImage:imageRef scale:1.0 orientation:UIImageOrientationUp]];
        }
        
        if (delayTime <=0 ) {
            delayTime = 0.2;
        }
        NSTimeInterval duration = delayTime*imageArray.count;
        animatedImage = [UIImage animatedImageWithImages:images duration:duration];
    }

    return animatedImage;
}

+ (UIImage *)createGifWithImageArray:(NSArray<UIImage *> *)imageArray delayTime:(CGFloat)delayTime imageSize:(CGSize)imagesize
{
    if (!imageArray || imageArray.count == 0) {
        return nil;
    }
    
    UIImage *animatedImage;
    
    if (imageArray.count == 1) {
        animatedImage = imageArray[0];
    }
    else {
        NSMutableArray *images = [NSMutableArray array];
        int i = 0;
        for (UIImage *image in imageArray) {
            
            UIImage *newImage = [ESGifImageHandler imageScaleWithSize:imagesize fromImage:image];
            
            if(newImage == nil)
                NSLog(@"could not scale image in index:%d",i );
            
            UIGraphicsEndImageContext();
            CGImageRef imageRef = newImage.CGImage;
            i++;
            
            [images addObject:[UIImage imageWithCGImage:imageRef scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp]];
        }
        
        if (delayTime <=0 ) {
            delayTime = 0.2;
        }
        NSTimeInterval duration = delayTime*imageArray.count;
        animatedImage = [UIImage animatedImageWithImages:images duration:duration];
    }
    
    return animatedImage;
}

+ (UIImage *)imageScaleWithSize:(CGSize)imageSize fromImage:(UIImage *)originImage
{
    CGSize targetSize = imageSize;
    UIImage *sourceImage = originImage;
    UIImage *newImage = nil;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth= width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    //            UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width= scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    if([[UIScreen mainScreen] scale] == 3.0){
        UIGraphicsBeginImageContextWithOptions(thumbnailRect.size, NO, 3.0);
    }else  if([[UIScreen mainScreen] scale] == 2.0){
        UIGraphicsBeginImageContextWithOptions(thumbnailRect.size, NO, 2.0);
    }else{
        UIGraphicsBeginImageContext(thumbnailRect.size);
    }
    
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    return newImage;
}

//- (UIImage *)createGifWithImageArray:(NSArray<UIImage *> *)imageArray delayTime:(CGFloat)delayTime imageSize:(CGSize)imagesize
//{
//    if (delayTime <=0 ) {
//        delayTime = 0.5;
//    }
//
//    CGImageDestinationRef destination;
//
//    //创建输出路径
//
//    NSArray *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//
//    NSString *documentStr = [document objectAtIndex:0];
//    
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    
//    NSString *textDirectory = [documentStr stringByAppendingPathComponent:@"gif"];
//    
//    [fileManager createDirectoryAtPath:textDirectory withIntermediateDirectories:YES attributes:nil error:nil];
//    
//    NSString *path = [textDirectory stringByAppendingPathComponent:@"test101.gif"];
//    
//    CFURLRef url = CFURLCreateWithFileSystemPath (
//                                                  
//                                                  kCFAllocatorDefault,
//                                                  
//                                                  (CFStringRef)path,
//                                                  
//                                                  kCFURLPOSIXPathStyle,
//                                                  
//                                                  false);
//    
//    //通过一个url返回图像目标
//    
//    destination = CGImageDestinationCreateWithURL(url, kUTTypeGIF, imageArray.count, NULL);
//    
//    //设置gif信息
//    
//    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:10];
//    
//    [dict setObject:[NSNumber numberWithBool:YES] forKey:(NSString*)kCGImagePropertyGIFHasGlobalColorMap];
//    
//    [dict setObject:(NSString *)kCGImagePropertyColorModelRGB forKey:(NSString *)kCGImagePropertyColorModel];
//    
//    [dict setObject:[NSNumber numberWithFloat:16] forKey:(NSString*)kCGImagePropertyDepth];
//    
//    [dict setObject:[NSNumber numberWithInt:0] forKey:(NSString *)kCGImagePropertyGIFLoopCount];
//    
//    NSDictionary *gifProperties = [NSDictionary dictionaryWithObject:dict
//                                   
//                                                              forKey:(NSString *)kCGImagePropertyGIFDictionary];
//    
//    //设置gif的信息,播放间隔时间,基本数据,和delay时间
//    
//    NSDictionary *frameProperties = [NSDictionary dictionaryWithObject:
//                                     
//                                     [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                      
//                                      [NSNumber numberWithFloat:delayTime],
//                                      
//                                      (NSString *)kCGImagePropertyGIFDelayTime, nil]
//                                     
//                                                                forKey:(NSString *)kCGImagePropertyGIFDictionary];
//    
//    //合成gif
//    int i = 0;
//    for (UIImage* dImg in imageArray)
//    {
//        UIImage *newImage = [ESGifImageHandler imageScaleWithSize:imagesize fromImage:dImg];
//        
//        if(newImage == nil)
//            NSLog(@"could not scale image in index:%d",i );
//        
//        UIGraphicsEndImageContext();
//        CGImageRef imageRef = newImage.CGImage;
//        
//        CGImageDestinationAddImage(destination, imageRef, (__bridge CFDictionaryRef)frameProperties);
//        i++;
//        
//    }
//    
//    CGImageDestinationSetProperties(destination, (__bridge CFDictionaryRef)gifProperties);
//    CGImageDestinationFinalize(destination);
//    
//    NSData *gifData = [NSData dataWithContentsOfFile:path];
//    UIImage *image = [UIImage animatedGIFWithData:gifData];
//    
//    return image;
//}

@end
