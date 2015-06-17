//
//  LoginViewController.m
//  HaierOven
//
//  Created by dongl on 15/1/4.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "RootViewController.h"
#import "WebViewController.h"
#import "CompleteController.h"

@interface LoginViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *textborder;
@property (strong, nonatomic) IBOutlet UIButton *loginBtn;
@property (strong, nonatomic) IBOutlet UITextField *userNameTextFailed;
@property (strong, nonatomic) IBOutlet UITextField *psdTextfailed;

@property (weak, nonatomic) IBOutlet UIButton *qqLoginButton;

/**
 *  第三方登录时的loginId, 若是第一次授权登录，补全信息需要此值作为password
 */
@property (copy, nonatomic) NSString* loginId;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    // This screen name value will remain set on the tracker and sent with hits until it is set to a new value or to nil.
//    [[GAI sharedInstance].defaultTracker set:kGAIScreenName value:@"登录页面"];
//    [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createAppView] build]];
    
    if (self.navigationController.viewControllers.count == 1) {
        UIButton* leftButton = [[UIButton alloc] init];

        [leftButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [super setLeftBarButtonItemWithImageName:@"back.png" andTitle:nil andCustomView:leftButton];
        
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismiss) name:LoginSuccussNotification object:nil];
    
    if (![QQApi isQQInstalled]) {
        self.qqLoginButton.hidden = YES;
    }
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)turnLeftMenu
{
    [self.sideMenuViewController presentLeftMenuViewController];
}

- (void)close
{
    [self dismissViewControllerAnimated:YES completion:nil];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Login"     // Event category (required)
                                                          action:@"back to homepage"  // Event action (required)
                                                           label:nil          // Event label
                                                           value:nil] build]];    // Event value
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setTextborder:(NSArray *)textborder{
    _textborder = textborder;
    for (UIView *view in textborder) {
        view.layer.borderColor = GlobalOrangeColor.CGColor;
        view.layer.borderWidth = 1.0f;
    }
}
-(void)setLoginBtn:(UIButton *)loginBtn{
    _loginBtn = loginBtn;
    loginBtn.layer.masksToBounds = YES;
    loginBtn.layer.cornerRadius = 10;
}

- (IBAction)Login:(id)sender {
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Login"     // Event category (required)
                                                          action:@"login"  // Event action (required)
                                                           label:nil          // Event label
                                                           value:nil] build]];    // Event value
    
    if (![MyTool validateTelephone:self.userNameTextFailed.text]) {
        if (![MyTool validateEmail:self.userNameTextFailed.text]) {
            [super showProgressErrorWithLabelText:@"请填写正确的手机号或邮箱" afterDelay:1];
            return;
        }
    }
    
    LoginType loginType;
    if ([MyTool validateEmail:self.userNameTextFailed.text]) {
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
                                              andloginId:self.userNameTextFailed.text
                                             andPassword:self.psdTextfailed.text
                                      andThirdpartyAppId:nil
                                andThirdpartyAccessToken:nil
                                            andLoginType:loginType
                                                callBack:^(BOOL success, id obj, NSError *error) {
                                                    [super hiddenProgressHUD];
                                                    if (success) {
                                                        NSLog(@"登录成功");
                                                        [super showProgressCompleteWithLabelText:@"登录成功" afterDelay:1];
                                                        //[[NSNotificationCenter defaultCenter] postNotificationName:LoginSuccussNotification object:nil];
                                                        
                                                        //保存手动登录的时间，超过20天后，需再次手动登录
                                                        NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
                                                        [userDefaults setValue:[NSDate date] forKey:@"lastLoginTime"];
                                                        [userDefaults synchronize];
                                                        
                                                        [MobClick event:@"user_login"];
                                                        
                                                    } else {
                                                        //[super showProgressErrorWithLabelText:@"登录失败" afterDelay:1];
                                                        [super showProgressErrorWithLabelText:error.userInfo[NSLocalizedDescriptionKey] afterDelay:1];
                                                    }
                                                    
                                                    
                                                }];
    
    
}
- (IBAction)forgetPsd:(id)sender {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Login"     // Event category (required)
                                                          action:@"forget_password"  // Event action (required)
                                                           label:nil          // Event label
                                                           value:nil] build]];    // Event value
    
    WebViewController* webController = [self.storyboard instantiateViewControllerWithIdentifier:@"Web view controller"];
    webController.titleText = @"忘记密码";
    webController.webPath = ResetPasswordUrl;
    [self.navigationController pushViewController:webController animated:YES];
    
}
- (IBAction)TencentLogin:(id)sender {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Login"     // Event category (required)
                                                          action:@"qq_login"  // Event action (required)
                                                           label:nil          // Event label
                                                           value:nil] build]];    // Event value
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        NSLog(@"response is %@",response);
        [self loginWithQQ];
    });
    
