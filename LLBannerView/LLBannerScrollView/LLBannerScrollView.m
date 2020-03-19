//
//  LLBannerScrollView.m
//  LLBannerView
//
//  Created by 嘚嘚以嘚嘚 on 2018/5/29.
//  Copyright © 2018年 嘚嘚以嘚嘚. All rights reserved.
//

#import "LLBannerScrollView.h"
#import "LLCollectionViewCell.h"
#import "UIView+Frame.h"
#import "SDWebImageManager.h"
#import "CubLayout.h"
static NSString * const LLCollectionViewCellID = @"LLCollectionViewCell";

@interface LLBannerScrollView ()<UICollectionViewDelegate,UICollectionViewDataSource,CAAnimationDelegate>
@property (nonatomic, weak) UICollectionViewFlowLayout *flowLayout;
//@property (nonatomic, weak)CubLayout * flowLayout;
@property (nonatomic, weak) UICollectionView *mainScollcetionView; // 显示图片的collectionView
@property (nonatomic, assign) NSInteger totalItemsCount;/** 数据源总个数*/
@property (nonatomic, strong) NSMutableArray *imagePathsGroup;/** 网络图片 url string 数组 */
@property (nonatomic, strong) NSTimer * timer;/** 滚动定时器 */
@property (nonatomic, weak) UIPageControl *pageControl;/** 分页显示器 */
@property (nonatomic, strong) dispatch_queue_t queue;/** 下载图片任务队列 */

@end

@implementation LLBannerScrollView

- (instancetype) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.autoScroll = YES;
        self.infiniteLoop = YES;
        self.autoScrollTimeInterval = 2.0;
        self.hidesForSinglePage = YES;
        _showPageControl = YES;
        _pageControlSize = CGSizeMake(10, 10);
        _pageControlBottomOffset = 0;
        _pageControlRightOffset = 0;
        _currentPageColor = [UIColor whiteColor];
        _otherPageColor = [UIColor lightGrayColor];
        _bannerImageViewContentMode = UIViewContentModeScaleToFill;
        self.scrollViewAnimation = LLBannerScrollViewAnimationDefault;
        [self setupMainView];
        [self setupTimer];
        [self setUpPath];
    }
    return self;
}
+ (instancetype)bannerScrollViewWithFrame:(CGRect)frame delegate:(id<LLBannerScrollViewDelegate>)delegate placeholderImage:(UIImage *)placeholderImage
{
    LLBannerScrollView * bannerScrollView = [self bannerScrollViewWithFrame:frame placeholderImage:placeholderImage];

    bannerScrollView.delegate = delegate;

    return bannerScrollView;
}

+ (instancetype)bannerScrollViewWithFrame:(CGRect)frame  placeholderImage:(UIImage *)placeholderImage
{
    LLBannerScrollView * bannerScrollView = [self bannerScrollViewWithFrame:frame];
    bannerScrollView.placeholderImage = placeholderImage;
    return bannerScrollView;
}

+ (instancetype)bannerScrollViewWithFrame:(CGRect)frame
{
    LLBannerScrollView * bannerScrollView = [[self alloc] initWithFrame:frame];
    
    return bannerScrollView;
}

#pragma mark - actions

