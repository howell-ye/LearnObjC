//
//  ESScrollPageCollectionView.h
//  LearnObjC
//
//  Created by eshore on 2017/7/30.
//  Copyright © 2017年 howell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ESScrollPageCollectionView : UICollectionView

typedef BOOL(^ESScrollViewShouldBeginPanGestureHandler)(ESScrollPageCollectionView *collectionView, UIPanGestureRecognizer *panGesture);

- (void)setupScrollViewShouldBeginPanGestureHandler:(ESScrollViewShouldBeginPanGestureHandler)gestureBeginHandler;

@end
