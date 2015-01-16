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
@interface RegisterViewController ()<EmailRegisterViewDelegate,PhoneRegisterViewDelegate>
@property (strong, nonatomic) UIImageView *orangeLine;
@property (strong, nonatomic) IBOutlet UIButton *emailBtn;
@property (strong, nonatomic) IBOutlet UIButton *PhoneBtn;
@property (strong, nonatomic) IBOutlet UIView *registerView;
@property (strong, nonatomic) EmailRegisterView *emailRegisterView;
@property (strong, nonatomic) PhoneRegisterView *phoneRegisterView;
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
    
    self.orangeLine = [UIImageView new];
    self.orangeLine.image = [MyTool createImageWithColor:GlobalOrangeColor];
    self.orangeLine.frame = CGRectMake(self.emailBtn.left+20, self.emailBtn.bottom-7, self.emailBtn.width-40, 2);
    [self.view addSubview:self.orangeLine];
    
    
    self.emailRegisterView = [[EmailRegisterView alloc]initWithFrame:CGRectMake(0, self.emailBtn.bottom, PageW, PageH-self.emailBtn.bottom)];
    self.emailRegisterView.delegate = self;
    
    self.phoneRegisterView = [[PhoneRegisterView alloc]initWithFrame:CGRectMake(0, self.emailBtn.bottom, PageW, PageH-self.emailBtn.bottom)];
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
}

-(void)RegisterWithPhone:(NSString *)phone andVerifyCode:(NSString *)code andPassword:(NSString *)password
{
    [super showProgressHUDWithLabelText:@"请稍后..." dimBackground:NO];
//    [[InternetManager sharedManager] testRegisterWithEmail:nil andPhone:phone andPassword:password callBack:^(BOOL success, id obj, NSError *error) {
//        [super hiddenProgressHUD];
//        if (success) {
//            
//            RootViewController *root = [self.storyboard instantiateViewControllerWithIdentifier:@"RootViewController"];
//            [self presentViewController:root animated:YES completion:nil];
//        } else {
//            [super showProgressErrorWithLabelText:@"注册失败" afterDelay:1];
//        }
//        
//        
//    }];

    [[InternetManager sharedManager] registerWithEmail:nil andPhone:phone andPassword:password callBack:^(BOOL success, id obj, NSError *error) {
        [super hiddenProgressHUD];
        if (success) {
            
            RootViewController *root = [self.storyboard instantiateViewControllerWithIdentifier:@"RootViewController"];
            [self presentViewController:root animated:YES completion:nil];
        } else {
            [super showProgressErrorWithLabelText:@"注册失败" afterDelay:1];
        }
    }];
    
    
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
}

- (void)getVerifyCodeWithPhone:(NSString *)phone
{
    NSLog(@"获取手机验证码");
}

-(void)RegisterWithEmail:(NSString *)email andPassword:(NSString *)password
{
    [super showProgressHUDWithLabelText:@"请稍后..." dimBackground:NO];
    [[InternetManager sharedManager] registerWithEmail:email andPhone:nil andPassword:password callBack:^(BOOL success, id obj, NSError *error) {
        [super hiddenProgressHUD];
        if (success) {
            RootViewController *root = [self.storyboard instantiateViewControllerWithIdentifier:@"RootViewController"];
            [self presentViewController:root animated:YES completion:nil];
        } else {
            [super showProgressErrorWithLabelText:@"注册失败" afterDelay:1];
        }
    }];
    
}

-(void)alertErrorEmail:(NSString *)string{
    [super showProgressErrorWithLabelText:string afterDelay:1];
}

#pragma mark - email注册




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
