//
//  PieChartDataItem.h
//  chartsDemo
//
//  Created by eshore on 2017/3/7.
//  Copyright © 2017年 HWY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PieChartDataItem : NSObject

+ (instancetype)dataItemWithValue:(CGFloat)value
                            color:(UIColor*)color;

+ (instancetype)dataItemWithValue:(CGFloat)value
                            color:(UIColor*)color
                      description:(NSString *)description;

@property (nonatomic) CGFloat   value;
@property (nonatomic) UIColor  *color;
@property (nonatomic) NSString *textDescription;

@end
