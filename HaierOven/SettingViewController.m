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

@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

@end

@implementation SettingViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.logoutButton.layer.cornerRadius = 10;
    self.logoutButton.layer.masksToBounds = YES;
    // Do any additional setup after loading the view.
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




