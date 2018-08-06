//
//  PieChartViewController.m
//  chartsDemo
//
//  Created by eshore on 2017/3/7.
//  Copyright © 2017年 HWY. All rights reserved.
//

#import "PieChartViewController.h"
#import "PieChartView.h"
#import "PieChartDataItem.h"

@interface PieChartViewController ()

@property (nonatomic, strong)PieChartView *pieChart;

@end

@implementation PieChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"PieChart";
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self initPieChartView];
}

- (void)initPieChartView
{
    NSArray *items = @[
                       [PieChartDataItem dataItemWithValue:27 color:[UIColor brownColor]],
                       [PieChartDataItem dataItemWithValue:18 color:[UIColor redColor]],
                       [PieChartDataItem dataItemWithValue:15 color:[UIColor purpleColor]],
                       [PieChartDataItem dataItemWithValue:30 color:[UIColor grayColor]],
                       [PieChartDataItem dataItemWithValue:20 color:[UIColor yellowColor]],
                       ];
    /*
     [PieChartDataItem dataItemWithValue:27 color:[UIColor brownColor]],
     [PieChartDataItem dataItemWithValue:18 color:[UIColor redColor]],
     [PieChartDataItem dataItemWithValue:15 color:[UIColor purpleColor]],
     [PieChartDataItem dataItemWithValue:30 color:[UIColor grayColor]],
     [PieChartDataItem dataItemWithValue:20 color:[UIColor yellowColor]],
     */
    
    self.pieChart = [[PieChartView alloc] initWithFrame:CGRectMake((CGFloat) ([UIScreen mainScreen].bounds.size.width / 2.0 - 100), 135, 200, 200) items:items];
    self.pieChart.radiusRatio = 0.4;
    self.pieChart.displayAnimated = YES;
    self.pieChart.showinterval = YES;
    [self.view addSubview:self.pieChart];
    [self.pieChart strokeChart];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
