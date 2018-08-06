//
//  ESCarouselStyle.m
//  EShoreAppLib
//
//  Created by eshore on 2017/8/2.
//  Copyright © 2017年 EShore. All rights reserved.
//

#import "ESCarouselStyle.h"

@implementation ESCarouselStyle

- (instancetype)init {
    if(self = [super init]) {
        _carouselBGColor = [UIColor grayColor];
        _autoScrollTimeInterval = 3.0;
        _titleLabelTextColor = [UIColor whiteColor];
        _titleLabelTextFont= [UIFont systemFontOfSize:14];
        _titleLabelBackgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        _titleLabelTextAlignment = NSTextAlignmentLeft;
        _autoScroll = YES;
        _infiniteLoop = YES;
        _showPageControl = YES;
        _pageControlAliment = ESCarouselViewPageContolAlimentRight;
        _currentPageDotColor = [UIColor whiteColor];
        _pageDotColor = [UIColor lightGrayColor];
        _pageDotNumber = -1;
    }
    return self;
}

@end