- (void)setupMainView
{
    
//  CubLayout * flowLayout = [[CubLayout alloc]init];
//    flowLayout.isZoom = YES;
//    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    flowLayout.minimumLineSpacing = 0;
    
    UICollectionViewFlowLayout * layout = [UICollectionViewFlowLayout new];
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.flowLayout = layout;
    
    UICollectionView * mainScollcetionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:self.flowLayout];
    mainScollcetionView.backgroundColor = [UIColor clearColor];
    mainScollcetionView.pagingEnabled = YES;
    mainScollcetionView.showsVerticalScrollIndicator = NO;
    mainScollcetionView.showsHorizontalScrollIndicator = NO;
    [mainScollcetionView registerClass:[LLCollectionViewCell class] forCellWithReuseIdentifier:LLCollectionViewCellID];
    mainScollcetionView.delegate = self;
    mainScollcetionView.dataSource = self;
    
    [self addSubview:mainScollcetionView];
    self.mainScollcetionView = mainScollcetionView;
    
}
- (void)setupPageControl
{
    if (!self.imagePathsGroup.count) return;
        
    if (_pageControl) [_pageControl removeFromSuperview];
    
    if ((self.imagePathsGroup.count == 1) && self.hidesForSinglePage) return;

    int indexPageControl = [self pageControlIndexWithCurrentCellIndex:[self currentIndex]];

    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = self.imagePathsGroup.count;
    pageControl.currentPageIndicatorTintColor = self.currentPageColor;
    pageControl.pageIndicatorTintColor = self.otherPageColor;
    pageControl.userInteractionEnabled = NO;
    pageControl.currentPage = indexPageControl;
    [self addSubview:pageControl];
    _pageControl = pageControl;
}
- (void)setupTimer
{
    [self invalidateTimer]; // 创建定时器前先停止定时器，不然会出现僵尸定时器，导致轮播频率错误
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollTimeInterval target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
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

- (int)currentIndex
{
    if (_mainScollcetionView.ll_width == 0 || _mainScollcetionView.ll_height == 0) {
        return 0;
    }
    
    int index = 0;
    if (_flowLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        index = (_mainScollcetionView.contentOffset.x + _flowLayout.itemSize.width * 0.5) / _flowLayout.itemSize.width;
    } else {
        index = (_mainScollcetionView.contentOffset.y + _flowLayout.itemSize.height * 0.5) / _flowLayout.itemSize.height;
    }
    
    return MAX(0, index);
}

- (void)scrollToIndex:(int)targetIndex
{
    if (targetIndex >= _totalItemsCount) {
        
        if (self.infiniteLoop) {
            targetIndex = _totalItemsCount * 0.5;
            [_mainScollcetionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        }
        return;
    }
    if (self.scrollViewAnimation == LLBannerScrollViewAnimationCube) {
        CATransition *animation = [CATransition animation];
        animation.delegate = self;
        animation.duration = 0.5f ;
//        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.fillMode = kCAFillModeForwards;
        animation.subtype = kCATransitionFromRight;

        animation.removedOnCompletion = YES;
        animation.type = @"cube";
        [self.mainScollcetionView.layer addAnimation:animation forKey:@"animationID"];

    }
    [_mainScollcetionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];

}

- (void)disableScrollGesture {
    self.mainScollcetionView.canCancelContentTouches = NO;
    for (UIGestureRecognizer *gesture in self.mainScollcetionView.gestureRecognizers) {
        if ([gesture isKindOfClass:[UIPanGestureRecognizer class]]) {
            [self.mainScollcetionView removeGestureRecognizer:gesture];
        }
    }
}

- (void)clearImagesCache
{
    NSString * path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"LLBannerCache"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:path error:nil];
    [[[SDWebImageManager sharedManager] imageCache] clearDiskOnCompletion:nil];
    [self setUpPath];
}

#pragma mark ----------setter方法赋值------------
- (void)setImageURLStringsGroup:(NSArray *)imageURLStringsGroup
{
    _imageURLStringsGroup = imageURLStringsGroup;
    NSMutableArray * temp = [NSMutableArray new];
    [imageURLStringsGroup enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString * urlString;
        if ([obj isKindOfClass:[NSString class]]) {

            if ([obj hasSuffix:@".gif"]) {
                if ([obj hasPrefix:@"http"]) {
                    [self downloadImages:idx urlString:obj temp:temp];
                }else{
                    NSString *imagePath = [[NSBundle mainBundle] pathForResource:obj ofType:nil];
                    NSData *data = [NSData dataWithContentsOfFile:imagePath];
                    [temp addObject:getImageWithData(data)];
                }

            }else{
                urlString = obj;
            }
            
        }else if ([obj isKindOfClass:[NSURL class]]){
            NSURL * url = (NSURL *)obj;
            urlString = [url absoluteString];
        }
        if (urlString) {
            [temp addObject:urlString];
        }
    }];
    self.imagePathsGroup = temp;
}
#pragma mark 下载网络图片
- (void)downloadImages:(NSUInteger)index urlString:(NSString *)urlString temp:(NSMutableArray *)temp{
    NSString *imageName = [urlString stringByReplacingOccurrencesOfString:@"/" withString:@""];
    NSString *otherImageName = [imageName stringByReplacingOccurrencesOfString:@"http" withString:@""];

    NSString *path = [[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"LLBannerCache"] stringByAppendingPathComponent:otherImageName];
    
        NSData *patchData = [NSData dataWithContentsOfFile:path];
        if (patchData) {
            
            [temp addObject:getImageWithData(patchData)];

            return;
        }

    //下载图片
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
    
    [temp addObject:urlString];


    dispatch_async(self.queue, ^{
        if ([data writeToFile:path atomically:YES]) {
            if (self.imagePathsGroup) {
                self.imagePathsGroup[index] = getImageWithData([NSData dataWithContentsOfFile:path]);
            }else{
                temp[index] =getImageWithData([NSData dataWithContentsOfFile:path]);
            }
        }        

    });
    
}
-(dispatch_queue_t)queue{
    if (!_queue) {
        _queue =dispatch_queue_create("downImage", DISPATCH_QUEUE_CONCURRENT);
    }
    return _queue;
}
#pragma mark 下载图片，如果是gif则计算动画时长
UIImage *getImageWithData(NSData *data) {
    CGImageSourceRef imageSource = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    size_t count = CGImageSourceGetCount(imageSource);
    { //gif图片
        NSMutableArray *images = [NSMutableArray array];
        NSTimeInterval duration = 0;
        for (size_t i = 0; i < count; i++) {
            CGImageRef image = CGImageSourceCreateImageAtIndex(imageSource, i, NULL);
            if (!image) continue;
            duration += durationWithSourceAtIndex(imageSource, i);
            [images addObject:[UIImage imageWithCGImage:image]];
            CGImageRelease(image);
        }
        if (!duration) duration = 0.1 * count;
        CFRelease(imageSource);
        return [UIImage animatedImageWithImages:images duration:duration];
    }
}


