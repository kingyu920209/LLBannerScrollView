//
//  UIView+Frame.m
//  LLBannerView
//
//  Created by 嘚嘚以嘚嘚 on 2018/5/29.
//  Copyright © 2018年 嘚嘚以嘚嘚. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)
-(void)setLl_x:(CGFloat)ll_x
{
    CGRect temp = self.frame;
    temp.origin.x = ll_x;
    self.frame = temp;
}
-(CGFloat)ll_x
{
    return self.frame.origin.x;
}
-(void)setLl_y:(CGFloat)ll_y
{
    CGRect temp = self.frame;
    temp.origin.y = ll_y;
    self.frame = temp;
}
-(CGFloat)ll_y{
    return self.frame.origin.y;
}
-(void)setLl_width:(CGFloat)ll_width
{
    CGRect temp = self.frame;
    temp.size.width = ll_width;
    self.frame = temp;
}
-(CGFloat)ll_width
{
    return self.frame.size.width;
}
-(void)setLl_height:(CGFloat)ll_height
{
    CGRect temp = self.frame;
    temp.size.height = ll_height;
    self.frame = temp;
    
}
-(CGFloat)ll_height{
    return self.frame.size.height;
}
@end
