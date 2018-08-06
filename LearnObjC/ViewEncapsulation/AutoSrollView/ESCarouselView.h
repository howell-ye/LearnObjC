//
//  ESCarouselView.h
//  LearnObjC
//
//  Created by eshore on 2017/8/1.
//  Copyright © 2017年 howell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESCarouselStyle.h"

@class ESCarouselView;

@protocol ESCarouselViewDelegate <NSObject>

@optional

// 点击图片回调
- (void)carouselView:(ESCarouselView *)carouselView didSelectItemAtIndex:(NSInteger)index;
// 图片滚动回调
- (void)carouselView:(ESCarouselView *)carouselView didScrollToIndex:(NSInteger)index;
// 订制cell的view
- (void)customViewForcell:(UICollectionViewCell *)cell forIndex:(NSInteger)index carouselView:(ESCarouselView *)view;

// 获取contentOffset
- (void)carouselView:(ESCarouselView *)carouselView currentOffset:(CGPoint)contentOffset;

@end

@interface ESCarouselView : UIView

//本地图片初始化
-(instancetype)initWithFrame:(CGRect)frame carouselStyle:(ESCarouselStyle *)style delegate:(id<ESCarouselViewDelegate>)delegate imageNamesArray:(NSArray *)imageNamesArray titlesArray:(NSArray *)titlesArray;
//网络图片初始化
-(instancetype)initWithFrame:(CGRect)frame carouselStyle:(ESCarouselStyle *)style delegate:(id<ESCarouselViewDelegate>)delegate imageURLStringsArray:(NSArray *)imageURLStringsArray titlesArray:(NSArray *)titlesArray placeholderImage:(UIImage *)placeholderImage;

- (void)reloadWithImageNamesArray:(NSArray *)imageNamesArray titlesArray:(NSArray *)titlesArray;

- (void)reloadWithImageURLStringsArray:(NSArray *)imageURLStringsArray titlesArray:(NSArray *)titlesArray;

//解决viewWillAppear时出现时轮播图卡在一半的问题，在控制器viewWillAppear时调用此方法
- (void)adjustWhenControllerViewWillAppera;

//清除图片缓存，主要用于收到内存警告
- (void)clearImagesCache;

@end

