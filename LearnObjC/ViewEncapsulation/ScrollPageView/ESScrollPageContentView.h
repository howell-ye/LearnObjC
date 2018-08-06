//
//  ESScrollPageContentView.h
//  LearnObjC
//
//  Created by eshore on 2017/7/28.
//  Copyright © 2017年 howell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESScrollPageViewDelegate.h"
#import "ESScrollPageBarView.h"
#import "ESScrollPageCollectionView.h"

@interface ESScrollPageContentView : UIView

/** 必须设置代理和实现相关的方法*/
@property (strong, nonatomic, readonly) ESScrollPageCollectionView *collectionView;
@property(weak, nonatomic)id<ESScrollPageViewDelegate> delegate;
// 当前控制器
@property (strong, nonatomic, readonly) UIViewController<ESScrollPageViewChildVcDelegate> *currentChildVc;

/**初始化方法
 *
 */
- (instancetype)initWithFrame:(CGRect)frame barView:(ESScrollPageBarView *)barView parentViewController:(UIViewController *)parentViewController delegate:(id<ESScrollPageViewDelegate>) delegate;

/** 给外界可以设置ContentOffSet的方法 */
- (void)setContentOffSet:(CGPoint)offset animated:(BOOL)animated;
/** 给外界 重新加载内容的方法 */
- (void)reload;

@end
