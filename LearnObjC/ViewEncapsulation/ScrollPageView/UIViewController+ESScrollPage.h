//
//  UIViewController+ESScrollPage.h
//  LearnObjC
//
//  Created by eshore on 2017/7/30.
//  Copyright © 2017年 howell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ESScrollPage)

/**
 *  所有子控制的父控制器, 方便在每个子控制页面直接获取到父控制器进行其他操作
 */
@property (nonatomic, weak, readonly) UIViewController *scrollViewController;

@property (nonatomic, assign) NSInteger currentIndex;

@end
