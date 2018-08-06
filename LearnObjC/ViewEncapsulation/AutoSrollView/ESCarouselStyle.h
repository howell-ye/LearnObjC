//
//  ESCarouselStyle.h
//  EShoreAppLib
//
//  Created by eshore on 2017/8/2.
//  Copyright © 2017年 EShore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    ESCarouselViewPageContolAlimentLeft,
    ESCarouselViewPageContolAlimentRight,
    ESCarouselViewPageContolAlimentCenter,
    ESCarouselViewPageContolCustom
} ESCarouselViewPageContolAliment;

@interface ESCarouselStyle : NSObject

/** 自动滚动间隔时间,默认3s */
@property (nonatomic, assign) CGFloat autoScrollTimeInterval;

/** 是否无限循环,默认Yes */
@property (nonatomic,assign) BOOL infiniteLoop;

/** 是否自动滚动,默认Yes */
@property (nonatomic,assign) BOOL autoScroll;

//////////////////////  自定义样式API  //////////////////////

@property (nonatomic, strong) UIColor *carouselBGColor;

/** 占位图，用于网络未加载到图片时 */
@property (nonatomic, strong) UIImage *placeholderImage;

/** 是否显示分页控件 */
@property (nonatomic, assign) BOOL showPageControl;

/** 分页控件位置 */
@property (nonatomic, assign) ESCarouselViewPageContolAliment pageControlAliment;

/** 当前分页控件小圆标颜色 */
@property (nonatomic, strong) UIColor *currentPageDotColor;

/** 其他分页控件小圆标颜色 */
@property (nonatomic, strong) UIColor *pageDotColor;

/** 分页控件小圆标个数 */
@property (nonatomic, assign)  NSInteger pageDotNumber;

/** 分页控件的圆点宽度根据图片张数自适应，高度固定，故让用户定义位置 */
@property (nonatomic, assign) CGPoint pageControlLocation;

/** 轮播文字label字体颜色 */
@property (nonatomic, strong) UIColor *titleLabelTextColor;

/** 轮播文字label字体大小 */
@property (nonatomic, strong) UIFont  *titleLabelTextFont;

/** 轮播文字label背景颜色 */
@property (nonatomic, strong) UIColor *titleLabelBackgroundColor;

/** 轮播文字label高度 */
@property (nonatomic, assign) CGRect titleLabelFrame;

/** 轮播文字label对齐方式 */
@property (nonatomic, assign) NSTextAlignment titleLabelTextAlignment;

@end
