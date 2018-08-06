//
//  UIImage+ESGIF.h
//  iTemplete_social
//
//  Created by WilliamChen on 16/9/19.
//  Copyright © 2016年 EShore. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface UIImage (ESGIF)

/**
 *  将data转换为一张动态图片
 *
 *  @param data 需要转换的data
 *
 *  @return 动态图片，失败时为 nil
 */
+ (UIImage *)animatedGIFWithData:(NSData *)data;

@end
