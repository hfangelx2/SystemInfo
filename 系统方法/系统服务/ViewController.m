//
//  ViewController.m
//  系统方法
//
//  Created by 姚天成 on 15/9/22.
//  Copyright © 2015年 姚天成. All rights reserved.
//

#import "ViewController.h"
#import <MessageUI/MessageUI.h>

@interface ViewController ()<MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate>
/**
 * 收件人
 */
@property (strong, nonatomic)  UITextField *toTecipients;
/**
 * 抄送人
 */
@property (strong, nonatomic)  UITextField *ccRecipients;
/**
 * 密送人
 */
@property (strong, nonatomic)  UITextField *bccRecipients;
/**
 * 主题
 */
@property (strong, nonatomic)  UITextField *subject;
/**
 * 正文
 */
@property (strong, nonatomic)  UITextField *body;
/**
 * 附件
 */
@property (strong, nonatomic)  UITextField *attachments;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSLog(@"11111111111");
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        NSLog(@"22222222222");
//    });
//    
//    NSLog(@"33333333333");
}
//拨打电话
- (IBAction)call {
    
    NSString *str = @"18609889095";
    //这种会弹出提示框 提示用户是否拨打
    NSString *phone = [NSString stringWithFormat:@"telprompt://%@",str];
    //这种会直接拨打电话， 不会提示用户
    //    NSString *phone = [NSString stringWithFormat:@"tel:%@",str];

    [self openUrl:phone];
    
}
//短信
- (IBAction)SMS {
#pragma mark - 普通调用
//    NSString *number = @"18609889095";
//    
//    NSString *phone = [NSString stringWithFormat:@"sms:%@",number];
//    
//    [self openUrl:phone];
#pragma mark - 程序内调用
    NSArray *array = @[@"18609889095",@"18609889096"];
    
    [self sendSMS:@"你是谁" recipientList:array];
    
}
//邮件
- (IBAction)Email {
#pragma mark - 普通跳转调用
//    NSString *mailAddress = @"jack_yao_work@163.com";
//    NSString *url=[NSString stringWithFormat:@"mailto://%@",mailAddress];
//    [self openUrl:url];
#pragma mark - 程序内调用
    [self sendEmail];
}
//网页
- (IBAction)web {
    
    NSString *url=@"http://www.baidu.com";
    [self openUrl:url];
    
}

-(void)sendEmail{
    //判断当前是否能够发送邮件
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc]init];
        //设置代理，注意这里不是delegate，而是mailComposeDelegate
        mailController.mailComposeDelegate = self;
        //设置收件人
        [mailController setToRecipients:[self.toTecipients.text componentsSeparatedByString:@","]];
        //设置抄送人
        if (self.ccRecipients.text.length > 0) {
            [mailController setCcRecipients:[self.ccRecipients.text componentsSeparatedByString:@","]];
        }
        //设置密送人
        if (self.bccRecipients.text.length > 0) {
            [mailController setBccRecipients:[self.bccRecipients.text componentsSeparatedByString:@","]];
        }
        //设置主题
        [mailController setSubject:self.subject.text];
        //设置内容
        [mailController setMessageBody:self.body.text isHTML:YES];
        //添加附件
        if (self.attachments.text.length > 0) {
            NSArray *attachments = [self.attachments.text componentsSeparatedByString:@","] ;
            [attachments enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSString *file = [[NSBundle mainBundle] pathForResource:obj ofType:nil];
                NSData *data = [NSData dataWithContentsOfFile:file];
                [mailController addAttachmentData:data mimeType:@"image/jpeg" fileName:obj];//第二个参数是mimeType类型，jpg图片对应image/jpeg
            }];
        }
        [self presentViewController:mailController animated:YES completion:nil];
        
    }
}

#pragma mark - MFMailComposeViewController代理方法
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    switch (result) {
        case MFMailComposeResultSent:
            NSLog(@"发送成功.");
            break;
        case MFMailComposeResultSaved://如果存储为草稿（点取消会提示是否存储为草稿，存储后可以到系统邮件应用的对应草稿箱找到）
            NSLog(@"邮件已保存.");
            break;
        case MFMailComposeResultCancelled:
            NSLog(@"取消发送.");
            break;
            
        default:
            NSLog(@"发送失败.");
            break;
    }
    if (error) {
        NSLog(@"发送邮件过程中发生错误，错误信息：%@",error.localizedDescription);
    }
    [self dismissViewControllerAnimated:YES completion:nil];

}

/**需导入MessageUI/MessageUI.h
 * bodyOfMessage 短信内容
 * recipients 收件人电话数组（可多人）
 */
- (void)sendSMS:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients
{
    
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
//    bodyOfMessage = @"你是谁";
    if([MFMessageComposeViewController canSendText])
        
    {
        //预设短信内容
        controller.body = bodyOfMessage;
        //收件人列表
        controller.recipients = recipients;
        //代理
        controller.messageComposeDelegate = self;
        //modal出来页面
        [self presentViewController:controller animated:YES completion:^{
            
            
        }];
        
    }
    
}

// 处理发送完的响应结果
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:^{
        
        
    }];
    
    if (result == MessageComposeResultCancelled)
            NSLog(@"Message cancelled");
        else if (result == MessageComposeResultSent)
            NSLog(@"Message sent") ;
        else
            NSLog(@"Message failed");
}


#pragma mark - 私有方法
-(void)openUrl:(NSString *)urlStr{
    //注意url中包含协议名称，iOS根据协议确定调用哪个应用，例如发送邮件是“sms://”其中“//”可以省略写成“sms:”(其他协议也是如此)
    NSURL *url = [NSURL URLWithString:urlStr];
    UIApplication *application = [UIApplication sharedApplication];
    if(![application canOpenURL:url]){
        NSLog(@"无法打开\"%@\"，请确保此应用已经正确安装.",url);
        return;
    }
    [[UIApplication sharedApplication] openURL:url];
}

@end
