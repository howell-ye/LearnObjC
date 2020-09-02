//
//  ViewController.m
//  LearnObjC
//
//  Created by yehowell on 2017/3/3.
//  Copyright © 2017年 howell. All rights reserved.
//

#import "MainViewController.h"
#import "AdvancedAnimationVCtlr.h"
#import "Person.h"

@interface MainViewController ()<UITableViewDelegate,UITableViewDataSource, AdvancedAnimationVCtlrDelegate>

@property(nonatomic, strong)NSArray *dataArray;
@property(nonatomic, strong)NSDictionary *dataDict;
@property(nonatomic, strong)UITableView *tableView;

@property(nonatomic, copy)NSString *str;
@property(nonatomic, strong)Person *person;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 40, 30);
    [btn addTarget:self action:@selector(onLeftBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"测测" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    [btn setTintColor:[UIColor blueColor]];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
//    btn.titleLabel.textColor = [UIColor blueColor];
    
    UIBarButtonItem *baritem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = baritem;
    
    [self initData];
    [self initControl];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationTest) name:@"notificationTestTest" object:nil];
//    [self test];

//    NSMutableString *string1 = [[NSMutableString alloc] initWithString:@"123456"];
//    NSString *string2 = [string1 copy];
//    NSString *string3 = [string2 copy];
//
//    NSLog(@"%p-%p-%p",string1,string2,string3);
//    NSLog(@"%@-%@-%@",string1,string2,string3);
    
    _person = [[Person alloc] init];
    _person.hahaha = @"hoho";
    
    [_person addObserver:self forKeyPath:@"hahaha" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:@"testtest"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    NSLog(@"%@----%@",change[NSKeyValueChangeNewKey],change[NSKeyValueChangeOldKey]);
    sleep(3);
}

- (void)handleNotification:(NSNotification *)notification
{
    NSLog(@"current thread = %@", [NSThread currentThread]);
    
    NSLog(@"test notification");
}

- (void)notificationTest
{
    sleep(3);
    NSLog(@"call-back");
    NSLog(@"call-back");
    NSLog(@"call-back");
    for (int i = 0; i < 3; i++) {
        NSLog(@"+++++++%d",i);
    }
}

- (void)test
{
    [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(funA) userInfo:nil repeats:NO];
    [self funB];
    [self funC];
}

- (void)funA{
    NSLog(@"funA");
}
- (void)funB{
    NSLog(@"funB");
    [NSThread sleepForTimeInterval:10];
}
- (void)funC{
    NSLog(@"funC");
}

- (void)initData
{
    NSString *pathText = [[NSBundle mainBundle] pathForResource:@"keyPoint" ofType:@"plist"];
    _dataArray = [[NSArray alloc] initWithContentsOfFile:pathText];
}

- (void)initControl
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dict = [_dataArray objectAtIndex:section];
    NSArray *subArray = [dict objectForKey:@"subsection"];
    return subArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"%@",NSStringFromSelector(_cmd));
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *dict = [_dataArray objectAtIndex:indexPath.section];
    NSArray *arr = [dict objectForKey:@"subsection"];
    NSDictionary *subDict = arr[indexPath.row];
    cell.textLabel.text = subDict[@"name"];
    cell.textLabel.textColor = [UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [_dataArray objectAtIndex:indexPath.section];
    NSArray *arr = [dict objectForKey:@"subsection"];
    NSDictionary *subDict = arr[indexPath.row];
    NSString *name = subDict[@"name"];
    NSString *className = subDict[@"class"];
    NSLog(@"open controller: %@ - %@", name, className);
    if ([self isNSStringBlank:className]) {
        return;
    }
    Class pushClass = NSClassFromString(className);
    if([pushClass isSubclassOfClass:[UIViewController class]]){
        UIViewController *vc = [[pushClass alloc] init];
        vc.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
}

- (void)justTestSysnState
{
    sleep(3);
    NSLog(@"call-back");
    NSLog(@"call-back");
    NSLog(@"call-back");
    NSLog(@"call-back");
    NSLog(@"call-back");
    NSLog(@"call-back");
    NSLog(@"call-back");
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *dict = [_dataArray objectAtIndex:section];
    NSString *title = [dict objectForKey:@"classify"];
    return title;
}

- (BOOL)isNSStringBlank:(NSString *)string
{
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

- (void)onLeftBtnAction:(id)sender{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        _person.hahaha = @"hehe";
//    });
//    NSLog(@"hehehehehhe");
    
    //声明一个局部变量i
    static  int i = 0;
    //每次点击view来到这个方法时让i自增
    i ++;
    //打印结果
    NSLog(@"i=%d",i);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
