//
//  ESScrollPageViewVCtlrViewController.m
//  LearnObjC
//
//  Created by eshore on 2017/7/28.
//  Copyright © 2017年 howell. All rights reserved.
//

#import "ESScrollPageViewVCtlr.h"
//#import "ESScrollPageStyle.h"
//#import "ESScrollPageView.h"
//#import "ESScrollPageTitleView.h"
#import "ESScrollPageView.h"
#import "UIControlEncapsulationVCtlr.h"

@interface ESScrollPageViewVCtlr ()<ESScrollPageViewDelegate>

@property(strong, nonatomic)NSArray<NSString *> *titles;

@end

@implementation ESScrollPageViewVCtlr

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"ScrollPageView";
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNewControl];
}

- (void)initNewControl
{
    self.title = @"效果示例";
    //必要的设置, 如果没有设置可能导致内容显示不正常
    self.automaticallyAdjustsScrollViewInsets = NO;
    ESScrollPageStyle *style = [[ESScrollPageStyle alloc] init];
    self.titles = @[@"新闻头条",
                    @"国际要闻",
                    @"体育",
                    @"中国足球",
                    @"汽车",
                    @"囧途旅游",
                    @"幽默搞笑",
                    @"视频",
                    @"无厘头",
                    @"美女图片",
                    @"今日房价",
                    @"头像",
                    ];
    // 初始化
    ESScrollPageView *scrollPageView = [[ESScrollPageView alloc] initWithFrame:CGRectMake(0, 64.0, self.view.bounds.size.width, self.view.bounds.size.height - 64.0) scrollPageStyle:style titles:self.titles parentViewController:self delegate:self];
    // 这里可以设置头部视图的属性(背景色, 圆角, 背景图片...)
    //    scrollPageView.barView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:scrollPageView];
}

#pragma ZJScrollPageViewDelegate 代理方法
- (NSInteger)numberOfChildViewControllers {
    return self.titles.count;
}

- (UIViewController<ESScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ESScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    UIViewController<ESScrollPageViewChildVcDelegate> *childVc = reuseViewController;
    //    NSLog(@"%ld---------", index);
    
    if (!childVc) {
        UIControlEncapsulationVCtlr *vc = [[UIControlEncapsulationVCtlr alloc] init];
        childVc = vc;
        
    }
    
    return childVc;
}


- (void)scrollPageController:(UIViewController *)scrollPageController childViewControllWillAppear:(UIViewController *)childViewController forIndex:(NSInteger)index {
    NSLog(@"%ld ---将要出现",index);
}

- (void)scrollPageController:(UIViewController *)scrollPageController childViewControllDidAppear:(UIViewController *)childViewController forIndex:(NSInteger)index {
    NSLog(@"%ld ---已经出现",index);
}

- (void)scrollPageController:(UIViewController *)scrollPageController childViewControllWillDisappear:(UIViewController *)childViewController forIndex:(NSInteger)index {
    NSLog(@"%ld ---将要消失",index);
    
}


- (void)scrollPageController:(UIViewController *)scrollPageController childViewControllDidDisappear:(UIViewController *)childViewController forIndex:(NSInteger)index {
    NSLog(@"%ld ---已经消失",index);
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