//    RootViewController *root = [self.storyboard instantiateViewControllerWithIdentifier:@"RootViewController"];
//    [self presentViewController:root animated:YES completion:nil];
}


- (IBAction)SinawbLogin:(id)sender {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Login"     // Event category (required)
                                                          action:@"sinaweibo_login"  // Event action (required)
                                                           label:nil          // Event label
                                                           value:nil] build]];    // Event value
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        NSLog(@"response is %@",response);
        [self loginWithSina];
    });
    
//    RootViewController *root = [self.storyboard instantiateViewControllerWithIdentifier:@"RootViewController"];
//    [self presentViewController:root animated:YES completion:nil];
    
}
- (IBAction)Register:(id)sender {
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Login"     // Event category (required)
                                                          action:@"register"  // Event action (required)
                                                           label:nil          // Event label
                                                           value:nil] build]];    // Event value
    
    [self.userNameTextFailed resignFirstResponder];
    [self.psdTextfailed resignFirstResponder];
    RegisterViewController* reg = [self.storyboard instantiateViewControllerWithIdentifier:@"RegisterViewController"];
    [self.navigationController pushViewController:reg animated:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.userNameTextFailed resignFirstResponder];
    [self.psdTextfailed resignFirstResponder];
}

#pragma mark - QQ登录

/**
 *  QQ登录密码同QQ openid
 */
- (void)loginWithQQ
{
    [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToQQ  completion:^(UMSocialResponseEntity *response){
        NSLog(@"SnsInformation is %@",response.data);
        
        if (response.responseCode != UMSResponseCodeSuccess) {
            [super showProgressErrorWithLabelText:@"授权失败" afterDelay:1];
            return;
        }
        
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddhhmmss";
        NSString* sequence = [formatter stringFromDate:[NSDate date]];
        sequence = [sequence stringByReplacingOccurrencesOfString:@":" withString:@""];
        
        [super showProgressHUDWithLabelText:@"请稍候" dimBackground:NO];
        
        [[InternetManager sharedManager] loginWithSequenceId:sequence
                                                  andAccType:AccTypeQQ
                                                  andloginId:response.data[@"openid"]
                                                 andPassword:response.data[@"openid"]
                                          andThirdpartyAppId:QQAppID
                                    andThirdpartyAccessToken:response.data[@"access_token"]
                                                andLoginType:LoginTypeUserName
                                                    nickName:response.data[@"screen_name"]
                                                  userAvatar:response.data[@"profile_image_url"]
                                                    callBack:^(BOOL success, id obj, NSError *error) {
                                                        [super hiddenProgressHUD];
                                                        if (success) {
                                                            NSLog(@"登录成功");
                                                            
                                                            [super showProgressCompleteWithLabelText:@"登录成功" afterDelay:1];
                                                            
                                                            //保存手动登录的时间，超过20天后，需再次手动登录
                                                            NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
                                                            [userDefaults setValue:[NSDate date] forKey:@"lastLoginTime"];
                                                            [userDefaults synchronize];
                                                            
                                                            // 如果是第一次第三方登录，需补全用户信息
                                                            
                                                            self.loginId = response.data[@"openid"];
                                                            //[self performSelector:@selector(jumpToEditController) withObject:nil afterDelay:1];
                                                            
                                                            [MobClick event:@"user_login"];
                                                            
                                                        } else {
                                                            //[super showProgressErrorWithLabelText:@"登录失败" afterDelay:1];
                                                            [super showProgressErrorWithLabelText:error.userInfo[NSLocalizedDescriptionKey] afterDelay:1];
                                                        }
                                                    }];
        
//        [[InternetManager sharedManager] loginWithSequenceId:sequence
//                                                      andAccType:AccTypeQQ
//                                                      andloginId:response.data[@"openid"]
//                                                     andPassword:response.data[@"openid"]
//                                              andThirdpartyAppId:QQAppID
//                                        andThirdpartyAccessToken:response.data[@"access_token"]
//                                                    andLoginType:LoginTypeUserName
//                                                        callBack:^(BOOL success, id obj, NSError *error) {
//                                                            [super hiddenProgressHUD];
//                                                            if (success) {
//                                                                NSLog(@"登录成功");
//                                                                
//                                                                [super showProgressCompleteWithLabelText:@"登录成功" afterDelay:1];
//                                                                
//                                                                //保存手动登录的时间，超过20天后，需再次手动登录
//                                                                NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
//                                                                [userDefaults setValue:[NSDate date] forKey:@"lastLoginTime"];
//                                                                [userDefaults synchronize];
//                                                                
//                                                                 // 如果是第一次第三方登录，需补全用户信息
//                                                                
//                                                                self.loginId = response.data[@"openid"];
//                                                                //[self performSelector:@selector(jumpToEditController) withObject:nil afterDelay:1];
//
//                                                            } else {
//                                                                //[super showProgressErrorWithLabelText:@"登录失败" afterDelay:1];
//                                                                [super showProgressErrorWithLabelText:error.userInfo[NSLocalizedDescriptionKey] afterDelay:1];
//                                                            }
//                                                            
//                                                            
//                                                        }];
        
        
    }];
}

