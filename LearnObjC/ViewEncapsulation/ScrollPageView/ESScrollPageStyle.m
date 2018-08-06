//
//  ESScrollPageStyle.m
//  LearnObjC
//
//  Created by eshore on 2017/7/28.
//  Copyright © 2017年 howell. All rights reserved.
//

#import "ESScrollPageStyle.h"

@implementation ESScrollPageStyle

- (instancetype)init {
    if(self = [super init]) {
        _scrollBarBGColor = [UIColor whiteColor];
        _scrollBarHeight = 40;
        _scrollTitle = YES;
        _scrollEnabled = YES;
        _unSelectedFont = [UIFont systemFontOfSize:14.0];
        _selectedFont = [UIFont systemFontOfSize:15.0];
        _unSelectedColor = [UIColor blackColor];
        _selectedColor = [UIColor redColor];
        _scrollTitle = YES;
        _titleMargin = 15.0;
    }
    return self;
}

@end
