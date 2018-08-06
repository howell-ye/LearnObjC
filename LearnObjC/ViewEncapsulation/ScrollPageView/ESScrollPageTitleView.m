//
//  ESScrollPageTitleView.m
//  LearnObjC
//
//  Created by eshore on 2017/7/28.
//  Copyright © 2017年 howell. All rights reserved.
//

#import "ESScrollPageTitleView.h"

@interface ESScrollPageTitleView(){
    CGSize _titleSize;
}

@property (strong, nonatomic) UILabel *label;

@end

@implementation ESScrollPageTitleView

- (instancetype)init {
    self = [self initWithFrame:CGRectZero];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.label];
        
    }
    
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    self.label.frame = self.bounds;
}



- (CGFloat)titleViewWidth {
    return _titleSize.width;
}


- (void)setFont:(UIFont *)font {
    _font = font;
    self.label.font = font;
}

- (void)setText:(NSString *)text {
    _text = text;
    self.label.text = text;
    CGRect bounds = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, 0.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.sizeFont} context:nil];
    _titleSize = bounds.size;
}


- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    self.label.textColor = textColor;
    
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
}


- (UILabel *)label {
    if (_label == nil) {
        _label = [[UILabel alloc] init];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor blueColor];
    }
    return _label;
}

@end
