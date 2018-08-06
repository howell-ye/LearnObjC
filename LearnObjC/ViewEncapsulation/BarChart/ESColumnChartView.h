//
//  ESBarChartView.h
//  LearnObjC
//
//  Created by yezhihao on 2017/8/7.
//  Copyright © 2017年 eshore. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ESColumnChartViewDelegate<NSObject>

@optional
- (void)columnItem:(UIView *)item didClickAtIndexRow:(NSIndexPath *)indexPath;
@end

@interface ESColumnChartView : UIView


/**
 *  Each histogram of the background color, if you do not set the default value for green. Setup must ensure that the number and type of the data source array are the same, otherwise the default is not set.
 */
@property (nonatomic, strong) NSArray<UIColor *> * columnBGcolorsArr;

/// ESColumnChartViewDelegate的代理，用以监听柱状图某一项的点击事件
@property (nonatomic , assign)id <ESColumnChartViewDelegate> delegate;

/**
 *  The fontsize of Y line text.Default id 8;
 */
@property (nonatomic,assign) CGFloat yDescTextFontSize;



/**
 *  The fontsize of X line text.Default id 8;
 */
@property (nonatomic,assign) CGFloat xDescTextFontSize;

/**
 *  Data source array
 */
@property (nonatomic, strong) NSArray<NSArray *> * valueArr;

/**
 *  X axis classification of each icon
 */
@property (nonatomic, strong) NSArray * xShowInfoText;


/**
 *  The background color of the content view
 */
@property (nonatomic, strong) UIColor  * bgVewBackgoundColor;


/**
 *  Column spacing, non continuous, default is 5
 */
@property (nonatomic, assign) CGFloat typeSpace;

/**
 *  The width of the column, the default is 40
 */
@property (nonatomic, assign) CGFloat columnWidth;

/**
 *  Whether the need for Y, X axis, the default YES
 */
@property (nonatomic, assign) BOOL needXandYLine;

/**
 *  Y, X axis line color
 */
@property (nonatomic, strong) UIColor * colorForXYLine;

/**
 *  X, Y axis text description color
 */
@property (nonatomic, strong) UIColor * drawTextColorForX_Y;

/**
 *  Dotted line guide color
 */
@property (nonatomic, strong) UIColor * dashColor;

/**
 *  The starting point, can be understood as the origin of the left and bottom margins
 */
@property (nonatomic, assign) CGPoint originSize;

/**
 *  Starting from the origin of the horizontal distance histogram
 */
@property (nonatomic, assign) CGFloat drawFromOriginX;

/**
 *  Whether this chart show Y line or not .Default is Yes
 */

/**
 *  Whether this chart show line or not.Default is NO;
 */
//@property (nonatomic,assign) BOOL isShowLineChart;


/**
 *  If isShowLineChart proprety is YES,we need this value array to draw chart
 */
//@property (nonatomic,strong)NSArray * lineValueArray;


/**
 *  If isShowLineChart proprety is Yes,we will draw path of this linechart with this color
 *  Default is blue
 */
//@property (nonatomic,strong)UIColor * lineChartPathColor;

/**
 *  if isShowLineChart proprety is Yes,we will draw this linechart valuepoint with this color
 *  Default is yellow
 */
//@property (nonatomic,strong)UIColor * lineChartValuePointColor;

/**
 *  Start drawing chart.
 */
- (void)showAnimation;

@end
