//
//  RuntimeVCltr.m
//  LearnObjC
//
//  Created by yehowell on 2017/7/10.
//  Copyright © 2017年 howell. All rights reserved.
//

#import "RuntimeVCltr.h"
#import <objc/runtime.h>

@interface RuntimeVCltr ()

@end

@implementation RuntimeVCltr

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Runtime";
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

void SwizzleClassMethod(Class class, SEL originalSelector, SEL alternativeSelector)
{
    class = object_getClass(class);
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method alternativeMethod = class_getInstanceMethod(class, alternativeSelector);
    
    //如果返回成功，则说明被替换方法没有存在。也就是被替换的方法没有被实现,我们需要先把这个方法实现
    BOOL success = class_addMethod(class, originalSelector, method_getImplementation(alternativeMethod), method_getTypeEncoding(alternativeMethod));
    if(success) {
        //交换两个方法
        class_replaceMethod(class, alternativeSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        //添加失败，说明方法的实现已存在，直接交换
        method_exchangeImplementations(originalMethod, alternativeMethod);
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
