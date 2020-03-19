//
//  LLCollectionViewCell.m
//  LLBannerView
//
//  Created by 嘚嘚以嘚嘚 on 2018/5/29.
//  Copyright © 2018年 嘚嘚以嘚嘚. All rights reserved.
//

#import "LLCollectionViewCell.h"
#import "UIView+Frame.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import <UIImage+GIF.h>
@interface LLCollectionViewCell ()
@property (nonatomic, strong)UIImageView * imageView;
@property (nonatomic, strong)UILabel * titleLabel;
@end

@implementation LLCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUpImageView];
        [self setUpTitleLabel];
        

//        _concurrentQueue =dispatch_queue_create("www.test.com", DISPATCH_QUEUE_CONCURRENT);

    }
    return self;
}
- (void)setUpImageView
{
    self.imageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.imageView];
}
- (void)setUpTitleLabel
{
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];;
    self.titleLabelHeight = 30;
    self.titleLabel.hidden = YES;
    [self.contentView addSubview:self.titleLabel];
}
- (void)setTitle:(NSString *)title
{
    _title = [title copy];
    _titleLabel.text = [NSString stringWithFormat:@"   %@", title];
    if (_titleLabel.hidden) {
        _titleLabel.hidden = NO;
    }
}
-(void)setImagePath:(NSString *)imagePath{
    _imagePath = [imagePath copy];
    if ([imagePath isKindOfClass:[NSString class]]) {
        if ([imagePath hasPrefix:@"http"]) {
            if ([imagePath hasSuffix:@".gif"]) {
                
               __block NSData * data = nil;
                data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imagePath]];
    
                _imageView.image = [UIImage sd_animatedGIFWithData:data];
            }else{
                
                [_imageView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:_placeholderImage];
            }
        }else{

                UIImage * image = [UIImage imageNamed:imagePath];
                if (!image) {
                    image = [UIImage imageWithContentsOfFile:imagePath];
                }
                _imageView.image = image;
          
        }
    }else if ([imagePath isKindOfClass:[UIImage class]]){
        _imageView.image = (UIImage *)imagePath;
    }
    
}

-(void)setBannerImageViewContentMode:(UIViewContentMode)bannerImageViewContentMode
{
    _bannerImageViewContentMode = bannerImageViewContentMode;
    if (bannerImageViewContentMode) {
        self.imageView.contentMode = self.bannerImageViewContentMode;        
    }
}
-(void)setPlaceholderImage:(UIImage *)placeholderImage{
    _placeholderImage = placeholderImage;
}
- (void)setTitleLabelBackgroundColor:(UIColor *)titleLabelBackgroundColor
{
    _titleLabelBackgroundColor = titleLabelBackgroundColor;
    if (titleLabelBackgroundColor) {
        _titleLabel.backgroundColor = titleLabelBackgroundColor;
    }
}

- (void)setTitleLabelTextColor:(UIColor *)titleLabelTextColor
{
    _titleLabelTextColor = titleLabelTextColor;
    if (titleLabelTextColor) {
        _titleLabel.textColor = titleLabelTextColor;
    }
}

- (void)setTitleLabelTextFont:(UIFont *)titleLabelTextFont
{
    _titleLabelTextFont = titleLabelTextFont;
    if (titleLabelTextFont) {
        _titleLabel.font = titleLabelTextFont;
    }
}
-(void)setTitleLabelTextAlignment:(NSTextAlignment)titleLabelTextAlignment
{
    _titleLabelTextAlignment = titleLabelTextAlignment;
    if (titleLabelTextAlignment) {
        _titleLabel.textAlignment = titleLabelTextAlignment;
    }
}
-(void)setTitleLabelHeight:(CGFloat)titleLabelHeight{
    if (titleLabelHeight) {
        _titleLabelHeight = titleLabelHeight;        
    }
}
-(void)layoutSubviews{
    self.imageView.frame = self.bounds;
    self.titleLabel.frame = CGRectMake(0, self.ll_height-self.titleLabelHeight, self.ll_width, self.titleLabelHeight);
}
@end
