//
//  BaseTableViewController.m
//  众筹
//
//  Created by 刘康 on 14/11/13.
//  Copyright (c) 2014年 origheart. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController () {
    UIView *_loadingView;
}

@end

@implementation BaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = YES;
    if (self.navigationController.viewControllers.count > 1 && self.isBackButton) {
        UIButton *backButton = [[UIButton alloc] init];
        [backButton setImage:IMAGENAMED(@"back.png") forState:UIControlStateNormal];
        [backButton setImage:IMAGENAMED(@"back.png") forState:UIControlStateHighlighted];
        backButton.showsTouchWhenHighlighted = YES;
        [backButton setFrame:CGRectMake(0, 0, 26, 26)];
        [backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    }
    
    
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
}

- (void)setLeftBarButtonItemWithImageName:(NSString*)imageName andTitle:(NSString*)title andCustomView:(UIView*)customView
{
    customView.userInteractionEnabled = YES;
    if ([customView isKindOfClass:[UIButton class]]) {
        UIButton* button = (UIButton*)customView;
        if (imageName) {
            [button setImage:IMAGENAMED(imageName) forState:UIControlStateNormal];
            button.frame = CGRectMake(0, 0, 26, 26);
        } else {
            [button setTitle:title forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.frame = CGRectMake(0, 0, 40, 26);
        }
        UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = item;
    } else {
        UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithCustomView:customView];
        self.navigationItem.leftBarButtonItem = item;
    }
    
}

- (void)setRightBarButtonItemWithImageName:(NSString*)imageName andTitle:(NSString*)title andCustomView:(UIView*)customView
{
    customView.userInteractionEnabled = YES;
    if ([customView isKindOfClass:[UIButton class]]) {
        UIButton* button = (UIButton*)customView;
        if (imageName) {
            [button setImage:IMAGENAMED(imageName) forState:UIControlStateNormal];
            button.frame = CGRectMake(0, 0, 26, 26);
        } else {
            [button setTitle:title forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.frame = CGRectMake(0, 0, 40, 26);
        }
        UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.rightBarButtonItem = item;
    } else {
        UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithCustomView:customView];
        self.navigationItem.rightBarButtonItem = item;
    }
    
}

//提示网络加载
- (void)showLoading:(BOOL)isShow
{
    if (_loadingView == nil) {
        _loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, Main_Screen_Height/2-80, Main_Screen_Width, 20)];
        
        UIActivityIndicatorView *activityIndicatroView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [activityIndicatroView startAnimating];
        
        UILabel *loadLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [loadLabel setBackgroundColor:[UIColor clearColor]];
        loadLabel.text = @"正在加载...";
        loadLabel.font = [UIFont boldSystemFontOfSize:20];
        loadLabel.textColor = [UIColor blackColor];
        [loadLabel sizeToFit];
        
        loadLabel.center = CGPointMake(_loadingView.width/2, _loadingView.height/2);
        activityIndicatroView.right = loadLabel.left - 5;
        
        [_loadingView addSubview:loadLabel];
        [_loadingView addSubview:activityIndicatroView];
    }
    if (isShow) {
        if (![_loadingView superview]) {
            [self.view addSubview:_loadingView];
        }
    } else {
        [_loadingView removeFromSuperview];
    }
}

//使用HUD
- (void)showProgressHUDWithLabelText:(NSString *)text dimBackground:(BOOL)dimBackground
{
    self.progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.progressHUD.labelText = text;
    self.progressHUD.labelColor = [UIColor whiteColor];
    self.progressHUD.dimBackground = dimBackground;
}

//显示完成标记
- (void)showProgressCompleteWithLabelText:(NSString *)text afterDelay:(NSTimeInterval)delay
{
    self.progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
//    self.progressHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    self.progressHUD.mode = MBProgressHUDModeCustomView;
    
    self.progressHUD.color = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7];;
    self.progressHUD.labelColor = [UIColor whiteColor];
    self.progressHUD.labelFont = [UIFont fontWithName:GlobalTitleFontName size:15];

    
    self.progressHUD.labelText = text;
    [self.progressHUD hide:YES afterDelay:delay];
}

//显示错误
- (void)showProgressErrorWithLabelText:(NSString *)text afterDelay:(NSTimeInterval)delay
{
    self.progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
//    self.progressHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-error.png"]];
    self.progressHUD.mode = MBProgressHUDModeCustomView;
    
    self.progressHUD.color = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7];;
    self.progressHUD.labelColor = [UIColor whiteColor];
    self.progressHUD.labelFont = [UIFont fontWithName:GlobalTitleFontName size:15];

    
    self.progressHUD.labelText = text;
    [self.progressHUD hide:YES afterDelay:delay];
}

//隐藏HUD
- (void)hiddenProgressHUD
{
    [self.progressHUD hide:YES];
}

//状态栏上的提示
- (void)showStatusTip:(BOOL)show title:(NSString *)title
{
    if (_tipWindow == nil) {
        _tipWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 20)];
        [_tipWindow setWindowLevel:UIWindowLevelStatusBar];
        [_tipWindow setBackgroundColor:[UIColor blackColor]];
        
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 20)];
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.font = [UIFont systemFontOfSize:13];
        tipLabel.textColor = [UIColor whiteColor];
        tipLabel.backgroundColor = [UIColor clearColor];
        tipLabel.tag = 2013;
        [_tipWindow addSubview:tipLabel];
        UIImageView *progress = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"queue_statusbar_progress.png"]];
        progress.frame = CGRectMake(-100, 20-6, 100, 6);
        progress.tag = 2012;
        [_tipWindow addSubview:progress];
    }
    UILabel *tipLabel = (UILabel *)[_tipWindow viewWithTag:2013];
    UIImageView *progress = (UIImageView *)[_tipWindow viewWithTag:2012];
    if (show) {
        tipLabel.text = title;
        [_tipWindow setHidden:NO];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:2];
        [UIView setAnimationRepeatCount:1000];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        progress.left = Main_Screen_Width;
        [UIView commitAnimations];
    } else {
        progress.hidden = YES;
        tipLabel.text = title;
        [self performSelector:@selector(removeTipWindow) withObject:nil afterDelay:1];
    }
}

- (void)removeTipWindow
{
    [_tipWindow setHidden:YES];
    _tipWindow = nil;
}


- (void)openLoginController
{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    [self presentViewController:[storyboard instantiateViewControllerWithIdentifier:@"Login view controller"] animated:YES completion:nil];
}


#pragma mark - override

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    
    [titleLabel setText:title];
    [titleLabel sizeToFit];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    self.navigationItem.titleView = titleLabel;
}
- (void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
