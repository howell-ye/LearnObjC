//
//  LCLineChartView.m
//
//
//  Created by Marcel Ruegenberg on 02.08.13.
//
//

#import "ESLineChartView.h"
#import "ESLineChartInfoView.h"
#import "UIView+es_add.h"

@interface ESLineChartDataItem ()

@property (readwrite) double x; // should be within the x range
@property (readwrite) double y; // should be within the y range
@property (readwrite) NSString *xLabel; // label to be shown on the x axis
@property (readwrite) NSString *dataLabel; // label to be shown directly at the data item

- (id)initWithhX:(double)x y:(double)y xLabel:(NSString *)xLabel dataLabel:(NSString *)dataLabel;

@end

@implementation ESLineChartDataItem

- (id)initWithhX:(double)x y:(double)y xLabel:(NSString *)xLabel dataLabel:(NSString *)dataLabel {
    if((self = [super init])) {
        self.x = x;
        self.y = y;
        self.xLabel = xLabel;
        self.dataLabel = dataLabel;
    }
    return self;
}

+ (ESLineChartDataItem *)dataItemWithX:(double)x y:(double)y xLabel:(NSString *)xLabel dataLabel:(NSString *)dataLabel {
    return [[ESLineChartDataItem alloc] initWithhX:x y:y xLabel:xLabel dataLabel:dataLabel];
}

@end



@implementation ESLineChartData

- (id)init {
  self = [super init];
  if(self) {
    self.drawsDataPoints = YES;
  }
  return self;
}

@end



@interface ESLineChartView ()

@property ESLineChartInfoView *infoView;
@property UIView *currentPosView;

- (BOOL)drawsAnyData;

@property ESLineChartData *selectedData;
@property NSUInteger selectedIdx;

@end


#define X_AXIS_SPACE 15
#define PADDING 10


@implementation ESLineChartView
@synthesize data=_data;

