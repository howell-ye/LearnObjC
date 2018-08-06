//
//  ESCarouselView.m
//  LearnObjC
//
//  Created by eshore on 2017/8/1.
//  Copyright © 2017年 howell. All rights reserved.
//

#import "ESCarouselView.h"
#import "UIView+es_add.h"
#import "ESCarouselCell.h"

#define kImageViewTag 1000
#define ESCellImageFile(url) [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[url lastPathComponent]]

NSString * const cellID = @"ESCarouselCell";

@interface ESCarouselView()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong)ESCarouselStyle *carouselStyle;

@property (nonatomic, weak) UICollectionView *mainView; // 显示图片的collectionView
@property (nonatomic, weak) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, assign) NSInteger totalItemsCount;
@property (nonatomic, weak) UIControl *pageControl;
@property (nonatomic, strong) UIImage *placeholderImage;

@property (nonatomic, strong) UIImageView *backgroundImageView; // 当imageURLs为空时的背景图
//用户下载和缓存图片
@property (nonatomic, strong) NSMutableDictionary *urlImageDict;
@property (nonatomic, strong) NSMutableDictionary *operationDict;
@property (nonatomic, strong) NSOperationQueue *queue;

//本地图片数组
@property (nonatomic, strong) NSArray *imagePathsArray;
//网络图片数组
@property (nonatomic, strong) NSArray *imageURLStringsArray;
//每张图片对应要显示的文字数组
@property (nonatomic, strong) NSArray *titlesArray;
//代理
@property (nonatomic, weak) id<ESCarouselViewDelegate> delegate;

/** 轮播文字位置大小 */
@property (nonatomic, assign) CGRect titleLabelFrame;

@end

@implementation ESCarouselView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initialization];
//        [self setupMainView];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initialization];
    [self setupMainView];
}

- (void)initialization
{
    _titleLabelFrame = CGRectMake(0, self.height - 30, self.width, 30);
}

-(instancetype)initWithFrame:(CGRect)frame carouselStyle:(ESCarouselStyle *)style delegate:(id<ESCarouselViewDelegate>)delegate imageNamesArray:(NSArray *)imageNamesArray titlesArray:(NSArray *)titlesArray
{
    if (self = [self initWithFrame:frame]) {
        
        self.carouselStyle = style?style:[[ESCarouselStyle alloc] init];
        self.delegate = delegate;
        self.titlesArray = titlesArray.copy;
        self.imagePathsArray = imageNamesArray;
        [self commonInit];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame carouselStyle:(ESCarouselStyle *)style delegate:(id<ESCarouselViewDelegate>)delegate imageURLStringsArray:(NSArray *)imageURLStringsArray titlesArray:(NSArray *)titlesArray placeholderImage:(UIImage *)placeholderImage
{
    if (self = [self initWithFrame:frame]) {
        
        self.carouselStyle = style?style:[[ESCarouselStyle alloc] init];
        self.delegate = delegate;
        self.titlesArray = titlesArray.copy;
        self.imageURLStringsArray = imageURLStringsArray;
        self.placeholderImage = placeholderImage;
        [self commonInit];
    }
    return self;
}


- (void)commonInit
{
    self.backgroundColor = _carouselStyle.carouselBGColor;
    
    [self setupMainView];
    [self setUpUI];
}

// 设置显示图片的collectionView
- (void)setupMainView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _flowLayout = flowLayout;
    
    UICollectionView *mainView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    mainView.backgroundColor = [UIColor clearColor];
    mainView.pagingEnabled = YES;
    mainView.showsHorizontalScrollIndicator = NO;
    mainView.showsVerticalScrollIndicator = NO;
    mainView.bounces = NO;
    [mainView registerClass:[ESCarouselCell class] forCellWithReuseIdentifier:cellID];
    
    mainView.dataSource = self;
    mainView.delegate = self;
    mainView.scrollsToTop = NO;
    [self addSubview:mainView];
    _mainView = mainView;
}

- (void)setUpUI
{
    if (!self.backgroundImageView) {
        UIImageView *bgImageView = [UIImageView new];
        bgImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self insertSubview:bgImageView belowSubview:self.mainView];
        self.backgroundImageView = bgImageView;
    }
    
    self.backgroundImageView.image = _placeholderImage;
    
    if (_carouselStyle.showPageControl) {
        if (_pageControl) [_pageControl removeFromSuperview]; // 重新加载数据时调整
        
        if (self.imagePathsArray.count == 0) return;
        
        if ((self.imagePathsArray.count == 1)) return;
        
        int indexOnPageControl = [self pageControlIndexWithCurrentCellIndex:[self currentIndex]];
        
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        if (_carouselStyle.pageDotNumber == -1) {
            pageControl.numberOfPages = self.imagePathsArray.count;
        }else{
            pageControl.numberOfPages = _carouselStyle.pageDotNumber;
        }
        pageControl.currentPageIndicatorTintColor = _carouselStyle.currentPageDotColor;
        pageControl.pageIndicatorTintColor = _carouselStyle.pageDotColor;
        pageControl.userInteractionEnabled = NO;
        pageControl.currentPage = indexOnPageControl;
        [self addSubview:pageControl];
        _pageControl = pageControl;
    }
}

