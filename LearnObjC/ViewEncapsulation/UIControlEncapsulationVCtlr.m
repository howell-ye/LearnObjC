//
//  UIControlEncapsulationVCtlr.m
//  LearnObjC
//
//  Created by eshore on 2017/7/28.
//  Copyright © 2017年 howell. All rights reserved.
//

#import "UIControlEncapsulationVCtlr.h"

@interface UIControlEncapsulationVCtlr ()

@property (nonatomic, strong)UILabel *label;

@end

@implementation UIControlEncapsulationVCtlr

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 150, 30)];
    _label.font = [UIFont systemFontOfSize:15];
    _label.textColor = [UIColor purpleColor];
    _label.text = @"呵呵呵呵呵呵";
    [self.view addSubview:_label];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)ESScroll_viewDidLoadForIndex:(NSInteger)index
{

}

@end
