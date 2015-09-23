//
//  AddressViewController.m
//  系统方法
//
//  Created by 姚天成 on 15/9/23.
//  Copyright © 2015年 姚天成. All rights reserved.
//

#import "AddressViewController.h"
#import <AddressBookUI/AddressBookUI.h>

@interface AddressViewController ()<ABNewPersonViewControllerDelegate,ABUnknownPersonViewControllerDelegate,ABPeoplePickerNavigationControllerDelegate,ABPersonViewControllerDelegate>

@end

@implementation AddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - UI事件
//添加联系人
- (IBAction)addPersonClick:(UIButton *)sender {
    ABNewPersonViewController *newPersonController=[[ABNewPersonViewController alloc]init];
    //设置代理
    newPersonController.newPersonViewDelegate=self;
    //注意ABNewPersonViewController必须包装一层UINavigationController才能使用，否则不会出现取消和完成按钮，无法进行保存等操作
    UINavigationController *navigationController=[[UINavigationController alloc]initWithRootViewController:newPersonController];
    [self presentViewController:navigationController animated:YES completion:nil];
}
//
- (IBAction)unknownPersonClick:(UIButton *)sender {
    ABUnknownPersonViewController *unknownPersonController=[[ABUnknownPersonViewController alloc]init];
    //设置未知人员
    ABRecordRef recordRef=ABPersonCreate();
    ABRecordSetValue(recordRef, kABPersonFirstNameProperty, @"Kenshin", NULL);
    ABRecordSetValue(recordRef, kABPersonLastNameProperty, @"Cui", NULL);
    ABMultiValueRef multiValueRef=ABMultiValueCreateMutable(kABStringPropertyType);
    ABMultiValueAddValueAndLabel(multiValueRef, @"18500138888", kABHomeLabel, NULL);
    ABRecordSetValue(recordRef, kABPersonPhoneProperty, multiValueRef, NULL);
    unknownPersonController.displayedPerson=recordRef;
    //设置代理
    unknownPersonController.unknownPersonViewDelegate=self;
    //设置其他属性
    unknownPersonController.allowsActions=YES;//显示标准操作按钮
    unknownPersonController.allowsAddingToAddressBook=YES;//是否允许将联系人添加到地址簿
    
    CFRelease(multiValueRef);
    CFRelease(recordRef);
    //使用导航控制器包装
    UINavigationController *navigationController=[[UINavigationController alloc]initWithRootViewController:unknownPersonController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (IBAction)showPersonClick:(UIButton *)sender {
    ABPersonViewController *personController=[[ABPersonViewController alloc]init];
    //设置联系人
    ABAddressBookRef addressBook=ABAddressBookCreateWithOptions(NULL, NULL);
    ABRecordRef recordRef= ABAddressBookGetPersonWithRecordID(addressBook, 1);//取得id为1的联系人记录
    personController.displayedPerson=recordRef;
    //设置代理
    personController.personViewDelegate=self;
    //设置其他属性
    personController.allowsActions=YES;//是否显示发送信息、共享联系人等按钮
    personController.allowsEditing=YES;//允许编辑
    //    personController.displayedProperties=@[@(kABPersonFirstNameProperty),@(kABPersonLastNameProperty)];//显示的联系人属性信息,默认显示所有信息
    
    //使用导航控制器包装
    UINavigationController *navigationController=[[UINavigationController alloc]initWithRootViewController:personController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (IBAction)selectPersonClick:(UIButton *)sender {
    ABPeoplePickerNavigationController *peoplePickerController=[[ABPeoplePickerNavigationController alloc]init];
    //设置代理
    peoplePickerController.peoplePickerDelegate=self;
    [self presentViewController:peoplePickerController animated:YES completion:nil];
}

#pragma mark - ABNewPersonViewController代理方法
//完成新增（点击取消和完成按钮时调用）,注意这里不用做实际的通讯录增加工作，此代理方法调用时已经完成新增，当保存成功的时候参数中得person会返回保存的记录，如果点击取消person为NULL
-(void)newPersonViewController:(ABNewPersonViewController *)newPersonView didCompleteWithNewPerson:(ABRecordRef)person{
    //如果有联系人信息
    if (person) {
        NSLog(@"%@ 信息保存成功.",(__bridge NSString *)(ABRecordCopyCompositeName(person)));
    }else{
        NSLog(@"点击了取消.");
    }
    //关闭模态视图窗口
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
#pragma mark - ABUnknownPersonViewController代理方法
//保存未知联系人时触发
-(void)unknownPersonViewController:(ABUnknownPersonViewController *)unknownCardViewController didResolveToPerson:(ABRecordRef)person{
    if (person) {
        NSLog(@"%@ 信息保存成功！",(__bridge NSString *)(ABRecordCopyCompositeName(person)));
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
//选择一个人员属性后触发，返回值YES表示触发默认行为操作，否则执行代理中自定义的操作
-(BOOL)unknownPersonViewController:(ABUnknownPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    if (person) {
        NSLog(@"选择了属性：%i，值：%@.",property,(__bridge NSString *)ABRecordCopyValue(person, property));
    }
    return NO;
}
#pragma mark - ABPersonViewController代理方法
//选择一个人员属性后触发，返回值YES表示触发默认行为操作，否则执行代理中自定义的操作
-(BOOL)personViewController:(ABPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    if (person) {
        NSLog(@"选择了属性：%i，值：%@.",property,(__bridge NSString *)ABRecordCopyValue(person, property));
    }
    return NO;
}
#pragma mark - ABPeoplePickerNavigationController代理方法
//选择一个联系人后，注意这个代理方法实现后属性选择的方法将不会再调用
-(void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person{
    if (person) {
        NSLog(@"选择了%@.",(__bridge NSString *)(ABRecordCopyCompositeName(person)));
    }
}
//选择属性之后，注意如果上面的代理方法实现后此方法不会被调用
//-(void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
//    if (person && property) {
//        NSLog(@"选择了属性：%i，值：%@.",property,(__bridge NSString *)ABRecordCopyValue(person, property));
//    }
//}
//点击取消按钮
-(void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
    NSLog(@"取消选择.");
}
@end
