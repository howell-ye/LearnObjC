//
//  TestView.m
//  LearnObjC
//
//  Created by yehowell on 2018/3/25.
//  Copyright © 2018年 howell. All rights reserved.
//

#import "TestView.h"

@interface TestView()

@property (nonatomic, strong)UIButton *button;
@property (nonatomic, strong)UIButton *button1;
@property (nonatomic, strong)UIView *littleView;

@end

@implementation TestView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self= [super initWithFrame:frame]) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI
{
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.backgroundColor = [UIColor greenColor];
    [_button setTintColor:[UIColor whiteColor]];
    [_button setTitle:@"测试" forState:UIControlStateNormal];
    _button.tag = 1001;
    [self addSubview:_button];

    _button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    _button1.backgroundColor = [UIColor blueColor];
    [_button1 setTintColor:[UIColor whiteColor]];
    [_button1 setTitle:@"测试" forState:UIControlStateNormal];
    _button1.tag = 1002;
    [self addSubview:_button1];
    
    _littleView = [[UIView alloc] init];
    _littleView.backgroundColor = [UIColor purpleColor];
    [self addSubview:_littleView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _button.frame = CGRectMake(self.frame.size.width/2 - 50, self.frame.size.height/2 - 30, 100, 60);
    _button1.frame = CGRectMake(self.frame.size.width/2 - 25, self.frame.size.height/2 - 15, 50, 30);
    _littleView.frame =CGRectMake(10, 10, 10, 10);
}

//- (void)drawRect:(CGRect)rect
//{
//    NSLog(@"+++");
//}



@end
