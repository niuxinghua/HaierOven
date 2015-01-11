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
    
    [[InternetManager sharedManager] testLoginWithSequenceId:@"1234"
                                                  andAccType:AccTypeHaier
                                                  andloginId:self.userNameTextFailed.text
                                                 andPassword:self.psdTextfailed.text
                                          andThirdpartyAppId:nil
                                    andThirdpartyAccessToken:nil
                                                andLoginType:LoginTypeMobile 
                                                    callBack:^(BOOL success, id obj, NSError *error) {
                                                        if (success) {
                                                            NSLog(@"登录成功");
                                                            [super showProgressCompleteWithLabelText:@"登录成功" afterDelay:1];
                                                        } else {
                                                            [super showProgressErrorWithLabelText:@"登录失败" afterDelay:1];
                                                        }
                                                        
                                                    }];
    
    
}
- (IBAction)forgetPsd:(id)sender {
    
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
    
    RootViewController *root = [self.storyboard instantiateViewControllerWithIdentifier:@"RootViewController"];
    [self presentViewController:root animated:YES completion:nil];
    
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

- (void)loginWithQQ
{
    [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToQQ  completion:^(UMSocialResponseEntity *response){
        NSLog(@"SnsInformation is %@",response.data);
        
        [[InternetManager sharedManager] testLoginWithSequenceId:@"20150107102633000001"
                                                      andAccType:AccTypeQQ
                                                      andloginId:response.data[@"openid"]
                                                     andPassword:@"13524lk"
                                              andThirdpartyAppId:@"100424468"
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
