//
//  RegisterViewController.m
//  HaierOven
//
//  Created by dongl on 15/1/4.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "RegisterViewController.h"
#import "EmailRegisterView.h"
#import "RootViewController.h"
#import "PhoneRegisterView.h"
#import "PersonalCenterSectionView.h"
#import "WebViewController.h"
#import "ActiveUserController.h"

@interface RegisterViewController ()<EmailRegisterViewDelegate,PhoneRegisterViewDelegate,PersonalCenterSectionViewDelegate>
@property (strong, nonatomic) UIImageView *orangeLine;
@property (strong, nonatomic) IBOutlet UIButton *emailBtn;
@property (strong, nonatomic) IBOutlet UIButton *PhoneBtn;
@property (strong, nonatomic) IBOutlet UIView *registerView;
@property (strong, nonatomic) EmailRegisterView *emailRegisterView;
@property (strong, nonatomic) PhoneRegisterView *phoneRegisterView;
@property (strong, nonatomic) IBOutlet UIView *headview;
@property CGFloat y;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SetUpSubView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)SetUpSubView{
    
//    self.orangeLine = [UIImageView new];
//    self.orangeLine.image = [MyTool createImageWithColor:GlobalOrangeColor];
//    self.orangeLine.frame = CGRectMake(self.emailBtn.left+20, self.emailBtn.height-7, self.emailBtn.width-40, 2);
//    [self.view addSubview:self.orangeLine];
//    
//    

    PersonalCenterSectionView *head = [[PersonalCenterSectionView alloc]initWithFrame:CGRectMake(0, 0, self.headview.width, self.headview.height)];
    head.sectionType = sectionRegister;
    head.delegate = self;
    [self.headview addSubview:head];
    
    self.emailRegisterView = [[EmailRegisterView alloc]initWithFrame:CGRectMake(0, self.headview.bottom, PageW, PageH-self.headview.height)];
    self.emailRegisterView.delegate = self;
    
    self.phoneRegisterView = [[PhoneRegisterView alloc]initWithFrame:CGRectMake(0, self.headview.bottom, PageW, PageH-self.headview.bottom)];
    self.phoneRegisterView.delegate = self;
    self.registerType = RegisterTypeEmail;
    [self.view addSubview:self.emailRegisterView];
    [self.view addSubview:self.phoneRegisterView];

    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillShow:)
     
                                                 name:UIKeyboardWillShowNotification
     
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillHide:)
     
                                                 name:UIKeyboardWillHideNotification
     
                                               object:nil];

    
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)setRegisterType:(RegisterType)registerType{
    _registerType = registerType;
    if (registerType == RegisterTypePhone) {
        [UIView animateWithDuration:0.2 animations:^{
            self.orangeLine.frame = CGRectMake(self.PhoneBtn.left+20, self.emailBtn.bottom-7, self.emailBtn.width-40, 2);
        }];
        
        self.emailRegisterView.hidden = NO;
        self.phoneRegisterView.hidden = YES;
        self.y = self.emailRegisterView.tempHight.bottom+64+43;
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            self.orangeLine.frame = CGRectMake(self.emailBtn.left+20, self.PhoneBtn.bottom-7, self.PhoneBtn.width-40, 2);
        }];
        self.emailRegisterView.hidden = YES;
        self.phoneRegisterView.hidden = NO;
        self.y = self.phoneRegisterView.tempHight.bottom+64+43;
    }
}


-(void)SectionType:(NSInteger)type{
    self.registerType = type;
}

- (IBAction)RegisterType:(UIButton*)sender {
    self.registerType = sender.tag;
}
- (IBAction)Turnback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}






#pragma mark - 手机注册回调方法
-(void)turnBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)turnDeal{
    NSLog(@"跳转至用户隐私合约");
    
    WebViewController* webController = [self.storyboard instantiateViewControllerWithIdentifier:@"Web view controller"];
    webController.titleText = @"忘记密码";
    webController.webPath = HaierPolicyUrl;
    [self.navigationController pushViewController:webController animated:YES];
    
}

