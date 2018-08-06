//
//  ESScrollPageCollectionView.m
//  LearnObjC
//
//  Created by eshore on 2017/7/30.
//  Copyright © 2017年 howell. All rights reserved.
//

#import "ESScrollPageCollectionView.h"

@interface ESScrollPageCollectionView()

@property (copy, nonatomic) ESScrollViewShouldBeginPanGestureHandler gestureBeginHandler;

@end

@implementation ESScrollPageCollectionView

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (_gestureBeginHandler && gestureRecognizer == self.panGestureRecognizer) {
        return _gestureBeginHandler(self, (UIPanGestureRecognizer *)gestureRecognizer);
    }
    else {
        return [super gestureRecognizerShouldBegin:gestureRecognizer];
    }
}

- (void)setupScrollViewShouldBeginPanGestureHandler:(ESScrollViewShouldBeginPanGestureHandler)gestureBeginHandler {
    _gestureBeginHandler = [gestureBeginHandler copy];
}

@end
