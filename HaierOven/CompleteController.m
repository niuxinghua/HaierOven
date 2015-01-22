//
//  CompleteController.m
//  HaierOven
//
//  Created by 刘康 on 15/1/22.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "CompleteController.h"

@interface CompleteController () <UITextFieldDelegate>


@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *textfieldContainers;

@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *textFields;

@property (weak, nonatomic) IBOutlet UITextField *phoneTextfield;

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@property (weak, nonatomic) IBOutlet UITextField *userNameTextfield;

@property (weak, nonatomic) IBOutlet UITextField *nickNameTextfield;

@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@end

@implementation CompleteController

#pragma mark - 视图加载和初始化

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubviews];
    
    
}

- (void)setupSubviews
{
    for (UIView* view in self.textfieldContainers) {
        view.layer.borderColor = GlobalOrangeColor.CGColor;
        view.layer.borderWidth = 1.0f;
    }
    _confirmButton.layer.masksToBounds = YES;
    _confirmButton.layer.cornerRadius = 10;
}

#pragma mark - UITextFieldDelegate

- (IBAction)textFiledEndOnExit:(UITextField *)sender
{
    switch (sender.tag) {
        case 0:
        {
            if ([MyTool validateTelephone:sender.text]) {
                [self.textFields[1] becomeFirstResponder];
            } else {
                [super showProgressErrorWithLabelText:@"请输入正确的手机号" afterDelay:1];
            }
            break;
        }
        case 1:
        {
            if ([MyTool validateEmail:sender.text]) {
                [self.textFields[2] becomeFirstResponder];
            } else {
                [super showProgressErrorWithLabelText:@"请输入正确的邮箱" afterDelay:1];
            }
            break;
        }
        case 2:
        {
            if (sender.text.length > 0 && sender.text.length < 15) {
                [self.textFields[3] becomeFirstResponder];
            } else {
                [super showProgressErrorWithLabelText:@"请输入正确的姓名" afterDelay:1];
            }
            break;
        }
        case 3:
        {
            if (sender.text.length > 0 && sender.text.length < 15) {
                [self.textFields[3] resignFirstResponder];
                
            } else {
                [super showProgressErrorWithLabelText:@"请输入正确的昵称" afterDelay:1];
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark - 检查合法

- (BOOL)validInputs
{
    if (self.phoneTextfield.text.length == 0 && self.emailTextField.text.length == 0) {
        [super showProgressErrorWithLabelText:@"手机和邮箱必须填一个" afterDelay:1];
        return NO;
    }
    if (self.phoneTextfield.text.length > 0 && ![MyTool validateTelephone:self.phoneTextfield.text]) {
        [super showProgressErrorWithLabelText:@"请输入正确的手机号" afterDelay:1];
        return NO;
    }
    
//    NSString *regex = @"^[0-9a-zA-Z._!]{1}([a-zA-Z0-9]|[._!-@?]){5,16}$"; //只能输入5-20个以字母数字开头、可带数字、“_”、“.”、“!”、“@”、“?”的字串，长度为5-16
//    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
//    if (![predicate evaluateWithObject:password]) {
//        
//        return NO;
//    }
    
    
    return YES;
}

#pragma mark - 按钮

- (IBAction)confirmTapped:(UIButton *)sender {
    if ([self validInputs]) {
        [self completThirdParty];
    }
}

#pragma mark - 请求发送

- (void)completThirdParty
{
    [super showProgressHUDWithLabelText:@"请稍候..." dimBackground:NO];
    [[InternetManager sharedManager] completeThirdPartyWithPassword:self.loginId
                                                              phone:self.phoneTextfield.text
                                                              email:self.emailTextField.text
                                                           userName:self.userNameTextfield.text
                                                           nickName:self.nickNameTextfield.text
                                                           callBack:^(BOOL success, id obj, NSError *error) {
                                                               [super hiddenProgressHUD];
                                                               if (success) {
                                                                   
                                                                   [[NSNotificationCenter defaultCenter] postNotificationName:LoginSuccussNotification object:nil];
                                                                   
                                                               } else {
                                                                   [super showProgressErrorWithLabelText:@"修改失败" afterDelay:1];
                                                               }
        
    }];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
