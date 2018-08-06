//
//  ESScrollPageView.m
//  LearnObjC
//
//  Created by eshore on 2017/7/28.
//  Copyright © 2017年 howell. All rights reserved.
//

#import "ESScrollPageView.h"

@interface ESScrollPageView()

@property (strong, nonatomic) ESScrollPageStyle *scrollPageStyle;
@property (weak, nonatomic) ESScrollPageBarView *barView;
@property (weak, nonatomic) ESScrollPageContentView *contentView;

@property (weak, nonatomic) UIViewController *parentViewController;
@property (strong, nonatomic) NSArray *childVcs;
@property (strong, nonatomic) NSArray *titlesArray;

@end

@implementation ESScrollPageView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame scrollPageStyle:(ESScrollPageStyle *)scrollPageStyle titles:(NSArray<NSString *> *)titles parentViewController:(UIViewController *)parentViewController delegate:(id<ESScrollPageViewDelegate>) delegate {
    if (self = [super initWithFrame:frame]) {
        self.scrollPageStyle = scrollPageStyle?scrollPageStyle:[[ESScrollPageStyle alloc] init];
        self.delegate = delegate;
        self.parentViewController = parentViewController;
        self.titlesArray = titles.copy;
        [self commonInit];
    }
    return self;
}


- (void)commonInit {
    
    // 触发懒加载
    self.barView.backgroundColor = self.scrollPageStyle.scrollBarBGColor;
    self.contentView.backgroundColor = [UIColor whiteColor];
}

- (void)dealloc {
    NSLog(@"ScrollPageView--销毁");
}

#pragma mark - public helper

/** 给外界设置选中的下标的方法 */
- (void)setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated {
    [self.barView setSelectedIndex:selectedIndex animated:animated];
}

/**  给外界重新设置视图内容的标题的方法 */
- (void)reloadWithNewTitles:(NSArray<NSString *> *)newTitles {
    
    self.titlesArray = nil;
    self.titlesArray = newTitles.copy;
    
    [self.barView reloadTitlesWithNewTitles:self.titlesArray];
    [self.contentView reload];
}


#pragma mark - getter ---- setter

- (ESScrollPageContentView *)contentView {
    if (!_contentView) {
        ESScrollPageContentView *content = [[ESScrollPageContentView alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY(self.barView.frame), self.bounds.size.width, self.bounds.size.height - CGRectGetMaxY(self.barView.frame)) barView:self.barView parentViewController:self.parentViewController delegate:self.delegate];
        [self addSubview:content];
        _contentView = content;
    }
    
    return  _contentView;
}


- (ESScrollPageBarView *)barView {
    if (!_barView) {
        __weak typeof(self) weakSelf = self;
        ESScrollPageBarView *bar = [[ESScrollPageBarView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.scrollPageStyle.scrollBarHeight) barStyle:self.scrollPageStyle delegate:self.delegate titles:self.titlesArray titleDidClick:^(ESScrollPageTitleView *titleView, NSInteger index) {
            
            [weakSelf.contentView setContentOffSet:CGPointMake(weakSelf.contentView.bounds.size.width * index, 0.0) animated:NO];
            
        }];
        [self addSubview:bar];
        _barView = bar;
    }
    return _barView;
}


- (NSArray *)childVcs {
    if (!_childVcs) {
        _childVcs = [NSArray array];
    }
    return _childVcs;
}

- (NSArray *)titlesArray {
    if (!_titlesArray) {
        _titlesArray = [NSArray array];
    }
    return _titlesArray;
}

@end
