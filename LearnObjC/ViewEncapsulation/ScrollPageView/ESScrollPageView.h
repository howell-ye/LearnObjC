//
//  ESScrollPageView.h
//  LearnObjC
//
//  Created by eshore on 2017/7/28.
//  Copyright © 2017年 howell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESScrollPageTitleView.h"
#import "UIView+es_add.h"
#import "ESScrollPageContentView.h"

@interface ESScrollPageView : UIView

@property (weak, nonatomic, readonly) ESScrollPageContentView *contentView;
@property (weak, nonatomic, readonly) ESScrollPageBarView *barView;

/** 必须设置代理并且实现相应的方法*/
@property(weak, nonatomic)id<ESScrollPageViewDelegate> delegate;


- (instancetype)initWithFrame:(CGRect)frame scrollPageStyle:(ESScrollPageStyle *)scrollPageStyle titles:(NSArray<NSString *> *)titles parentViewController:(UIViewController *)parentViewController delegate:(id<ESScrollPageViewDelegate>) delegate ;

/** 给外界设置选中的下标的方法 */
- (void)setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated;

/**  给外界重新设置的标题的方法(同时会重新加载页面的内容) */
- (void)reloadWithNewTitles:(NSArray<NSString *> *)newTitles;

@end
