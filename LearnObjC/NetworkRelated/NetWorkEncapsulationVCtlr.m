//
//  NetWorkEncapsulationVCtlr.m
//  LearnObjC
//
//  Created by yehowell on 2017/7/18.
//  Copyright © 2017年 howell. All rights reserved.
//

#import "NetWorkEncapsulationVCtlr.h"
#import "NetworkCenter.h"

@interface NetWorkEncapsulationVCtlr ()

@end

@implementation NetWorkEncapsulationVCtlr

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    NSString *path = @"https://gykd.10000.gd.cn:8443/ctbapi/elechannel/getPackageInfo";
    NSDictionary *param = @{
                            @"areacode" : @"200",
                            @"mobile" : @"13310888074",
                            @"token" : @"37637:1100240366149:13310888074:1500967597846:4JCDsJi5ruCFK0Kkpm97tg==",
                            @"type" : @"1,2,3"
                            };
    [[NetworkCenter sharedInstance] postWithPath:path parameters:param success:^(NSURLSessionTask *task, id responseObject) {
        
    } failure:^(NSURLSessionTask *task, NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
