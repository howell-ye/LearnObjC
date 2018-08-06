//
//  PieChartDataItem.m
//  chartsDemo
//
//  Created by eshore on 2017/3/7.
//  Copyright © 2017年 HWY. All rights reserved.
//

#import "PieChartDataItem.h"
#import <UIKit/UIKit.h>

@implementation PieChartDataItem

+ (instancetype)dataItemWithValue:(CGFloat)value
                            color:(UIColor*)color{
    PieChartDataItem *item = [PieChartDataItem new];
    item.value = value;
    item.color  = color;
    return item;
}

+ (instancetype)dataItemWithValue:(CGFloat)value
                            color:(UIColor*)color
                      description:(NSString *)description {
    PieChartDataItem *item = [PieChartDataItem dataItemWithValue:value color:color];
    item.textDescription = description;
    return item;
}

- (void)setValue:(CGFloat)value{
//    NSAssert(value >= 0, @"value should >= 0");
    if (value != _value){
        _value = value;
    }
}

@end
