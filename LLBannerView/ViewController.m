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
                                  @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1544447047321&di=6ad7d36a74800ec9be576e7fb0cc7c20&imgtype=0&src=http%3A%2F%2Fimgsa.baidu.com%2Fexp%2Fw%3D500%2Fsign%3Db63716a2f21f3a295ac8d5cea924bce3%2Fc8177f3e6709c93d4aacb98b9d3df8dcd100546b.jpg",
                                  @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1544447047321&di=327c4981aacf52708d7c8375cda75ee4&imgtype=0&src=http%3A%2F%2Fhbimg.b0.upaiyun.com%2Fa783a4a7e97dfb09567ff069cdedce49192c02dc23b2-HgslCY_fw658",
                                  @"http://b.hiphotos.baidu.com/zhidao/pic/item/d01373f082025aafbd279e23f9edab64024f1ac4.jpg",
                                  @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1544447047321&di=6ad7d36a74800ec9be576e7fb0cc7c20&imgtype=0&src=http%3A%2F%2Fimgsa.baidu.com%2Fexp%2Fw%3D500%2Fsign%3Db63716a2f21f3a295ac8d5cea924bce3%2Fc8177f3e6709c93d4aacb98b9d3df8dcd100546b.jpg",

                                  @"http://photo.l99.com/source/11/1330351552722_cxn26e.gif",
                                  @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1544447047321&di=6ad7d36a74800ec9be576e7fb0cc7c20&imgtype=0&src=http%3A%2F%2Fimgsa.baidu.com%2Fexp%2Fw%3D500%2Fsign%3Db63716a2f21f3a295ac8d5cea924bce3%2Fc8177f3e6709c93d4aacb98b9d3df8dcd100546b.jpg",
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

    bannerScrollView.autoScroll = NO;
    bannerScrollView.scrollViewAnimation = LLBannerScrollViewAnimationCube;
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