- (void)setDefaultValues {
    self.currentPosView = [[UIView alloc] initWithFrame:CGRectMake(PADDING, PADDING, 1 / self.contentScaleFactor, 50)];
    self.currentPosView.backgroundColor = [UIColor colorWithRed:0.7 green:0.0 blue:0.0 alpha:1.0];
    self.currentPosView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.currentPosView.alpha = 0.0;
    [self addSubview:self.currentPosView];

    self.axisLabelColor = [UIColor grayColor];

    self.backgroundColor = [UIColor whiteColor];
    self.scaleFont = [UIFont systemFontOfSize:10.0];

    self.autoresizesSubviews = YES;
    self.contentMode = UIViewContentModeRedraw;

    self.drawsDataPoints = YES;
    self.drawsDataLines  = YES;
    
    self.selectedIdx = INT_MAX;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if((self = [super initWithCoder:aDecoder])) {
        [self setDefaultValues];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if((self = [super initWithFrame:frame])) {
        [self setDefaultValues];
    }
    return self;
}

- (void)setAxisLabelColor:(UIColor *)axisLabelColor {
    if(axisLabelColor != _axisLabelColor) {
        [self willChangeValueForKey:@"axisLabelColor"];
        _axisLabelColor = axisLabelColor;
        [self didChangeValueForKey:@"axisLabelColor"];
    }
}

- (void)layoutSubviews {
    CGRect r = self.currentPosView.frame;
    CGFloat h = self.bounds.size.height;
    r.size.height = h - 2 * PADDING - X_AXIS_SPACE;
    self.currentPosView.frame = r;
}

- (void)setData:(NSArray *)data {
    if(data != _data) {
        NSMutableArray *titles = [NSMutableArray arrayWithCapacity:[data count]];
        NSMutableDictionary *colors = [NSMutableDictionary dictionaryWithCapacity:[data count]];
        for(ESLineChartData *dat in data) {
            NSString *key = dat.title;
            if(key == nil) key = @"";
            [titles addObject:key];
            [colors setObject:dat.color forKey:key];
        }

        self.selectedData = nil;
        self.selectedIdx = INT_MAX;

        _data = data;

        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    CGContextRef c = UIGraphicsGetCurrentContext();

    CGFloat availableHeight = self.bounds.size.height - 2 * PADDING - X_AXIS_SPACE;

    CGFloat availableWidth = self.bounds.size.width - 2 * PADDING - self.yAxisLabelsWidth;
    CGFloat xStart = PADDING + self.yAxisLabelsWidth;
    CGFloat yStart = PADDING;

    static CGFloat dashedPattern[] = {4,2};

    // draw scale and horizontal lines
    CGFloat heightPerStep = self.ySteps == nil || [self.ySteps count] <= 1 ? availableHeight : (availableHeight / ([self.ySteps count] - 1));

    NSUInteger i = 0;
    CGContextSaveGState(c);
    CGContextSetLineWidth(c, 1.0);
    NSUInteger yCnt = [self.ySteps count];
    for(NSString *step in self.ySteps) {
        [self.axisLabelColor set];
        CGFloat h = [self.scaleFont lineHeight];
        CGFloat y = yStart + heightPerStep * (yCnt - 1 - i);
        // TODO: replace with new text APIs in iOS 7 only version
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [step drawInRect:CGRectMake(yStart, y - h / 2, self.yAxisLabelsWidth - 6, h) withFont:self.scaleFont lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];
#pragma clagn diagnostic pop

        [[UIColor colorWithWhite:0.9 alpha:1.0] set];
        CGContextSetLineDash(c, 0, dashedPattern, 2);
        CGContextMoveToPoint(c, xStart, round(y) + 0.5);
        CGContextAddLineToPoint(c, self.bounds.size.width - PADDING, round(y) + 0.5);
        CGContextStrokePath(c);

        i++;
    }

    NSUInteger xCnt = self.xSteps.count;
    if(xCnt > 1) {
        CGFloat widthPerStep = availableWidth / (xCnt - 1);
        
        for(NSUInteger i = 0; i < xCnt; ++i) {
            CGFloat x = xStart + widthPerStep * (xCnt - 1 - i);
            if (i>0) {
                [self.axisLabelColor set];
                CGFloat h = [self.scaleFont lineHeight];
                NSString *string = self.xSteps[i];
                [string drawInRect:CGRectMake(x - widthPerStep/2, self.height - h, widthPerStep, h) withFont:self.scaleFont lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentRight];
            }
            [[UIColor grayColor] set];
            [[UIColor colorWithWhite:0.9 alpha:1.0] set];
            CGContextMoveToPoint(c, round(x) + 0.5, PADDING);
            CGContextAddLineToPoint(c, round(x) + 0.5, yStart + availableHeight);
            CGContextStrokePath(c);
        }
    }

    CGContextRestoreGState(c);


    if (!self.drawsAnyData) {
        NSLog(@"You configured LineChartView to draw neither lines nor data points. No data will be visible. This is most likely not what you wanted. (But we aren't judging you, so here's your chart background.)");
    } // warn if no data will be drawn

    CGFloat yRangeLen = self.yMax - self.yMin;
    if(yRangeLen == 0) yRangeLen = 1;
    for(ESLineChartData *data in self.data) {
        if (self.drawsDataLines) {
            double xRangeLen = data.xMax - data.xMin;
            if(xRangeLen == 0) xRangeLen = 1;
            if(data.itemCount >= 2) {
                ESLineChartDataItem *datItem = data.getData(0);
                CGMutablePathRef path = CGPathCreateMutable();
                CGFloat prevX = xStart + round(((datItem.x - data.xMin) / xRangeLen) * availableWidth);
                CGFloat prevY = yStart + round((1.0 - (datItem.y - self.yMin) / yRangeLen) * availableHeight);
                CGPathMoveToPoint(path, NULL, prevX, prevY);
                for(NSUInteger i = 1; i < data.itemCount; ++i) {
                    ESLineChartDataItem *datItem = data.getData(i);
                    CGFloat x = xStart + round(((datItem.x - data.xMin) / xRangeLen) * availableWidth);
                    CGFloat y = yStart + round((1.0 - (datItem.y - self.yMin) / yRangeLen) * availableHeight);
                    CGFloat xDiff = x - prevX;
                    CGFloat yDiff = y - prevY;

                    if(xDiff != 0) {
                        CGFloat xSmoothing = self.smoothPlot ? MIN(30,xDiff) : 0;
                        CGFloat ySmoothing = 0.5;
                        CGFloat slope = yDiff / xDiff;
                        CGPoint controlPt1 = CGPointMake(prevX + xSmoothing, prevY + ySmoothing * slope * xSmoothing);
                        CGPoint controlPt2 = CGPointMake(x - xSmoothing, y - ySmoothing * slope * xSmoothing);
                        CGPathAddCurveToPoint(path, NULL, controlPt1.x, controlPt1.y, controlPt2.x, controlPt2.y, x, y);
                    }
                    else {
                        CGPathAddLineToPoint(path, NULL, x, y);
                    }
                    prevX = x;
                    prevY = y;
                }

                CGContextAddPath(c, path);
                CGContextSetStrokeColorWithColor(c, [self.backgroundColor CGColor]);
                CGContextSetLineWidth(c, 5);
                CGContextStrokePath(c);

                CGContextAddPath(c, path);
                CGContextSetStrokeColorWithColor(c, [data.color CGColor]);
                CGContextSetLineWidth(c, 2);
                CGContextStrokePath(c);

                CGPathRelease(path);
            }
        } // draw actual chart data
        if (self.drawsDataPoints) {
          if (data.drawsDataPoints) {
            double xRangeLen = data.xMax - data.xMin;
            if(xRangeLen == 0) xRangeLen = 1;
            for(NSUInteger i = 0; i < data.itemCount; ++i) {
                ESLineChartDataItem *datItem = data.getData(i);
                CGFloat xVal = xStart + round((xRangeLen == 0 ? 0.5 : ((datItem.x - data.xMin) / xRangeLen)) * availableWidth);
                CGFloat yVal = yStart + round((1.0 - (datItem.y - self.yMin) / yRangeLen) * availableHeight);
                [self.backgroundColor setFill];
                CGContextFillEllipseInRect(c, CGRectMake(xVal - 5.5, yVal - 5.5, 11, 11));
                [data.color setFill];
                CGContextFillEllipseInRect(c, CGRectMake(xVal - 4, yVal - 4, 8, 8));
                {
                    CGFloat brightness;
                    CGFloat r,g,b,a;
                    if(CGColorGetNumberOfComponents([data.color CGColor]) < 3)
                        [data.color getWhite:&brightness alpha:&a];
                    else {
                        [data.color getRed:&r green:&g blue:&b alpha:&a];
                        brightness = 0.299 * r + 0.587 * g + 0.114 * b; // RGB ~> Luma conversion
                    }
                    if(brightness <= 0.68) // basically arbitrary, but works well for test cases
                        [[UIColor whiteColor] setFill];
                    else
                        [[UIColor blackColor] setFill];
                }
                CGContextFillEllipseInRect(c, CGRectMake(xVal - 2, yVal - 2, 4, 4));
            } // for
          } // data - draw data points
        } // draw data points
    }
}

- (void)showIndicatorForTouch:(UITouch *)touch {
    if(! self.infoView) {
        self.infoView = [[ESLineChartInfoView alloc] init];
        [self addSubview:self.infoView];
    }

    CGPoint pos = [touch locationInView:self];
    CGFloat xStart = PADDING + self.yAxisLabelsWidth;
    CGFloat yStart = PADDING;
    CGFloat yRangeLen = self.yMax - self.yMin;
    if(yRangeLen == 0) yRangeLen = 1;
    CGFloat xPos = pos.x - xStart;
    CGFloat yPos = pos.y - yStart;
    CGFloat availableWidth = self.bounds.size.width - 2 * PADDING - self.yAxisLabelsWidth;
    CGFloat availableHeight = self.bounds.size.height - 2 * PADDING - X_AXIS_SPACE;

    ESLineChartDataItem *closest = nil;
    ESLineChartData *closestData = nil;
    NSUInteger closestIdx = INT_MAX;
    double minDist = DBL_MAX;
    double minDistY = DBL_MAX;
    CGPoint closestPos = CGPointZero;

    for(ESLineChartData *data in self.data) {
        double xRangeLen = data.xMax - data.xMin;
        
        // note: if necessary, could use binary search here to speed things up
        for(NSUInteger i = 0; i < data.itemCount; ++i) {
            ESLineChartDataItem *datItem = data.getData(i);
            CGFloat xVal = round((xRangeLen == 0 ? 0.0 : ((datItem.x - data.xMin) / xRangeLen)) * availableWidth);
            CGFloat yVal = round((1.0 - (datItem.y - self.yMin) / yRangeLen) * availableHeight);

            double dist = fabs(xVal - xPos);
            double distY = fabs(yVal - yPos);
            if(dist < minDist || (dist == minDist && distY < minDistY)) {
                minDist = dist;
                minDistY = distY;
                closest = datItem;
                closestData = data;
                closestIdx = i;
                closestPos = CGPointMake(xStart + xVal - 3, yStart + yVal - 7);
            }
        }
    }
    
    if(closest == nil || (closestData == self.selectedData && closestIdx == self.selectedIdx))
        return;
    
    self.selectedData = closestData;
    self.selectedIdx = closestIdx;
    
    self.infoView.infoLabel.text = closest.dataLabel;
    self.infoView.tapPoint = closestPos;
    [self.infoView sizeToFit];
    [self.infoView setNeedsLayout];
    [self.infoView setNeedsDisplay];

    if(self.currentPosView.alpha == 0.0) {
        CGRect r = self.currentPosView.frame;
        r.origin.x = closestPos.x + 3 - 1;
        self.currentPosView.frame = r;
    }

    [UIView animateWithDuration:0.1 animations:^{
        self.infoView.alpha = 1.0;
        self.currentPosView.alpha = 1.0;
//        self.xAxisLabel.alpha = 1.0;

        CGRect r = self.currentPosView.frame;
        r.origin.x = closestPos.x + 3 - 1;
        self.currentPosView.frame = r;
    }];
    
    if(self.selectedItemCallback != nil) {
        self.selectedItemCallback(closestData, closestIdx, closestPos);
    }
}

- (void)hideIndicator {
    if(self.deselectedItemCallback)
        self.deselectedItemCallback();
    
    self.selectedData = nil;
    
    [UIView animateWithDuration:0.1 animations:^{
        self.infoView.alpha = 0.0;
        self.currentPosView.alpha = 0.0;
//        self.xAxisLabel.alpha = 0.0;
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self showIndicatorForTouch:[touches anyObject]];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self showIndicatorForTouch:[touches anyObject]];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self hideIndicator];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self hideIndicator];
}


#pragma mark Helper methods

- (BOOL)drawsAnyData {
    return self.drawsDataPoints || self.drawsDataLines;
}

// TODO: This should really be a cached value. Invalidated iff ySteps changes.
- (CGFloat)yAxisLabelsWidth {
    double maxV = 0;
    for(NSString *label in self.ySteps) {
        CGSize labelSize = [label sizeWithFont:self.scaleFont];
        if(labelSize.width > maxV) maxV = labelSize.width;
    }
    return maxV + PADDING;
}



@end
