//
//  ESScrollPageBarView.m
//  LearnObjC
//
//  Created by eshore on 2017/7/28.
//  Copyright © 2017年 howell. All rights reserved.
//

#import "ESScrollPageBarView.h"
#import "ESScrollPageTitleView.h"
#import "ESScrollPageViewDelegate.h"
#import "UIView+es_add.h"

@interface ESScrollPageBarView ()<UIScrollViewDelegate> {
    CGFloat _currentWidth;
    NSUInteger _currentIndex;
    NSUInteger _oldIndex;
}

// 滚动scrollView
@property (strong, nonatomic) UIScrollView *scrollView;
/** 缓存所有标题label */
@property (nonatomic, strong) NSMutableArray *titleViews;
// 缓存计算出来的每个标题的宽度
@property (nonatomic, strong) NSMutableArray *titleWidths;
// 响应标题点击
@property (copy, nonatomic) TitleBtnOnClickBlock titleBtnOnClick;

@end

@implementation ESScrollPageBarView

static CGFloat const contentSizeXOff = 20.0;

#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect )frame barStyle:(ESScrollPageStyle *)style delegate:(id<ESScrollPageViewDelegate>)delegate titles:(NSArray *)titles titleDidClick:(TitleBtnOnClickBlock)titleDidClick {
    if (self = [super initWithFrame:frame]) {
        self.barStyle = style;
        self.titles = titles;
        self.titleBtnOnClick = titleDidClick;
        self.delegate = delegate;
        _currentIndex = 0;
        _oldIndex = 0;
        _currentWidth = frame.size.width;
        [self setupSubviews];
        [self setupUI];
        
    }
    
    return self;
}
- (void)setupSubviews {
    
    [self addSubview:self.scrollView];
    [self setupTitles];
}



- (void)dealloc
{
#if DEBUG
    NSLog(@"ScrollBarView ---- 销毁");
    
#endif
}

#pragma mark - button action

- (void)titleLabelOnClick:(UITapGestureRecognizer *)tapGes {
    
    ESScrollPageTitleView *currentLabel = (ESScrollPageTitleView *)tapGes.view;
    
    if (!currentLabel) {
        return;
    }
    
    _currentIndex = currentLabel.tag;
    
    [self adjustUIWhenBtnOnClickWithAnimate:true taped:YES];
}


#pragma mark - private helper

- (void)setupTitles {
    
    if (self.titles.count == 0) return;
    
    NSInteger index = 0;
    for (NSString *title in self.titles) {
        
        ESScrollPageTitleView *titleView = [[ESScrollPageTitleView alloc] initWithFrame:CGRectZero];
        titleView.tag = index;
        
        UIFont *biggerFont = self.barStyle.selectedFont.pointSize > self.barStyle.unSelectedFont.pointSize?self.barStyle.selectedFont: self.barStyle.unSelectedFont;
        titleView.sizeFont = biggerFont;
        titleView.font = self.barStyle.unSelectedFont;
        titleView.text = title;
        titleView.textColor = self.barStyle.unSelectedColor;
        
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(setUpTitleView:forIndex:)]) {
            [self.delegate setUpTitleView:titleView forIndex:index];
        }
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleLabelOnClick:)];
        [titleView addGestureRecognizer:tapGes];
        
        CGFloat titleViewWidth = [titleView titleViewWidth];
        [self.titleWidths addObject:@(titleViewWidth)];
        
        [self.titleViews addObject:titleView];
        [self.scrollView addSubview:titleView];
        
        index++;
        
    }
    
}

- (void)setupUI {
    if (self.titles.count == 0) return;
    
    self.scrollView.frame = CGRectMake(0.0, 0.0, _currentWidth, self.height);
    [self setUpTitleViewsPosition];
    
    if (self.barStyle.isScrollTitle) { // 设置滚动区域
        ESScrollPageTitleView *lastTitleView = (ESScrollPageTitleView *)self.titleViews.lastObject;
        
        if (lastTitleView) {
            self.scrollView.contentSize = CGSizeMake(CGRectGetMaxX(lastTitleView.frame) + contentSizeXOff, 0.0);
        }
    }
}

- (void)setUpTitleViewsPosition {
    CGFloat titleX = 0.0;
    CGFloat titleY = 0.0;
    CGFloat titleW = 0.0;
    CGFloat titleH = self.height;
    
    
    if (!self.barStyle.isScrollTitle) {// 标题不能滚动, 平分宽度
        titleW = self.scrollView.bounds.size.width / self.titles.count;
        
        NSInteger index = 0;
        for (ESScrollPageTitleView *titleView in self.titleViews) {
            
            titleX = index * titleW;
            
            titleView.frame = CGRectMake(titleX, titleY, titleW, titleH);
            index++;
        }
        
    } else {
        NSInteger index = 0;
        float lastLableMaxX = self.barStyle.titleMargin;
        float addedMargin = 0.0f;
        
        for (ESScrollPageTitleView *titleView in self.titleViews) {
            titleW = [self.titleWidths[index] floatValue];
            titleX = lastLableMaxX + addedMargin/2;
            
            lastLableMaxX += (titleW + addedMargin + self.barStyle.titleMargin);
            
            titleView.frame = CGRectMake(titleX, titleY, titleW, titleH);
            index++;
            
        }
        
    }

    
    
    ESScrollPageTitleView *currentTitleView = (ESScrollPageTitleView *)self.titleViews[_currentIndex];
    if (currentTitleView) {
        // 设置初始状态文字的颜色
        currentTitleView.textColor = self.barStyle.selectedColor;
        currentTitleView.font = self.barStyle.selectedFont;
    }
    
}


