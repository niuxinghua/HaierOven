//
//  SettingViewController.m
//  HaierOven
//
//  Created by dongl on 15/1/14.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "SettingViewController.h"
#import <StoreKit/StoreKit.h>

@interface SettingViewController () <SKStoreProductViewControllerDelegate>


@property (weak, nonatomic) IBOutlet UIButton *versionButton;


@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

@end

@implementation SettingViewController

#pragma mark - 新消息标记及移除标记

- (void)updateMarkStatus:(NSNotification*)notification
{
    NSDictionary* countDict = notification.userInfo;
    NSInteger count = [countDict[@"count"] integerValue];
    if (count > 0) {
        [self markNewMessage];
    } else {
        [self deleteMarkLabel];
    }
    
}

- (void)markNewMessage
{
    //拿到左侧栏按钮
    UIBarButtonItem* liebiao = self.navigationItem.leftBarButtonItem;
    UIButton* liebiaoBtn = (UIButton*)liebiao.customView;
    liebiaoBtn.clipsToBounds = NO;
    
    //小圆点
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(-8, -5, 10, 10)];
    label.layer.masksToBounds = YES;
    label.layer.cornerRadius = label.height / 2;
    label.backgroundColor = [UIColor redColor];
    
    //添加到button
    [liebiaoBtn addSubview:label];
    self.navigationItem.leftBarButtonItem = liebiao;
    
}

- (void)deleteMarkLabel
{
    //拿到左侧栏按钮
    UIBarButtonItem* liebiao = self.navigationItem.leftBarButtonItem;
    UIButton* liebiaoBtn = (UIButton*)liebiao.customView;
    liebiaoBtn.clipsToBounds = NO;
    
    //移除小圆点Label
    for (UIView* view in liebiaoBtn.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            [view removeFromSuperview];
        }
    }
    
    //重新赋值leftBarButtonItem
    self.navigationItem.leftBarButtonItem = liebiao;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString* versionTitle = [NSString stringWithFormat:@"版本号%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    [self.versionButton setTitle:versionTitle forState:UIControlStateNormal];
    
    self.logoutButton.layer.cornerRadius = 10;
    self.logoutButton.layer.masksToBounds = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMarkStatus:) name:MessageCountUpdateNotification object:nil];
    if ([DataCenter sharedInstance].messagesCount > 0 && IsLogin) {
        [self markNewMessage];
    } else {
        [self deleteMarkLabel];
    }
    
    // Do any additional setup after loading the view.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)AboutHaier:(id)sender {
    NSLog(@"关于海尔烤箱APP");
    
}

- (IBAction)SuggestPost:(id)sender {
    NSLog(@"意见反馈");
}
- (IBAction)VersionChick:(id)sender {
    NSLog(@"版本确认");
    
    [super showProgressCompleteWithLabelText:@"目前已是最新版本！" afterDelay:2];
    
//    [[InternetManager sharedManager] logoutWithLoginName:[[NSUserDefaults standardUserDefaults] valueForKey:@"loginId"] callBack:^(BOOL success, id obj, NSError *error) {
//        if (success) {
//            
//            
//        }
//    }];
    
}


- (IBAction)PostMark:(id)sender {
    NSLog(@"app打分");
    
    SKStoreProductViewController *skVC=[SKStoreProductViewController new];
    skVC.delegate = self;
    NSDictionary *dict = [NSDictionary dictionaryWithObject:AppStoreID forKey:SKStoreProductParameterITunesItemIdentifier];
    [super showProgressHUDWithLabelText:@"请稍候..." dimBackground:NO];
    [self performSelector:@selector(dismissHud) withObject:nil afterDelay:10];
    [skVC loadProductWithParameters:dict completionBlock:^(BOOL result, NSError *error) {
        //[super hiddenProgressHUD];
    }];
    [self presentViewController:skVC animated:YES completion:nil];
    
}

- (void)dismissHud
{
    [super hiddenProgressHUD];
}

- (IBAction)logout:(UIButton *)sender
{
    if (IsLogin) {
        [super showProgressCompleteWithLabelText:@"您已退出登录" afterDelay:2];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLogin"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:LogoutSuccussNotification object:nil];
        
        // 统计用户使用时长
        [uAnalysisManager onUserLogout];
        
        [super openLoginController];
    } else {
        [super showProgressCompleteWithLabelText:@"您还没有登录" afterDelay:2];
    }
}


#pragma mark - SKStoreProductViewControllerDelegate

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController{
    
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"dismiss");
    }];
    
}

@end




