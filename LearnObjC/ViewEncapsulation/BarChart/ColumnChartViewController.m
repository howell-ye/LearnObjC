//
//  ColumnChartViewController.m
//  LearnObjC
//
//  Created by eshore on 2017/8/7.
//  Copyright © 2017年 howell. All rights reserved.
//

#import "ColumnChartViewController.h"
#import "ESColumnChartView.h"

@interface ColumnChartViewController ()<ESColumnChartViewDelegate>

@end

@implementation ColumnChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self showColumnChart];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showColumnChart
{
    ESColumnChartView *column = [[ESColumnChartView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 320)];
    column.valueArr = @[
                        @[@12],
                        @[@22],
                        @[@1],
                        @[@21],
                        @[@19],
                        @[@12],
                        @[@15],
                        @[@9],
                        @[@8],
                        @[@6],
                        @[@9],
                        @[@18],
                        @[@23],
                        ];
    column.originSize = CGPointMake(30, 20);
    column.drawFromOriginX = 20;
    column.typeSpace = 10;
    column.columnWidth = 30;
    column.bgVewBackgoundColor = [UIColor whiteColor];
    column.dashColor = [UIColor lightGrayColor];
    column.drawTextColorForX_Y = [UIColor darkGrayColor];
    column.colorForXYLine = [UIColor blackColor];
//    column.needXandYLine = NO;
    column.columnBGcolorsArr = @[[UIColor colorWithRed:72/256.0 green:200.0/256 blue:255.0/256 alpha:1],[UIColor greenColor],[UIColor orangeColor]];
    column.xShowInfoText = @[@"A班级",@"B班级",@"C班级",@"D班级",@"E班级",@"F班级",@"G班级",@"H班级",@"i班级",@"J班级",@"L班级",@"M班级",@"N班级"];
    
    column.delegate = self;
    [column showAnimation];
    [self.view addSubview:column];
}

- (void)columnItem:(UIView *)item didClickAtIndexRow:(NSIndexPath *)indexPath{
    NSLog(@"%@",indexPath);
}


@end
