//
//  PieChartView.m
//  chartsDemo
//
//  Created by eshore on 2017/3/7.
//  Copyright © 2017年 HWY. All rights reserved.
//

#import "PieChartView.h"
#import "PieChartDataItem.h"

static const float intervalPercentage = 0.002;

@interface PieChartView()<CAAnimationDelegate>

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSArray *endPercentages;

@property (nonatomic, strong) UIView         *contentView;
@property (nonatomic, strong) CAShapeLayer   *pieLayer;

- (void)loadDefault;

- (PieChartDataItem *)dataItemForIndex:(NSUInteger)index;
- (CGFloat)startPercentageForItemAtIndex:(NSUInteger)index;
- (CGFloat)endPercentageForItemAtIndex:(NSUInteger)index;
- (CGFloat)ratioForItemAtIndex:(NSUInteger)index;

- (CAShapeLayer *)newCircleLayerWithRadius:(CGFloat)radius
                               borderWidth:(CGFloat)borderWidth
                                 fillColor:(UIColor *)fillColor
                               borderColor:(UIColor *)borderColor
                           startPercentage:(CGFloat)startPercentage
                             endPercentage:(CGFloat)endPercentage;

@end

@implementation PieChartView

-(id)initWithFrame:(CGRect)frame items:(NSArray *)items{
    self = [self initWithFrame:frame];
    if(self){
        _items = [NSArray arrayWithArray:items];
//        [self baseInit];
    }
    
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
//    [self baseInit];
}

- (void)baseInit{
    //在绘制圆形时,应当考虑矩形的宽和高的大小问题,当宽大于高时,绘制饼图时,会超出整个view的范围,因此建议在此处进行判断
    
    CGFloat minimal = (CGRectGetWidth(self.bounds) < CGRectGetHeight(self.bounds)) ? CGRectGetWidth(self.bounds) : CGRectGetHeight(self.bounds);
    
    _outerCircleRadius  = minimal / 2;
    if (_radiusRatio > 0 && _radiusRatio < 1) {
        _innerCircleRadius  = _outerCircleRadius * (1 -_radiusRatio);
    }else{
        _innerCircleRadius = 0;
    }
    //    _outerCircleRadius  = CGRectGetWidth(self.bounds) / 2;
    //    _innerCircleRadius  = CGRectGetWidth(self.bounds) / 6;
    [self loadDefault];
}

- (void)loadDefault{
    __block CGFloat currentTotal = 0;
    CGFloat total = [[self.items valueForKeyPath:@"@sum.value"] floatValue];
    NSMutableArray *endPercentages = [NSMutableArray new];
    [_items enumerateObjectsUsingBlock:^(PieChartDataItem *item, NSUInteger idx, BOOL *stop) {
        if (total == 0){
            [endPercentages addObject:@(1.0 / _items.count * (idx + 1))];
        }else{
            currentTotal += item.value;
            [endPercentages addObject:@(currentTotal / total)];
        }
    }];
    self.endPercentages = [endPercentages copy];
    
    [_contentView removeFromSuperview];
    _contentView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:_contentView];
    
    _pieLayer = [CAShapeLayer layer];
    [_contentView.layer addSublayer:_pieLayer];
}

- (void)preHandleData
{
    //去除掉为0的数据
    if (_items.count == 1) {
        PieChartDataItem *item = _items[0];
        if (item.value < 0) {
            item.value = 0 - item.value;
        }
    }
    
    __block NSMutableArray *newItems = [NSMutableArray array];
    [_items enumerateObjectsUsingBlock:^(PieChartDataItem *item, NSUInteger idx, BOOL *stop) {
        if (item.value >= 0) {
            [newItems addObject:item];
        }
    }];
    _items = newItems;
    
    //将小于1%的数据放大至1%，便于显示
    CGFloat total = [[self.items valueForKeyPath:@"@sum.value"] floatValue];
    [_items enumerateObjectsUsingBlock:^(PieChartDataItem *item, NSUInteger idx, BOOL *stop) {
        if (total > 0 && item.value > 0) {
            if (item.value / total < 0.01) {
                item.value = total * 0.01;
            }
        }
    }];
}

