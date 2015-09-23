//
//  KCContactViewController.h
//  系统方法
//
//  Created by 姚天成 on 15/9/23.
//  Copyright © 2015年 姚天成. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  定义一个协议作为代理
 */
@protocol KCContactDelegate
//新增或修改联系人
-(void)editPersonWithFirstName:(NSString *)firstName lastName:(NSString *)lastName workNumber:(NSString *)workNumber;
//取消修改或新增
-(void)cancelEdit;
@end
@interface KCContactTableViewController : UITableViewController

@end