#pragma mark - properties



- (void)setImagePathsArray:(NSArray *)imagePathsArray
{
    [self invalidateTimer];
    
    _imagePathsArray = [imagePathsArray copy];
    
    _totalItemsCount = _carouselStyle.infiniteLoop ? self.imagePathsArray.count * 100 : self.imagePathsArray.count;
    
    if (imagePathsArray.count > 1) { // 由于 !=1 包含count == 0等情况
        self.mainView.scrollEnabled = YES;
        if (_carouselStyle.autoScroll) {
            [self setupTimer];
        }
    } else {
        self.mainView.scrollEnabled = NO;
        [self invalidateTimer];
    }
}

- (void)setImageURLStringsArray:(NSArray *)imageURLStringsArray
{
    _imageURLStringsArray = [imageURLStringsArray copy];
    
    NSMutableArray *temp = [NSMutableArray new];
    [_imageURLStringsArray enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * stop) {
        NSString *urlString;
        if ([obj isKindOfClass:[NSString class]]) {
            urlString = obj;
        } else if ([obj isKindOfClass:[NSURL class]]) {
            NSURL *url = (NSURL *)obj;
            urlString = [url absoluteString];
        }
        if (urlString) {
            [temp addObject:urlString];
        }
    }];
    self.imagePathsArray = [temp copy];
}

- (void)setTitlesArray:(NSArray *)titlesArray
{
    _titlesArray = titlesArray;
}

- (void)disableScrollGesture {
    self.mainView.canCancelContentTouches = NO;
    for (UIGestureRecognizer *gesture in self.mainView.gestureRecognizers) {
        if ([gesture isKindOfClass:[UIPanGestureRecognizer class]]) {
            [self.mainView removeGestureRecognizer:gesture];
        }
    }
}

#pragma mark - actions

- (void)setupTimer
{
    [self invalidateTimer]; // 创建定时器前先停止定时器，不然会出现僵尸定时器，导致轮播频率错误
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:_carouselStyle.autoScrollTimeInterval target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
    _timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)invalidateTimer
{
    [_timer invalidate];
    _timer = nil;
}


- (void)automaticScroll
{
    if (0 == _totalItemsCount) return;
    int currentIndex = [self currentIndex];
    int targetIndex = currentIndex + 1;
    [self scrollToIndex:targetIndex];
}

