//
//  LLCollectionViewCell.h
//  LLBannerView
//
//  Created by 嘚嘚以嘚嘚 on 2018/5/29.
//  Copyright © 2018年 嘚嘚以嘚嘚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LLCollectionViewCell : UICollectionViewCell
@property (nonatomic, copy)NSString * imagePath;
@property (nonatomic, copy)NSString * title;


@property (nonatomic, strong) UIColor *titleLabelTextColor;
@property (nonatomic, strong) UIFont *titleLabelTextFont;
@property (nonatomic, strong) UIColor *titleLabelBackgroundColor;
@property (nonatomic, assign) CGFloat titleLabelHeight;
@property (nonatomic, assign) NSTextAlignment titleLabelTextAlignment;
@property (nonatomic, strong) UIImage *placeholderImage;
@property (nonatomic, assign) UIViewContentMode bannerImageViewContentMode;

@end
