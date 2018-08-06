//
//  ESScrollPageBarView.h
//  LearnObjC
//
//  Created by eshore on 2017/7/28.
//  Copyright © 2017年 howell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESScrollPageViewDelegate.h"
@class ESScrollPageStyle;
@class ESScrollPageTitleView;


typedef void(^TitleBtnOnClickBlock)(ESScrollPageTitleView *titleView, NSInteger index);

@interface ESScrollPageBarView : UIView

// 所有的标题
@property (strong, nonatomic) NSArray *titles;
// 所有标题的设置
@property (strong, nonatomic) ESScrollPageStyle *barStyle;
@property (weak, nonatomic) id<ESScrollPageViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect )frame barStyle:(ESScrollPageStyle *)style delegate:(id<ESScrollPageViewDelegate>)delegate titles:(NSArray *)titles titleDidClick:(TitleBtnOnClickBlock)titleDidClick;


/** 切换下标的时候根据progress同步设置UI*/
- (void)adjustUIWithProgress:(CGFloat)progress oldIndex:(NSInteger)oldIndex currentIndex:(NSInteger)currentIndex;
/** 让选中的标题居中*/
- (void)adjustTitleOffSetToCurrentIndex:(NSInteger)currentIndex;
/** 设置选中的下标*/
- (void)setSelectedIndex:(NSInteger)index animated:(BOOL)animated;
/** 重新刷新标题的内容*/
- (void)reloadTitlesWithNewTitles:(NSArray *)titles;

@end
