//
//  KCAddPersonViewController.h
//  系统方法
//
//  Created by 姚天成 on 15/9/23.
//  Copyright © 2015年 姚天成. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KCContactDelegate;

@interface KCAddPersonViewController : UIViewController

@property (assign,nonatomic) int recordID;//通讯录记录id，如果ID不为0则代表修改否则认为是新增
@property (strong,nonatomic) NSString *firstNameText;
@property (strong,nonatomic) NSString *lastNameText;
@property (strong,nonatomic) NSString *workPhoneText;

@property (strong,nonatomic) id<KCContactDelegate> delegate;

@end
