//
//  UIViewController+ESScrollPage.m
//  LearnObjC
//
//  Created by eshore on 2017/7/30.
//  Copyright © 2017年 howell. All rights reserved.
//

#import "UIViewController+ESScrollPage.h"
#import "ESScrollPageViewDelegate.h"
#import <objc/runtime.h>

char ESIndexKey;
@implementation UIViewController (ESScrollPage)


- (UIViewController *)scrollViewController {
    UIViewController *controller = self;
    while (controller) {
        if ([controller conformsToProtocol:@protocol(ESScrollPageViewDelegate)]) {
            break;
        }
        controller = controller.parentViewController;
    }
    return controller;
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    objc_setAssociatedObject(self, &ESIndexKey, [NSNumber numberWithInteger:currentIndex], OBJC_ASSOCIATION_ASSIGN);
}

- (NSInteger)currentIndex {
    return [objc_getAssociatedObject(self, &ESIndexKey) integerValue];
}

@end
