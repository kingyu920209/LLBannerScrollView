//
//  ViewController.m
//  LLBannerView
//
//  Created by 嘚嘚以嘚嘚 on 2018/5/29.
//  Copyright © 2018年 嘚嘚以嘚嘚. All rights reserved.
//

#import "ViewController.h"
#import "LLBannerScrollView.h"
@interface ViewController ()<LLBannerScrollViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *imagesURLStrings = @[
                                  @"http://photo.l99.com/source/11/1330351552722_cxn26e.gif",
                                  @"http://5b0988e595225.cdn.sohucs.com/images/20171001/24c768544bf74fc7880624412929de3a.jpeg",
                                  @"http://b.hiphotos.baidu.com/zhidao/pic/item/d01373f082025aafbd279e23f9edab64024f1ac4.jpg",
                                  @"http://photo.l99.com/bigger/10/1375583044819_555bsn.png",

                                  @"http://photo.l99.com/source/11/1330351552722_cxn26e.gif",
                                  @"http://s22.mogucdn.com/p1/151212/2173om_ie4wiyzrmmydczbwguzdambqgqyde_748x997.jpg_750x999.jpg",
                                  @"2.gif"
                           
                                  ];
    
    NSArray *titles = @[@"12",
                        @"2",
                        @"2323",
                        @"4343",
                        @"3",
                        @"如果代码在使用过程中出现问题",
                        @"您可以发邮件到kingyu920209@126.com"
                        ];
    CGFloat w = self.view.bounds.size.width;

    LLBannerScrollView * bannerScrollView = [LLBannerScrollView bannerScrollViewWithFrame:CGRectMake(0, 280, w, 280) delegate:self placeholderImage:nil];
    [self.view addSubview:bannerScrollView];
    
    bannerScrollView.imageURLStringsGroup = imagesURLStrings;
    bannerScrollView.titlesGroup = titles;
    bannerScrollView.titleLabelTextColor = [UIColor yellowColor];
    bannerScrollView.titleLabelTextAlignment = NSTextAlignmentCenter;
    bannerScrollView.bannerItemOperationBlock = ^(NSInteger currentIndex) {
        NSLog(@"block,index=%ld",(long)currentIndex);
    };

//    self.view.frame
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)bannerScrollView:(LLBannerScrollView *)bannerScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"delegate,index=%ld",(long)index);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
