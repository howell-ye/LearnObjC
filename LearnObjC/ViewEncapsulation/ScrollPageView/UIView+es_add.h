//
//  UIView+es_add.h
//  LearnObjC
//
//  Created by eshore on 2017/7/30.
//  Copyright © 2017年 howell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (es_add)

/// frame.origin.x
@property (nonatomic) CGFloat left;
/// frame.origin.y
@property (nonatomic) CGFloat top;
/// frame.origin.x + frame.size.width
@property (nonatomic) CGFloat right;
/// frame.origin.y + frame.size.height
@property (nonatomic) CGFloat bottom;
/// frame.size.width
@property (nonatomic) CGFloat width;
/// frame.size.height
@property (nonatomic) CGFloat height;
/// center.x
@property (nonatomic) CGFloat centerX;
/// center.y
@property (nonatomic) CGFloat centerY;
/// frame.origin
@property (nonatomic) CGPoint origin;
/// frame.size
@property (nonatomic) CGSize size;


/// 返回 view 所在的 viewController，若没有，则返回 nil.
@property (nullable, nonatomic, readonly) UIViewController *viewController;

/// 移除所有的 subview
- (void)removeAllSubviews;

@end