- (void)strokeChart{
    [self baseInit];
    [self preHandleData];
    [self loadDefault];
    PieChartDataItem *currentItem;
    
    for (int i = 0; i < _items.count; i++) {
        currentItem = [self dataItemForIndex:i];
        
        
        CGFloat startPercentage = [self startPercentageForItemAtIndex:i];
        CGFloat endPercentage   = [self endPercentageForItemAtIndex:i];
        
        CGFloat radius = _innerCircleRadius + (_outerCircleRadius - _innerCircleRadius) / 2;
        CGFloat borderWidth = _outerCircleRadius - _innerCircleRadius;
        
        if(self.showinterval){
            CAShapeLayer *currentPieLayer =	[self newCircleLayerWithRadius:radius
                                                               borderWidth:borderWidth
                                                                 fillColor:[UIColor clearColor]
                                                               borderColor:currentItem.color
                                                           startPercentage:(startPercentage + intervalPercentage)
                                                             endPercentage:(endPercentage - intervalPercentage)];
            [_pieLayer addSublayer:currentPieLayer];
        }else{
            CAShapeLayer *currentPieLayer =	[self newCircleLayerWithRadius:radius
                                                               borderWidth:borderWidth
                                                                 fillColor:[UIColor clearColor]
                                                               borderColor:currentItem.color
                                                           startPercentage:startPercentage
                                                             endPercentage:endPercentage];
            [_pieLayer addSublayer:currentPieLayer];
        }
    }
    
    [self maskChart];
    
    
    [self addAnimationIfNeeded];
}

- (void)updateChartData:(NSArray *)items {
    self.items = items;
}

- (PieChartDataItem *)dataItemForIndex:(NSUInteger)index{
    return self.items[index];
}

- (CGFloat)startPercentageForItemAtIndex:(NSUInteger)index{
    if(index == 0){
        return 0;
    }
    
    return [_endPercentages[index - 1] floatValue];
}

- (CGFloat)endPercentageForItemAtIndex:(NSUInteger)index{
    return [_endPercentages[index] floatValue];
}

- (CGFloat)ratioForItemAtIndex:(NSUInteger)index{
    return [self endPercentageForItemAtIndex:index] - [self startPercentageForItemAtIndex:index];
}

#pragma mark private methods

- (CAShapeLayer *)newCircleLayerWithRadius:(CGFloat)radius
                               borderWidth:(CGFloat)borderWidth
                                 fillColor:(UIColor *)fillColor
                               borderColor:(UIColor *)borderColor
                           startPercentage:(CGFloat)startPercentage
                             endPercentage:(CGFloat)endPercentage{
    CAShapeLayer *circle = [CAShapeLayer layer];
    
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds),CGRectGetMidY(self.bounds));
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center
                                                        radius:radius
                                                    startAngle:-M_PI_2
                                                      endAngle:M_PI_2 * 3
                                                     clockwise:YES];
    
    circle.fillColor   = fillColor.CGColor;
    circle.strokeColor = borderColor.CGColor;
    circle.strokeStart = startPercentage;
    circle.strokeEnd   = endPercentage;
    circle.lineWidth   = borderWidth;
    circle.path        = path.CGPath;
    
    return circle;
}

- (void)maskChart{
    CGFloat radius = _innerCircleRadius + (_outerCircleRadius - _innerCircleRadius) / 2;
    CGFloat borderWidth = _outerCircleRadius - _innerCircleRadius;
    CAShapeLayer *maskLayer = [self newCircleLayerWithRadius:radius
                                                 borderWidth:borderWidth
                                                   fillColor:[UIColor clearColor]
                                                 borderColor:[UIColor blackColor]
                                             startPercentage:0
                                               endPercentage:1];
    
    _pieLayer.mask = maskLayer;
}

- (void)addAnimationIfNeeded{
    if (self.displayAnimated) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation.duration  = _duration;
        animation.fromValue = @0;
        animation.toValue   = @1;
        animation.delegate  = self;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.removedOnCompletion = YES;
        [_pieLayer.mask addAnimation:animation forKey:@"circleAnimation"];
    }
    else {
        
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
}

@end
