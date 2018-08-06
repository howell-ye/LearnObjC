//
//  ESScrollPageStyle.h
//  LearnObjC
//
//  Created by eshore on 2017/7/28.
//  Copyright © 2017年 howell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ESScrollPageStyle : NSObject

//滚动条的背景颜色，默认为白色
@property (nonatomic, strong)UIColor *scrollBarBGColor;
//默认顶部滚动条的高度
@property (nonatomic, assign)CGFloat scrollBarHeight;
//未选中时字体的大小
@property (nonatomic, strong)UIFont *unSelectedFont;
//选中时字体的大小
@property (nonatomic, strong)UIFont *selectedFont;
//未选中时字体的颜色
@property (nonatomic, strong)UIColor *unSelectedColor;
//选中时字体的颜色
@property (nonatomic, strong)UIColor *selectedColor;
//自适应时标题之间的间隔
@property (nonatomic, assign)CGFloat titleMargin;
/** 是否滚动标题 默认为YES 设置为NO的时候所有的标题将不会滚动, 并且宽度会平分 和系统的segment效果相似 */
@property (assign, nonatomic, getter=isScrollTitle) BOOL scrollTitle;
/** 内容view是否能滑动 默认为YES*/
@property (assign, nonatomic, getter=isScrollContentView) BOOL scrollEnabled;

@end