- (void)scrollToIndex:(int)targetIndex
{
    if (targetIndex >= _totalItemsCount) {
        if (_carouselStyle.infiniteLoop) {
            targetIndex = _totalItemsCount * 0.5;
            [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        }
        return;
    }
    [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

- (int)currentIndex
{
    if (_mainView.width == 0 || _mainView.height == 0) {
        return 0;
    }
    
    int index = 0;
    if (_flowLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        index = (_mainView.contentOffset.x + _flowLayout.itemSize.width * 0.5) / _flowLayout.itemSize.width;
    } else {
        index = (_mainView.contentOffset.y + _flowLayout.itemSize.height * 0.5) / _flowLayout.itemSize.height;
    }
    
    return MAX(0, index);
}

- (int)pageControlIndexWithCurrentCellIndex:(NSInteger)index
{
    return (int)index % self.imagePathsArray.count;
}

- (void)clearImagesCache
{
    [self.queue cancelAllOperations];
    [self.operationDict removeAllObjects];
    // 移除所有的图片缓存
    [self.urlImageDict removeAllObjects];
}

#pragma mark - life circles

- (void)layoutSubviews
{
    self.delegate = self.delegate;
    
    [super layoutSubviews];
    
    _flowLayout.itemSize = self.frame.size;
    
    _mainView.frame = self.bounds;
    if (_mainView.contentOffset.x == 0 &&  _totalItemsCount) {
        int targetIndex = 0;
        if (_carouselStyle.infiniteLoop) {
            targetIndex = _totalItemsCount * 0.5;
        }else{
            targetIndex = 0;
        }
        [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    
    
    
    CGSize size = CGSizeZero;
    NSInteger number;
    if (_carouselStyle.pageDotNumber == -1) {
        number = self.imagePathsArray.count;
    }else{
        number = _carouselStyle.pageDotNumber;
    }
    size = CGSizeMake(number * 10 * 1.5, 10);
    
    CGFloat x,y;
    y = self.mainView.height - size.height - 10;
    switch (_carouselStyle.pageControlAliment) {
        case ESCarouselViewPageContolAlimentLeft:
            x = 10;
            break;
        case ESCarouselViewPageContolAlimentRight:
            x = self.mainView.width - size.width - 10;
            break;
        case ESCarouselViewPageContolAlimentCenter:
            x = (self.width - size.width) * 0.5;
            break;
        case ESCarouselViewPageContolCustom:
            x = _carouselStyle.pageControlLocation.x;
            y = _carouselStyle.pageControlLocation.y;
            break;
            
        default:
            break;
    }
    
    CGRect pageControlFrame = CGRectMake(x, y, size.width, size.height);
    pageControlFrame.origin.y -= 0;
    pageControlFrame.origin.x -= 0;
    self.pageControl.frame = pageControlFrame;
    self.pageControl.hidden = !_carouselStyle.showPageControl;
    
    if (self.backgroundImageView) {
        self.backgroundImageView.frame = self.bounds;
    }
    
}

//解决当父View释放时，当前视图因为被Timer强引用而不能释放的问题
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (!newSuperview) {
        [self invalidateTimer];
    }
}

//解决当timer释放后 回调scrollViewDidScroll时访问野指针导致崩溃
- (void)dealloc {
    _mainView.delegate = nil;
    _mainView.dataSource = nil;
}

#pragma mark - public actions

- (void)adjustWhenControllerViewWillAppera
{
    long targetIndex = [self currentIndex];
    if (targetIndex < _totalItemsCount) {
        [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _totalItemsCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ESCarouselCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    long itemIndex = [self pageControlIndexWithCurrentCellIndex:indexPath.item];
    
    NSString *imagePath = self.imagePathsArray[itemIndex];
    
    if ([imagePath isKindOfClass:[NSString class]]) {
        if ([imagePath hasPrefix:@"http"]) {
            UIImage *image = self.urlImageDict[imagePath];
            
            if (image) {//成功缓存过
                
                cell.imageView.image = image;
                
            }else{ //缓存中没有图片
                
                // 获得caches的路径, 拼接文件路径
                NSString *filePath = ESCellImageFile(imagePath);
                NSData* ImgaeData = [NSData dataWithContentsOfFile:filePath];
                if (ImgaeData) { // 缓存中有图片
                    cell.imageView.image = [UIImage imageWithData:ImgaeData];
                }else{ // 缓存中没有图片，需要下载
                    
                    // 显示占位图片
                    cell.imageView.image = [UIImage imageNamed:@"placeholder"];
                    //到子线程执行下载操作
                    //取出当前URL对应的下载下载操作
                    NSBlockOperation* operation = self.operationDict[imagePath];
                    if (nil == operation) {
                        //创建下载操作
                        __weak typeof(self) weakself = self;
                        operation = [NSBlockOperation blockOperationWithBlock:^{
                            
                            NSURL* url = [NSURL URLWithString:imagePath];
                            NSData* data =  [NSData dataWithContentsOfURL:url];
                            UIImage* image = [UIImage imageWithData:data];
                            
                            //下载完成的图片放入缓存字典中
                            if (image) { //防止下载失败为空赋值造成崩溃
                                weakself.urlImageDict[imagePath] = image;
                                
                                //下载完成的图片存入沙盒中
                                // UIImage --> NSData --> File（文件）
                                NSData* ImageData = UIImagePNGRepresentation(image);
                                
                                [ImageData writeToFile:ESCellImageFile(imagePath) atomically:YES];
                            }
                            
                            //回到主线程刷新表格
                            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                
                                // 从字典中移除下载操作 (防止operations越来越大，保证下载失败后，能重新下载)
                                [weakself.operationDict removeObjectForKey:imagePath];
                                
                                //刷新当前行的图片数据
                                [weakself.mainView reloadItemsAtIndexPaths:@[indexPath]];
                            }];
                        }];
                        //添加操作到队列中
                        [weakself.queue addOperation:operation];
                        //添加到字典中
                        weakself.operationDict[imagePath] = operation;
                        
                    }
                }
            }
            
        } else {
            UIImage *image = [UIImage imageNamed:imagePath];
            if (!image) {
                [UIImage imageWithContentsOfFile:imagePath];
            }
            cell.imageView.image = image;
        }
    } else if ([imagePath isKindOfClass:[UIImage class]]) {
        cell.imageView.image = (UIImage *)imagePath;
    }
    
    if (_titlesArray.count && itemIndex < _titlesArray.count) {
        cell.title = _titlesArray[itemIndex];
    }
    
    cell.titleLabelBackgroundColor = _carouselStyle.titleLabelBackgroundColor;
    cell.titleLabelFrame = self.titleLabelFrame;
    cell.titleLabelTextAlignment = _carouselStyle.titleLabelTextAlignment;
    cell.titleLabelTextColor = _carouselStyle.titleLabelTextColor;
    cell.titleLabelTextFont = _carouselStyle.titleLabelTextFont;
    cell.clipsToBounds = YES;
    
    if ([self.delegate respondsToSelector:@selector(customViewForcell:forIndex:carouselView:)]) {
        [self.delegate customViewForcell:cell forIndex:itemIndex carouselView:self];
        return cell;
    }
    
    return cell;
}

- (NSOperationQueue *)queue
{
    if (!_queue) {
        self.queue = [[NSOperationQueue alloc] init];
    }
    return _queue;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(carouselView:didSelectItemAtIndex:)]) {
        [self.delegate carouselView:self didSelectItemAtIndex:[self pageControlIndexWithCurrentCellIndex:indexPath.item]];
    }
}


#pragma mark - ReloadViewWithData
- (void)reloadWithImageNamesArray:(NSArray *)imageNamesArray titlesArray:(NSArray *)titlesArray
{
    self.titlesArray = nil;
    self.imagePathsArray = nil;
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
    self.titlesArray = titlesArray.copy;
    self.imagePathsArray = imageNamesArray;
    [self commonInit];
}

- (void)reloadWithImageURLStringsArray:(NSArray *)imageURLStringsArray titlesArray:(NSArray *)titlesArray
{
    self.titlesArray = nil;
    self.imageURLStringsArray = nil;
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
    self.titlesArray = titlesArray.copy;
    self.imageURLStringsArray = imageURLStringsArray;
    [self commonInit];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.imagePathsArray.count) return; // 解决清除timer时偶尔会出现的问题
    int itemIndex = [self currentIndex];
    int indexOnPageControl = [self pageControlIndexWithCurrentCellIndex:itemIndex];
    
    UIPageControl *pageControl = (UIPageControl *)_pageControl;
    NSInteger pageCount = pageControl.numberOfPages;
    if (indexOnPageControl <= pageCount - 1) {
        pageControl.currentPage = indexOnPageControl;
    }else{
        pageControl.currentPage = pageCount - 1;
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (_carouselStyle.autoScroll) {
        [self invalidateTimer];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (_carouselStyle.autoScroll) {
        [self setupTimer];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:self.mainView];
    if ([self.delegate respondsToSelector:@selector(carouselView:currentOffset:)]) {
        [self.delegate carouselView:self currentOffset:self.mainView.contentOffset];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (!self.imagePathsArray.count) return; // 解决清除timer时偶尔会出现的问题
    int itemIndex = [self currentIndex];
    int indexOnPageControl = [self pageControlIndexWithCurrentCellIndex:itemIndex];
    
    if ([self.delegate respondsToSelector:@selector(carouselView:didScrollToIndex:)]) {
        [self.delegate carouselView:self didScrollToIndex:indexOnPageControl];
    }
}

@end
