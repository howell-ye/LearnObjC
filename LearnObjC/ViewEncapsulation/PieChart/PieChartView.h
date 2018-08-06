//
//  PieChartView.h
//  chartsDemo
//
//  Created by eshore on 2017/3/7.
//  Copyright © 2017年 HWY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@interface PieChartView : UIView

- (id)initWithFrame:(CGRect)frame items:(NSArray *)items;

@property (nonatomic, readonly) NSArray	*items;

/** Default is 1.0. */
@property (nonatomic, assign) NSTimeInterval duration;

/** Current outer radius. Override recompute() to change this. **/
@property (nonatomic, assign) CGFloat outerCircleRadius;

/** Current inner radius. Override recompute() to change this. **/
@property (nonatomic, assign) CGFloat innerCircleRadius;
//内外圆半径比
@property (nonatomic, assign) CGFloat radiusRatio;
//是否展示动画
@property (nonatomic, assign) BOOL displayAnimated;
//每个块之间是否显示间隔
@property (nonatomic, assign) BOOL showinterval;

- (void)strokeChart;

@end