#pragma mark 获取每一帧图片的时长
float durationWithSourceAtIndex(CGImageSourceRef source, NSUInteger index) {
    float duration = 0.1f;
    CFDictionaryRef propertiesRef = CGImageSourceCopyPropertiesAtIndex(source, index, nil);
    NSDictionary *properties = (__bridge NSDictionary *)propertiesRef;
    NSDictionary *gifProperties = properties[(NSString *)kCGImagePropertyGIFDictionary];
    
    NSNumber *delayTime = gifProperties[(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
    if (delayTime) duration = delayTime.floatValue;
    else {
        delayTime = gifProperties[(NSString *)kCGImagePropertyGIFDelayTime];
        if (delayTime) duration = delayTime.floatValue;
    }
    CFRelease(propertiesRef);
    return duration;
}

- (void)setUpPath
{
    NSString * path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"LLBannerCache"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    if  (![fileManager fileExistsAtPath:path isDirectory:&isDir]) {//先判断目录是否存在，不存在才创建
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
}
- (void)setTitlesGroup:(NSArray *)titlesGroup
{
    _titlesGroup = titlesGroup;
}

- (void)setImagePathsGroup:(NSMutableArray *)imagePathsGroup
{
    [self invalidateTimer];
    
    if (!imagePathsGroup) return;
    
    _imagePathsGroup = imagePathsGroup;
    
    _totalItemsCount = self.infiniteLoop ? self.imagePathsGroup.count * 100 : self.imagePathsGroup.count;
    
    if (imagePathsGroup.count > 1) { // 由于 !=1 包含count == 0等情况
        self.mainScollcetionView.scrollEnabled = YES;
        [self setAutoScroll:self.autoScroll];
    } else {
        self.mainScollcetionView.scrollEnabled = NO;
        [self invalidateTimer];
    }
    
    [self setupPageControl];

    [self.mainScollcetionView reloadData];

}

-(void)setAutoScrollTimeInterval:(CGFloat)autoScrollTimeInterval
{
    _autoScrollTimeInterval = autoScrollTimeInterval;
    [self setAutoScroll:self.autoScroll];

}

-(void)setInfiniteLoop:(BOOL)infiniteLoop
{
    _infiniteLoop = infiniteLoop;
    self.imagePathsGroup = self.imagePathsGroup;
}

-(void)setAutoScroll:(BOOL)autoScroll
{
    _autoScroll = autoScroll;
    
    [self invalidateTimer];

    if (_autoScroll) {
        [self setupTimer];
    }
}
-(void)setScrollDirection:(UICollectionViewScrollDirection)scrollDirection
{
    _scrollDirection = scrollDirection;
    self.flowLayout.scrollDirection = scrollDirection;
}

-(void)setShowPageControl:(BOOL)showPageControl
{
    _showPageControl = showPageControl;
    _pageControl.hidden = !showPageControl;
}

-(void)setHidesForSinglePage:(BOOL)hidesForSinglePage
{
    _hidesForSinglePage = hidesForSinglePage;
    [self setupPageControl];

}

-(void)setPageControlSize:(CGSize)pageControlSize
{
    _pageControlSize = pageControlSize;
    [self setupPageControl];

}
-(void)setOtherPageColor:(UIColor *)otherPageColor
{
    UIPageControl *pageControl = (UIPageControl *)_pageControl;
    pageControl.pageIndicatorTintColor = otherPageColor;

}
-(void)setCurrentPageColor:(UIColor *)currentPageColor
{
    UIPageControl *pageControl = (UIPageControl *)_pageControl;
    pageControl.currentPageIndicatorTintColor = currentPageColor;

}

-(void)setCurrentPageImage:(UIImage *)currentPageImage
{
    UIPageControl *pageControl = (UIPageControl *)_pageControl;
    [pageControl setValue:currentPageImage forKeyPath:@"_currentPageImage"];

}

-(void)setOtherpageImage:(UIImage *)otherpageImage
{
    UIPageControl *pageControl = (UIPageControl *)_pageControl;
    [pageControl setValue:otherpageImage forKeyPath:@"_pageImage"];
}

-(void)setPlaceholderImage:(UIImage *)placeholderImage
{
    _placeholderImage = placeholderImage;
}

-(void)setTitleLabelTextAlignment:(NSTextAlignment)titleLabelTextAlignment
{
    _titleLabelTextAlignment = titleLabelTextAlignment;
}

-(void)setTitleLabelTextFont:(UIFont *)titleLabelTextFont
{
    _titleLabelTextFont = titleLabelTextFont;
}

-(void)setTitleLabelBackgroundColor:(UIColor *)titleLabelBackgroundColor
{
    _titleLabelBackgroundColor = titleLabelBackgroundColor;
}

-(void)setTitleLabelHeight:(CGFloat)titleLabelHeight
{
    _titleLabelHeight = titleLabelHeight;
}

-(void)setTitleLabelTextColor:(UIColor *)titleLabelTextColor
{
    _titleLabelTextColor = titleLabelTextColor;
}
- (int)pageControlIndexWithCurrentCellIndex:(NSInteger)index
{
    return (int)index % self.imagePathsGroup.count;
}
-(void)setItemWidth:(CGFloat)itemWidth
{
    _itemWidth = itemWidth;
    self.flowLayout.itemSize = CGSizeMake(itemWidth, self.bounds.size.height);
}
#pragma mark - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.totalItemsCount;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LLCollectionViewCell * item = [collectionView dequeueReusableCellWithReuseIdentifier:LLCollectionViewCellID forIndexPath:indexPath];
    //应显示数据源的位置 对数据源进行取余 得到indexPath.item的数据源
    long itemIndex = [self pageControlIndexWithCurrentCellIndex:indexPath.item];
    item.placeholderImage = self.placeholderImage;
    item.imagePath = self.imagePathsGroup[itemIndex];
    if (self.titlesGroup && itemIndex < _titlesGroup.count) {
        item.title = self.titlesGroup[itemIndex];
    }
    item.titleLabelTextAlignment = self.titleLabelTextAlignment;
    item.titleLabelTextFont = self.titleLabelTextFont;
    item.titleLabelBackgroundColor = self.titleLabelBackgroundColor;
    item.titleLabelHeight = self.titleLabelHeight;
    item.titleLabelTextColor = self.titleLabelTextColor;
    

    return item;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(bannerScrollView:didSelectItemAtIndex:)]) {
        
        [self.delegate bannerScrollView:self didSelectItemAtIndex:[self pageControlIndexWithCurrentCellIndex:indexPath.item]];
    }
    if (self.bannerItemOperationBlock) {
        self.bannerItemOperationBlock([self pageControlIndexWithCurrentCellIndex:indexPath.item]);
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.imagePathsGroup.count) return; // 解决清除timer时偶尔会出现的问题
    int itemIndex = [self currentIndex];
    int indexOnPageControl = [self pageControlIndexWithCurrentCellIndex:itemIndex];
    UIPageControl *pageControl = (UIPageControl *)_pageControl;
    pageControl.currentPage = indexOnPageControl;
   
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{

    if (self.autoScroll) {
        [self invalidateTimer];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.autoScroll) {
        [self setupTimer];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    [self scrollViewDidEndScrollingAnimation:self.mainScollcetionView];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.flowLayout.itemSize = self.frame.size;
//    self.flowLayout.itemSize = CGSizeMake(self.bounds.size.width-100, self.bounds.size.height);

    self.mainScollcetionView.frame = self.bounds;
    
    CGSize size = CGSizeZero;
    
    size = CGSizeMake(self.imagePathsGroup.count * self.pageControlSize.width * 1.5, self.pageControlSize.height);

    CGFloat x = (self.ll_width - size.width) * 0.5;
    
    if (self.pageControlAliment == LLBannerScrollViewPageContolAlimentRight) {
        x = self.mainScollcetionView.ll_width - size.width - 10;
    }
    CGFloat y = self.mainScollcetionView.ll_height - size.height - 10;

    CGRect pageControlFrame = CGRectMake(x, y, size.width, size.height);
    
    pageControlFrame.origin.y -= self.pageControlBottomOffset;
    pageControlFrame.origin.x -= self.pageControlRightOffset;

    self.pageControl.frame = pageControlFrame;
    self.pageControl.hidden = !_showPageControl;

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
