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

@interface LoginViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *textborder;
@property (strong, nonatomic) IBOutlet UIButton *loginBtn;
@property (strong, nonatomic) IBOutlet UITextField *userNameTextFailed;
@property (strong, nonatomic) IBOutlet UITextField *psdTextfailed;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.navigationController.viewControllers.count == 1) {
        UIButton* leftButton = [[UIButton alloc] init];
//        [leftButton addTarget:self action:@selector(turnLeftMenu) forControlEvents:UIControlEventTouchUpInside];
//        [super setLeftBarButtonItemWithImageName:@"liebieo.png" andTitle:nil andCustomView:leftButton];
        
        [leftButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [super setLeftBarButtonItemWithImageName:@"back.png" andTitle:nil andCustomView:leftButton];
        
    }
    
    
}

- (void)turnLeftMenu
{
    [self.sideMenuViewController presentLeftMenuViewController];
}

- (void)close
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
    
//    [[InternetManager sharedManager] testLoginWithSequenceId:@"1234"
//                                                  andAccType:AccTypeHaier
//                                                  andloginId:self.userNameTextFailed.text
//                                                 andPassword:self.psdTextfailed.text
//                                          andThirdpartyAppId:nil
//                                    andThirdpartyAccessToken:nil
//                                                andLoginType:LoginTypeMobile 
//                                                    callBack:^(BOOL success, id obj, NSError *error) {
//                                                        if (success) {
//                                                            NSLog(@"登录成功");
//                                                            [super showProgressCompleteWithLabelText:@"登录成功" afterDelay:1];
//                                                        } else {
//                                                            [super showProgressErrorWithLabelText:@"登录失败" afterDelay:1];
//                                                        }
//                                                        
//                                                    }];
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
    
    
    [[InternetManager sharedManager] loginWithSequenceId:sequence
                                              andAccType:AccTypeHaier
                                              andloginId:self.userNameTextFailed.text
                                             andPassword:self.psdTextfailed.text
                                      andThirdpartyAppId:nil
                                andThirdpartyAccessToken:nil
                                            andLoginType:loginType
                                                callBack:^(BOOL success, id obj, NSError *error) {
                                                    
                                                    if (success) {
                                                        NSLog(@"登录成功");
                                                        [super showProgressCompleteWithLabelText:@"登录成功" afterDelay:1];
                                                        [self dismissViewControllerAnimated:YES completion:nil];
                                                    } else {
                                                        [super showProgressErrorWithLabelText:@"登录失败" afterDelay:1];
                                                    }
                                                    
                                                    
                                                }];
    
    
}
- (IBAction)forgetPsd:(id)sender {
    
    WebViewController* webController = [self.storyboard instantiateViewControllerWithIdentifier:@"Web view controller"];
    webController.titleText = @"忘记密码";
    webController.webPath = ResetPasswordUrl;
    [self.navigationController pushViewController:webController animated:YES];
    
}
- (IBAction)TencentLogin:(id)sender {
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        NSLog(@"response is %@",response);
        [self loginWithQQ];
    });
    
//    RootViewController *root = [self.storyboard instantiateViewControllerWithIdentifier:@"RootViewController"];
//    [self presentViewController:root animated:YES completion:nil];
}


- (IBAction)SinawbLogin:(id)sender {
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        NSLog(@"response is %@",response);
        [self loginWithSina];
    });
    
//    RootViewController *root = [self.storyboard instantiateViewControllerWithIdentifier:@"RootViewController"];
//    [self presentViewController:root animated:YES completion:nil];
    
}
- (IBAction)Register:(id)sender {
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
        
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddhhmmss";
        NSString* sequence = [formatter stringFromDate:[NSDate date]];
        sequence = [sequence stringByReplacingOccurrencesOfString:@":" withString:@""];
        
        [[InternetManager sharedManager] loginWithSequenceId:sequence
                                                      andAccType:AccTypeQQ
                                                      andloginId:response.data[@"openid"]
                                                     andPassword:response.data[@"openid"]
                                              andThirdpartyAppId:@"100424468"
                                        andThirdpartyAccessToken:response.data[@"access_token"]
                                                    andLoginType:LoginTypeUserName
                                                        callBack:^(BOOL success, id obj, NSError *error) {
                                                            
                                                            if (success) {
                                                                NSLog(@"登录成功");
                                                                [super showProgressCompleteWithLabelText:@"登录成功" afterDelay:1];
                                                                [self dismissViewControllerAnimated:YES completion:nil];
                                                            } else {
                                                                [super showProgressErrorWithLabelText:@"登录失败" afterDelay:1];
                                                            }
                                                            
                                                            
                                                        }];
        
        
    }];
}

- (void)loginWithSina
{
    [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToSina  completion:^(UMSocialResponseEntity *response){
        NSLog(@"SnsInformation is %@",response.data);
        
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddhhmmss";
        NSString* sequence = [formatter stringFromDate:[NSDate date]];
        sequence = [sequence stringByReplacingOccurrencesOfString:@":" withString:@""];
        
        if (response.data[@"openid"] == nil) {
            [super showProgressErrorWithLabelText:@"登录失败" afterDelay:1];
            return;
        }
        
        [[InternetManager sharedManager] loginWithSequenceId:sequence
                                                  andAccType:AccTypeSina
                                                  andloginId:response.data[@"openid"]
                                                 andPassword:response.data[@"openid"]
                                          andThirdpartyAppId:@"1162620904"
                                    andThirdpartyAccessToken:response.data[@"access_token"]
                                                andLoginType:LoginTypeUserName
                                                    callBack:^(BOOL success, id obj, NSError *error) {
                                                        
                                                        if (success) {
                                                            NSLog(@"登录成功");
                                                            [super showProgressCompleteWithLabelText:@"登录成功" afterDelay:1];
                                                        } else {
                                                            [super showProgressErrorWithLabelText:@"登录失败" afterDelay:1];
                                                        }
                                                        
                                                        
                                                    }];
        
        
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
