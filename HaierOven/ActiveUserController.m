//
//  ActiveUserController.m
//  HaierOven
//
//  Created by 刘康 on 15/1/21.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "ActiveUserController.h"

@interface ActiveUserController ()
{
    NSInteger _secondsCount;
}


@property (weak, nonatomic) IBOutlet UIView *textfieldContainerView;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *getVefifyCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@property (strong, nonatomic) UILabel* countLabel;

@property (copy, nonatomic) NSString* transactionId;

@end

@implementation ActiveUserController



//重新获得验证码：
//http://103.8.220.166:40000/commonapp/uvcs
//
//{
//    "loginName":"13611609561",
//    "validateType":1,
//    "validateScene":1,
//    "sendTo":"13611609561",
//    "accType":0
//}

//第三方补充信息：
//url:app/user/addthird
//参数格式：
//{"userBaseID":25,"passWord":"","email":"cjsyclt@163.com","mobile":"13621640580","userProfile":{"nickName":"cjsyclt","userName":"litao"}}

#pragma mark - 视图加载和初始化

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
}

- (void)setupSubviews
{
    self.textfieldContainerView.layer.borderColor = GlobalOrangeColor.CGColor;
    self.textfieldContainerView.layer.borderWidth = 1.0f;
    self.getVefifyCodeButton.layer.masksToBounds = YES;
    self.getVefifyCodeButton.layer.cornerRadius = 8;
    self.confirmButton.layer.masksToBounds = YES;
    self.confirmButton.layer.cornerRadius = 10;
    
    _countLabel = [[UILabel alloc] init];
    _countLabel.font = self.getVefifyCodeButton.titleLabel.font;
    _countLabel.textColor = self.getVefifyCodeButton.titleLabel.textColor;
    [self.view addSubview:_countLabel];
    _countLabel.backgroundColor = self.getVefifyCodeButton.backgroundColor;
    _countLabel.layer.masksToBounds = YES;
    _countLabel.layer.cornerRadius = 10;
    _countLabel.hidden = YES;
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    _countLabel.frame = self.getVefifyCodeButton.frame;
    
}

#pragma mark - 按钮响应事件

- (IBAction)getVerifyCodeTapped:(UIButton *)sender
{
    
    [self getVerifyCode];
    
    _secondsCount = 60;
    [self countDown];
    
    
}

- (IBAction)ActiveTapped:(UIButton *)sender
{
    
    [self checkVerifyCode];
    
}

#pragma mark - 倒计时

- (void)countDown
{
     _secondsCount --;
    _countLabel.text = [NSString stringWithFormat:@"%d秒后重新获取", _secondsCount];
    if (_secondsCount == 0) {
        self.getVefifyCodeButton.hidden = NO;
        self.countLabel.hidden = YES;
        return;
    } else {
        [self performSelector:@selector(countDown) withObject:nil afterDelay:1];
        self.getVefifyCodeButton.hidden = YES;
        self.countLabel.hidden = NO;
    }
   
}

#pragma mark - 获取验证码

- (void)getVerifyCode
{
    ValidateType validateType;
    if ([MyTool validateEmail:self.activeMethod]) {
        validateType = ValidateTypeEmail;
    } else if ([MyTool validateTelephone:self.activeMethod]) {
        validateType = ValidateTypePhone;
    } else {
        validateType = ValidateTypePhone;
    }
    
    [[InternetManager sharedManager] getVerCodeWithLoginName:self.activeMethod
                                             andValidateType:validateType
                                            andValidateScene:ValidateSceneActiveUser
                                                  andAccType:self.accType
                                                    callBack:^(BOOL success, id obj, NSError *error) {
                                                        NSDictionary* responseDict = obj;
                                                        if (!success) {
                                                            [super showProgressErrorWithLabelText:responseDict[@"retInfo"] afterDelay:1];
                                                        } else {
                                                            
                                                            self.transactionId = responseDict[@"transactionId"];
                                                        }
                                                        
                                                    }];
    
}

#pragma mark - 校验验证码

- (void)checkVerifyCode
{
    if (self.verifyCodeTextField.text.length == 0) {
        [super showProgressErrorWithLabelText:@"请输入验证码" afterDelay:1];
        return;
    }
    
    if (self.transactionId == nil) {
        self.transactionId = @"";
    }
    
    ValidateType validateType;
    if ([MyTool validateEmail:self.activeMethod]) {
        validateType = ValidateTypeEmail;
    } else if ([MyTool validateTelephone:self.activeMethod]) {
        validateType = ValidateTypePhone;
    } else {
        validateType = ValidateTypePhone;
    }
    
    [[InternetManager sharedManager] activateUserWithLoginName:self.activeMethod
                                               andValidateType:validateType
                                              andValidateScene:ValidateSceneActiveUser
                                                    andAccType:self.accType
                                              andTransactionId:self.transactionId
                                                        andUvc:self.verifyCodeTextField.text
                                                      callBack:^(BOOL success, id obj, NSError *error) {
                                                          
                                                          if (success) {
                                                              if (self.registerFlag) {
                                                                  [self login];
                                                              } else { // 如果是其他页面跳进来激活则返回
                                                                  
                                                                  // 激活用户送积分
                                                                  [[InternetManager sharedManager] addPoints:ActiveUserScore userBaseId:CurrentUserBaseId callBack:^(BOOL success, id obj, NSError *error) {
                                                                      
                                                                      if (success) {
                                                                          NSLog(@"激活用户送积分OK");
                                                                      }
                                                                      [self.navigationController popViewControllerAnimated:YES];
                                                                  }];
                                                                  
                                                              }
                                                          } else {
                                                              [super showProgressErrorWithLabelText:@"激活失败，请重试" afterDelay:1];
                                                          }
                                                    
                                                          
                                                      }];
    
}


#pragma mark - 登录

- (void)login
{
    LoginType loginType;
    if ([MyTool validateEmail:self.activeMethod]) {
        loginType = LoginTypeEmail;
    } else {
        loginType = LoginTypeMobile;
    }
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddhhmmss";
    NSString* sequence = [formatter stringFromDate:[NSDate date]];
    sequence = [sequence stringByReplacingOccurrencesOfString:@":" withString:@""];
    
    [super showProgressHUDWithLabelText:@"请稍候" dimBackground:NO];
    
    [[InternetManager sharedManager] loginWithSequenceId:sequence
                                              andAccType:AccTypeHaier
                                              andloginId:self.activeMethod
                                             andPassword:self.password
                                      andThirdpartyAppId:nil
                                andThirdpartyAccessToken:nil
                                            andLoginType:loginType
                                                callBack:^(BOOL success, id obj, NSError *error) {
                                                    [super hiddenProgressHUD];
                                                    if (success) {
                                                        NSLog(@"登录成功");
                                                        
                                                        // 激活用户送积分
                                                        [[InternetManager sharedManager] addPoints:ActiveUserScore userBaseId:CurrentUserBaseId callBack:^(BOOL success, id obj, NSError *error) {
                                                            
                                                            if (success) {
                                                                NSLog(@"激活用户送积分OK");
                                                            }
                                                            
                                                            [super showProgressCompleteWithLabelText:@"登录成功" afterDelay:1];
                                                            [[NSNotificationCenter defaultCenter] postNotificationName:LoginSuccussNotification object:nil];
                                                            
                                                        }];
                                                        
                                                        
                                                    } else {
                                                        [super showProgressErrorWithLabelText:@"登录失败" afterDelay:1];
                                                    }
                                                    
                                                    
                                                }];
    
    
}


@end










