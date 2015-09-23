//
//  IDID.m
//  系统方法
//
//  Created by 姚天成 on 15/9/23.
//  Copyright © 2015年 姚天成. All rights reserved.
//

#import "IDID.h"
#import <iAd/iAd.h>

@interface IDID ()<ADBannerViewDelegate>
@property (weak, nonatomic) IBOutlet ADBannerView *advertiseBanner;//广告展示视图

@end

@implementation IDID

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置代理
    self.advertiseBanner.delegate=self;
}

#pragma mark - ADBannerView代理方法
//广告加载完成
-(void)bannerViewDidLoadAd:(ADBannerView *)banner{
    NSLog(@"广告加载完成.");
}
//点击Banner后离开之前，返回NO则不会展开全屏广告
-(BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave{
    NSLog(@"点击Banner后离开之前.");
    return YES;
}
//点击banner后全屏显示，关闭后调用
-(void)bannerViewActionDidFinish:(ADBannerView *)banner{
    NSLog(@"广告已关闭.");
}
//获取广告失败
-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    NSLog(@"加载广告失败.");
    self.advertiseBanner.hidden=YES;
}

@end