#pragma mark - 微博登录

- (void)loginWithSina
{
    [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToSina  completion:^(UMSocialResponseEntity *response){
        NSLog(@"SnsInformation is %@",response.data);
        
        if (response.responseCode != UMSResponseCodeSuccess) {
            [super showProgressErrorWithLabelText:@"授权失败" afterDelay:1];
            return;
        }
        
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddhhmmss";
        NSString* sequence = [formatter stringFromDate:[NSDate date]];
        sequence = [sequence stringByReplacingOccurrencesOfString:@":" withString:@""];
        
        if (response.data[@"uid"] == nil) {
            [super showProgressErrorWithLabelText:@"登录失败" afterDelay:1];
            return;
        }
        
        [[InternetManager sharedManager] loginWithSequenceId:sequence
                                                  andAccType:AccTypeSina
                                                  andloginId:response.data[@"uid"]
                                                 andPassword:response.data[@"uid"]
                                          andThirdpartyAppId:SinaAppKey
                                    andThirdpartyAccessToken:response.data[@"access_token"]
                                                andLoginType:LoginTypeUserName
                                                    nickName:response.data[@"screen_name"]
                                                  userAvatar:response.data[@"profile_image_url"]
                                                    callBack:^(BOOL success, id obj, NSError *error) {
                                                        
                                                        if (success) {
                                                            NSLog(@"登录成功");
                                                            [super showProgressCompleteWithLabelText:@"登录成功" afterDelay:1];
                                                            
                                                            //保存手动登录的时间，超过20天后，需再次手动登录
                                                            NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
                                                            [userDefaults setValue:[NSDate date] forKey:@"lastLoginTime"];
                                                            [userDefaults synchronize];
                                                            
                                                            // 如果是第一次第三方登录，需补全用户信息
                                                            self.loginId = response.data[@"openid"];
                                                            //[self performSelector:@selector(jumpToEditController) withObject:nil afterDelay:1];
                                                            
                                                            [MobClick event:@"user_login"];
                                                            
                                                        } else {
                                                            //[super showProgressErrorWithLabelText:@"登录失败" afterDelay:1];
                                                            [super showProgressErrorWithLabelText:error.userInfo[NSLocalizedDescriptionKey] afterDelay:1];
                                                        }
                                                        
                                                        
                                                    }];
        
//        [[InternetManager sharedManager] loginWithSequenceId:sequence
//                                                  andAccType:AccTypeSina
//                                                  andloginId:response.data[@"uid"]
//                                                 andPassword:response.data[@"uid"]
//                                          andThirdpartyAppId:SinaAppKey
//                                    andThirdpartyAccessToken:response.data[@"access_token"]
//                                                andLoginType:LoginTypeUserName
//                                                    callBack:^(BOOL success, id obj, NSError *error) {
//                                                        
//                                                        if (success) {
//                                                            NSLog(@"登录成功");
//                                                            [super showProgressCompleteWithLabelText:@"登录成功" afterDelay:1];
//                                                            
//                                                            //保存手动登录的时间，超过20天后，需再次手动登录
//                                                            NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
//                                                            [userDefaults setValue:[NSDate date] forKey:@"lastLoginTime"];
//                                                            [userDefaults synchronize];
//                                                            
//                                                            // 如果是第一次第三方登录，需补全用户信息
//                                                            self.loginId = response.data[@"openid"];
//                                                            //[self performSelector:@selector(jumpToEditController) withObject:nil afterDelay:1];
//                                                        } else {
//                                                            //[super showProgressErrorWithLabelText:@"登录失败" afterDelay:1];
//                                                            [super showProgressErrorWithLabelText:error.userInfo[NSLocalizedDescriptionKey] afterDelay:1];
//                                                        }
//                                                        
//                                                        
//                                                    }];
        
        
    }];
}

#pragma mark - 跳转资料补全页面

- (void)jumpToEditController
{
    
    CompleteController* editController = [self.storyboard instantiateViewControllerWithIdentifier:@"Complete view controller"];
    
    editController.loginId = self.loginId;

    [self.navigationController pushViewController:editController animated:YES];
    
    

}

#pragma mark - 关闭登录界面

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
