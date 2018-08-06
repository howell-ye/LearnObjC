//
//  UIComponentEncapsulationVCtlr.m
//  LearnObjC
//
//  Created by eshore on 2017/7/28.
//  Copyright © 2017年 howell. All rights reserved.
//

#import "UIComponentEncapsulationVCtlr.h"
#import "ESScrollPageViewVCtlr.h"
#import "ESCarouselView.h"
#import "UIView+es_add.h"
#import "ChartViewController.h"
#import "ColumnChartViewController.h"

@interface UIComponentEncapsulationVCtlr ()<ESCarouselViewDelegate>

@end

@implementation UIComponentEncapsulationVCtlr

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"大部件封装";
    self.view.backgroundColor = [UIColor whiteColor];
    [self initControl];
    
    [self initCarouselView];
}

- (void)initCarouselView
{
    NSArray *imageArray = @[
                            @"http://113.108.186.148:2001/resource/ad/ad_1488159578340.jpg",
                            @"http://113.108.186.148:2001/resource/ad/ad_1488159543849.jpg",
                            @"http://113.108.186.148:2001/resource/ad/ad_1488159504700.jpg",
                            @"http://113.108.186.148:2001/resource/ad/ad_1488159457713.jpg",
                            @"http://113.108.186.148:2001/resource/ad/ad_1488159305791.jpg",
                            ];
    
    NSArray *titleArray = @[
                            @"长得有点抱歉",
                            @"嘴又不是特别甜",
                            @"追女孩从来没成功过",
                            @"说老天不公",
                            @"凭啥把他生的这么丑",
                            ];
    
    ESCarouselStyle *style = [[ESCarouselStyle alloc] init];
    style.autoScroll = NO;
    style.infiniteLoop = NO;
    style.autoScrollTimeInterval = 1.0;
    style.pageDotNumber = 3;
    style.titleLabelTextFont = [UIFont systemFontOfSize:18];
    style.titleLabelTextColor = [UIColor blueColor];
    style.titleLabelTextAlignment = NSTextAlignmentCenter;
    style.titleLabelBackgroundColor = [UIColor whiteColor];
    style.pageControlAliment = ESCarouselViewPageContolAlimentCenter;
    style.currentPageDotColor = [UIColor redColor];
    style.pageDotColor = [UIColor yellowColor];
    
    ESCarouselView *carousel = [[ESCarouselView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 150) carouselStyle:style delegate:self imageURLStringsArray:imageArray titlesArray:titleArray placeholderImage:nil];
    [self.view addSubview:carousel];
}

- (void)initControl
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(self.view.width / 2 - 40, 250, 80, 40);
    button.backgroundColor = [UIColor colorWithRed:72/255.0 green:209/255.0 blue:204/255.0 alpha:1.0];
    [button  setTitle:@"横向菜单" forState:UIControlStateNormal];
    [button  setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showScrollPageView) forControlEvents:UIControlEventTouchUpInside];
    [self.view  addSubview:button];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(self.view.width / 2 - 40, 320, 80, 40);
    button1.backgroundColor = [UIColor colorWithRed:72/255.0 green:209/255.0 blue:204/255.0 alpha:1.0];
    [button1  setTitle:@"折线图" forState:UIControlStateNormal];
    [button1  setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(showLineChart) forControlEvents:UIControlEventTouchUpInside];
    [self.view  addSubview:button1];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(self.view.width / 2 - 40, 390, 80, 40);
    button2.backgroundColor = [UIColor colorWithRed:72/255.0 green:209/255.0 blue:204/255.0 alpha:1.0];
    [button2  setTitle:@"柱状图" forState:UIControlStateNormal];
    [button2  setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(showColumnChart) forControlEvents:UIControlEventTouchUpInside];
    [self.view  addSubview:button2];
}

- (void)showScrollPageView
{
    ESScrollPageViewVCtlr *vc = [[ESScrollPageViewVCtlr alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showLineChart
{
    ChartViewController *vc = [[ChartViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showColumnChart
{
    ColumnChartViewController *vc = [[ColumnChartViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)carouselView:(ESCarouselView *)carouselView didScrollToIndex:(NSInteger)index
{
    NSLog(@"didScrollToIndex:%ld",index);
}



@end
