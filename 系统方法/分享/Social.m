//
//  Social.m
//  系统方法
//
//  Created by 姚天成 on 15/9/23.
//  Copyright © 2015年 姚天成. All rights reserved.
//

#import "Social.h"

#import <Social/Social.h>

@interface Social ()

@end

@implementation Social

#pragma mark - 控制器视图事件
- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - UI事件
- (IBAction)shareClick:(UIButton *)sender {
    [self shareToSina];
}


#pragma mark - 私有方法
-(void)shareToSina{
    //检查新浪微博服务是否可用
    if(![SLComposeViewController isAvailableForServiceType:SLServiceTypeSinaWeibo]){
        NSLog(@"新浪微博服务不可用.");
        return;
    }
    //初始化内容编写控制器，注意这里指定分享类型为新浪微博
    SLComposeViewController *composeController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeSinaWeibo];
    //设置默认信息
    [composeController setInitialText:@"测试微博"];
    //添加图片
    [composeController addImage:[UIImage imageNamed:@"123.jpg"]];
    //添加连接
    [composeController addURL:[NSURL URLWithString:@"http://www.baidu.com"]];
    //设置发送完成后的回调事件
    __block SLComposeViewController *composeControllerForBlock = composeController;
    composeController.completionHandler=^(SLComposeViewControllerResult result){
        
        if (result == SLComposeViewControllerResultDone) {
            NSLog(@"开始发送...");
        }
        
        [composeControllerForBlock dismissViewControllerAnimated:YES completion:nil];
    };
    //显示编辑视图
    [self presentViewController:composeController animated:YES completion:nil];
}

@end