-(void)RegisterWithPhone:(NSString *)phone andVerifyCode:(NSString *)code andPassword:(NSString *)password
{
//#warning 调试
//    [self goToActiveUser:phone];    // 调试用的
//    return;
    
    [super showProgressHUDWithLabelText:@"请稍候..." dimBackground:NO];
    [[InternetManager sharedManager] registerWithEmail:nil andPhone:phone andPassword:password callBack:^(BOOL success, id obj, NSError *error) {
        [super hiddenProgressHUD];
        if (success) {
            [super hiddenProgressHUD];
            
            [self goToActiveUser:phone password:password];  //跳转到激活用户页面
            
            
        } else {
            //[super showProgressErrorWithLabelText:@"注册失败" afterDelay:1];
            [super showProgressErrorWithLabelText:error.userInfo[NSLocalizedDescriptionKey] afterDelay:1];
        }
    }];
    
    
}

- (void)goToActiveUser:(NSString*)activeMethod password:(NSString*)password
{
    ActiveUserController* activeController = [self.storyboard instantiateViewControllerWithIdentifier:@"Active user controller"];
    activeController.activeMethod = activeMethod;
    activeController.accType = AccTypeHaier;
    activeController.registerFlag = YES;
    activeController.password = password;
    [self.navigationController pushViewController:activeController
                                         animated:YES];
    
}

- (void)popController
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)alertError:(NSString *)string{
    [super showProgressErrorWithLabelText:string afterDelay:1];
}


#pragma mark - 邮箱注册回调方法
-(void)turnBackEmail{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)turnDealEmail{
    NSLog(@"跳转至用户隐私合约");
    WebViewController* webController = [self.storyboard instantiateViewControllerWithIdentifier:@"Web view controller"];
    webController.titleText = @"忘记密码";
    webController.webPath = HaierPolicyUrl;
    [self.navigationController pushViewController:webController animated:YES];
}

- (void)getVerifyCodeWithPhone:(NSString *)phone
{
    NSLog(@"获取手机验证码");
}

-(void)RegisterWithEmail:(NSString *)email andPassword:(NSString *)password
{
    [super showProgressHUDWithLabelText:@"请稍候..." dimBackground:NO];
    [[InternetManager sharedManager] registerWithEmail:email andPhone:nil andPassword:password callBack:^(BOOL success, id obj, NSError *error) {
        [super hiddenProgressHUD];
        if (success) {
//            RootViewController *root = [self.storyboard instantiateViewControllerWithIdentifier:@"RootViewController"];
//            [self presentViewController:root animated:YES completion:nil];
//            [super showProgressCompleteWithLabelText:@"注册成功，请登录" afterDelay:2];
//            [self performSelector:@selector(popController) withObject:nil afterDelay:2];
            [self loginWithUserName:email password:password];
            
        } else {
            [super showProgressErrorWithLabelText:error.userInfo[NSLocalizedDescriptionKey] afterDelay:1];
        }
    }];
    
}

-(void)alertErrorEmail:(NSString *)string{
    [super showProgressErrorWithLabelText:string afterDelay:1];
}

#pragma mark - 登录

- (void)loginWithUserName:(NSString*)userName password:(NSString*)password
{
    LoginType loginType;
    if ([MyTool validateEmail:userName]) {
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
                                              andloginId:userName
                                             andPassword:password
                                      andThirdpartyAppId:nil
                                andThirdpartyAccessToken:nil
                                            andLoginType:loginType
                                                callBack:^(BOOL success, id obj, NSError *error) {
                                                    [super hiddenProgressHUD];
                                                    if (success) {
                                                        NSLog(@"登录成功");
                                                        
                                                        //保存手动登录的时间，超过20天后，需再次手动登录
                                                        NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
                                                        [userDefaults setValue:[NSDate date] forKey:@"lastLoginTime"];
                                                        [userDefaults synchronize];
                                                        
                                                        [super showProgressCompleteWithLabelText:@"登录成功" afterDelay:1];
                                                        if (loginType == LoginTypeEmail) {
                                                            [[[UIAlertView alloc] initWithTitle:@"激活" message:@"注册成功，请前往邮箱激活您的账号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                                                        }
                                                        
                                                        //[[NSNotificationCenter defaultCenter] postNotificationName:LoginSuccussNotification object:nil];
                                                    } else {
                                                        [super showProgressErrorWithLabelText:error.userInfo[NSLocalizedDescriptionKey] afterDelay:1];
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



- (void)keyboardWillShow:(NSNotification *)aNotification

{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    int k = PageH - self.y;
    if (k<height) {
        self.view.frame = CGRectMake(0,-(height - k), PageW, PageH);
    }
}


//当键退出时调用

- (void)keyboardWillHide:(NSNotification *)aNotification

{
    self.view.frame = CGRectMake(0,0, PageW, PageH);
    
}

@end
