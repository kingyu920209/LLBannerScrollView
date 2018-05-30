//
//  LLBannerScrollView.h
//  LLBannerView
//
//  Created by 嘚嘚以嘚嘚 on 2018/5/29.
//  Copyright © 2018年 嘚嘚以嘚嘚. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    LLBannerScrollViewPageContolAlimentRight,
    LLBannerScrollViewPageContolAlimentCenter
} LLBannerScrollViewPageContolAliment;

@class LLBannerScrollView;
@protocol LLBannerScrollViewDelegate <NSObject>

@optional
/** 点击图片回调 */
- (void)bannerScrollView:(LLBannerScrollView *)bannerScrollView didSelectItemAtIndex:(NSInteger)index;
@end

@interface LLBannerScrollView : UIView

+ (instancetype)bannerScrollViewWithFrame:(CGRect)frame delegate:(id<LLBannerScrollViewDelegate>)delegate placeholderImage:(UIImage *)placeholderImage;

+ (instancetype)bannerScrollViewWithFrame:(CGRect)frame  placeholderImage:(UIImage *)placeholderImage;

+ (instancetype)bannerScrollViewWithFrame:(CGRect)frame;

#pragma mark ________________  数据源API  ________________

/** 网络图片 url string 或本地图片 数组 */
@property (nonatomic, copy) NSArray *imageURLStringsGroup;

/** 每张图片对应要显示的文字数组 */
@property (nonatomic, copy) NSArray *titlesGroup;



#pragma mark ________________  滚动控制API  ________________

/** 自动滚动间隔时间,默认2s */
@property (nonatomic, assign) CGFloat autoScrollTimeInterval;

/** 是否无限循环,默认Yes */
@property (nonatomic,assign) BOOL infiniteLoop;

/** 是否自动滚动,默认Yes */
@property (nonatomic,assign) BOOL autoScroll;

/** 图片滚动方向，默认为水平滚动 */
@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirection;

@property (nonatomic, weak) id<LLBannerScrollViewDelegate> delegate;

/** block方式监听点击 */
@property (nonatomic, copy) void (^bannerItemOperationBlock) (NSInteger currentIndex);

#pragma mark ________________  自定义样式API  ________________

/** 轮播图片的ContentMode，默认为 UIViewContentModeScaleToFill */
@property (nonatomic, assign) UIViewContentMode bannerImageViewContentMode;

/** 占位图，用于网络未加载到图片时 */
@property (nonatomic, strong) UIImage *placeholderImage;

/** 是否显示分页控件 */
@property (nonatomic, assign) BOOL showPageControl;

/** 是否在只有一张图时隐藏pagecontrol，默认为YES */
@property(nonatomic) BOOL hidesForSinglePage;

/** 分页控件位置 */
@property (nonatomic, assign) LLBannerScrollViewPageContolAliment pageControlAliment;

/** 分页控件距离轮播图的底部间距（在默认间距基础上）的偏移量 */
@property (nonatomic, assign) CGFloat pageControlBottomOffset;

/** 分页控件距离轮播图的右边间距（在默认间距基础上）的偏移量 */
@property (nonatomic, assign) CGFloat pageControlRightOffset;

/** 当前分页控件小圆标颜色 */
@property (nonatomic, strong) UIColor *currentPageColor;

/** 其他分页控件小圆标颜色 */
@property (nonatomic, strong) UIColor *otherPageColor;

/** 分页控件小圆标大小 */
@property (nonatomic, assign) CGSize pageControlSize;

/** 当前分页控件小圆标图片 */
@property (nonatomic, strong) UIImage *currentPageImage;

/** 其他分页控件小圆标图片 */
@property (nonatomic, strong) UIImage *otherpageImage;

/** 轮播文字label字体颜色 */
@property (nonatomic, strong) UIColor *titleLabelTextColor;

/** 轮播文字label字体大小 */
@property (nonatomic, strong) UIFont  *titleLabelTextFont;

/** 轮播文字label背景颜色 */
@property (nonatomic, strong) UIColor *titleLabelBackgroundColor;

/** 轮播文字label高度 */
@property (nonatomic, assign) CGFloat titleLabelHeight;

/** 轮播文字label对齐方式 */
@property (nonatomic, assign) NSTextAlignment titleLabelTextAlignment;

/** 滚动手势禁用（文字轮播较实用） */
- (void)disableScrollGesture;

/** 清除图片缓存（此次升级后统一使用SDWebImage管理图片加载和缓存）  */
- (void)clearImagesCache;
@end