#pragma mark - public helper

- (void)adjustUIWhenBtnOnClickWithAnimate:(BOOL)animated taped:(BOOL)taped {
    if (_currentIndex == _oldIndex && taped) { return; }
    
    ESScrollPageTitleView *oldTitleView = (ESScrollPageTitleView *)self.titleViews[_oldIndex];
    ESScrollPageTitleView *currentTitleView = (ESScrollPageTitleView *)self.titleViews[_currentIndex];
    
    CGFloat animatedTime = animated ? 0.30 : 0.0;
    
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:animatedTime animations:^{
        oldTitleView.textColor = weakSelf.barStyle.unSelectedColor;
        currentTitleView.textColor = weakSelf.barStyle.selectedColor;
        oldTitleView.selected = NO;
        currentTitleView.selected = YES;
        
    } completion:^(BOOL finished) {
        [weakSelf adjustTitleOffSetToCurrentIndex:_currentIndex];
        
    }];
    
    _oldIndex = _currentIndex;
    if (self.titleBtnOnClick) {
        self.titleBtnOnClick(currentTitleView, _currentIndex);
    }
}

- (void)adjustUIWithProgress:(CGFloat)progress oldIndex:(NSInteger)oldIndex currentIndex:(NSInteger)currentIndex {
    if (oldIndex < 0 ||
        oldIndex >= self.titles.count ||
        currentIndex < 0 ||
        currentIndex >= self.titles.count
        ) {
        return;
    }
    _oldIndex = currentIndex;
    
}

- (void)adjustTitleOffSetToCurrentIndex:(NSInteger)currentIndex {
    _oldIndex = currentIndex;
    int index = 0;
    for (ESScrollPageTitleView *titleView in _titleViews) {
        if (index != currentIndex) {
            titleView.textColor = self.barStyle.unSelectedColor;
            titleView.font = self.barStyle.unSelectedFont;
            titleView.selected = NO;
            
        }
        else {
            titleView.textColor = self.barStyle.selectedColor;
            titleView.font = self.barStyle.selectedFont;
            titleView.selected = YES;
        }
        index++;
    }
    //
    
    if (self.scrollView.contentSize.width != self.scrollView.bounds.size.width + contentSizeXOff) {// 需要滚动
        ESScrollPageTitleView *currentTitleView = (ESScrollPageTitleView *)_titleViews[currentIndex];
        
        CGFloat offSetx = currentTitleView.center.x - _currentWidth * 0.5;
        if (offSetx < 0) {
            offSetx = 0;
            
        }
//        CGFloat extraBtnW = self.extraBtn ? self.extraBtn.width : 0.0;
        CGFloat maxOffSetX = self.scrollView.contentSize.width - _currentWidth;
        
        if (maxOffSetX < 0) {
            maxOffSetX = 0;
        }
        
        if (offSetx > maxOffSetX) {
            offSetx = maxOffSetX;
        }

        [self.scrollView setContentOffset:CGPointMake(offSetx, 0.0) animated:YES];
    }
    
    
}

- (void)setSelectedIndex:(NSInteger)index animated:(BOOL)animated {
    NSAssert(index >= 0 && index < self.titles.count, @"设置的下标不合法!!");
    
    if (index < 0 || index >= self.titles.count) {
        return;
    }
    
    _currentIndex = index;
    [self adjustUIWhenBtnOnClickWithAnimate:animated taped:NO];
}

- (void)reloadTitlesWithNewTitles:(NSArray *)titles {
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    _currentIndex = 0;
    _oldIndex = 0;
    self.titleWidths = nil;
    self.titleViews = nil;
    self.titles = nil;
    self.titles = [titles copy];
    if (self.titles.count == 0) return;
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
    [self setupSubviews];
    [self setupUI];
    [self setSelectedIndex:0 animated:YES];
    
}

#pragma mark - getter --- getter

- (UIScrollView *)scrollView {
    
    if (!_scrollView) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.scrollsToTop = NO;
        scrollView.bounces = YES;
        scrollView.pagingEnabled = NO;
        scrollView.delegate = self;
        _scrollView = scrollView;
    }
    return _scrollView;
}

- (NSMutableArray *)titleViews
{
    if (_titleViews == nil) {
        _titleViews = [NSMutableArray array];
    }
    return _titleViews;
}

- (NSMutableArray *)titleWidths
{
    if (_titleWidths == nil) {
        _titleWidths = [NSMutableArray array];
    }
    return _titleWidths;
}


@end
