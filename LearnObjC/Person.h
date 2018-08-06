//
//  Person.h
//  LearnObjC
//
//  Created by yehowell on 2018/3/22.
//  Copyright © 2018年 howell. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Student;
@interface Person : NSObject

- (void)print;

@property (nonatomic, strong)NSString *hahaha;

@property (nonatomic, strong)Student *student;

@property (nonatomic, copy) void (^blockName)();

@end
