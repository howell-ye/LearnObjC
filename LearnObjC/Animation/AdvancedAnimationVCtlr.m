//
//  AdvancedAnimationVCtlr.m
//  LearnObjC
//
//  Created by yehowell on 2017/7/18.
//  Copyright © 2017年 howell. All rights reserved.
//

#import "AdvancedAnimationVCtlr.h"
#import "TestView.h"
#import "Person.h"
#import "Student.h"



@interface AdvancedAnimationVCtlr ()

@property (nonatomic, strong)CALayer *testLayer;
@property (nonatomic, strong)TestView *testView;

//@property (nonatomic, strong)Person *person;
//@property (nonatomic, copy) void (^blockName)();

@end

@implementation AdvancedAnimationVCtlr

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
//    [self.view addGestureRecognizer:tap];
//
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 50, 200, 100, 60);
    button.backgroundColor = [UIColor orangeColor];
    [button setTintColor:[UIColor whiteColor]];
    [button setTitle:@"测试" forState:UIControlStateNormal];
    button.tag = 1001;
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
//
//    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
//    button1.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 25, 165, 50, 30);
//    button1.backgroundColor = [UIColor blueColor];
//    [button1 setTintColor:[UIColor whiteColor]];
//    [button1 setTitle:@"测试" forState:UIControlStateNormal];
//    button1.tag = 1002;
//    [button1 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button1];
//
//    _testLayer = [[CALayer alloc] init];
//    _testLayer.frame = CGRectMake(20, 100, 50, 50);
//    _testLayer.backgroundColor = [UIColor orangeColor].CGColor;
//    [self.view.layer addSublayer:_testLayer];
    
//    _testView = [[TestView alloc] initWithFrame:CGRectMake(20, 20, 300, 150)];
//    [self.view addSubview:_testView];
//
//    _blockName = ^(){
//        [self blockTest];
//    };
}

- (void)tapAction
{
    NSLog(@"self.view");
    self.view.userInteractionEnabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)buttonAction:(UIButton *)sender
{
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.y"];
//    animation.duration  = 2.0;
//    animation.fromValue = @100;
//    animation.toValue   = @400;
//    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    animation.removedOnCompletion = NO;
//    animation.fillMode = kCAFillModeForwards;
//    [_testLayer addAnimation:animation forKey:@"testAnimation"];
    
//    [self.delegate justTestSysnState];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationTestTest" object:nil];
//    });
//    NSLog(@"postNotification");
//    _testView.frame = CGRectMake(80, 80, 200, 100);
//    [_testView layoutIfNeeded];
    
    Person *person = [[Person alloc] init];
//    _person.blockName = ^(){
//        [self blockTest];
//    };
    Student *student = [[Student alloc] init];
    person.student = student;
    student.person = person;
    
//    int aaa[] = {1,2,3,4};
//    int abc = *(aaa+1);
//    NSLog(@"&&&&--%d",abc);
    
//    [self blockName];
    
//    sleep(4.8);
//    NSLog(@"&*&*&*&");
}

- (void)blockTest
{
    NSLog(@"+++++++++");
}

- (void)dealloc
{
    NSLog(@"dealloc AdvancedAnimationVCtlr");
}

@end
