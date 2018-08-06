//
//  ESScrollPageTitleView.h
//  LearnObjC
//
//  Created by eshore on 2017/7/28.
//  Copyright © 2017年 howell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESScrollPageStyle.h"

@interface ESScrollPageTitleView : UIView

@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) UIColor *textColor;
@property (strong, nonatomic) UIFont *font;
@property (strong, nonatomic) UIFont *sizeFont;
@property (assign, nonatomic, getter=isSelected) BOOL selected;

@property (strong, nonatomic, readonly) UILabel *label;

- (CGFloat)titleViewWidth;

@end
