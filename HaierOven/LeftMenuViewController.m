//
//  LeftMenuViewController.m
//  HaierOven
//
//  Created by dongl on 14/12/16.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "UIViewController+RESideMenu.h"
#import "FirstTableViewCell.h"
#import "SecTableViewCell.h"
#import "SecDeviceTableViewCell.h"
#import "NormalTableViewCell.h"
#import "LeftMenuAlert.h"
@interface LeftMenuViewController ()<FirstTableViewCellDelegate,NormalTableViewCellDelegate,LeftMenuAlertDelegate>
@property (strong, readwrite, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *tempView;
@property (strong, nonatomic) User* currentUser;
@property (nonatomic) NSInteger notificationCount;
@property (strong, nonatomic) UIWindow *myWindow;
@property (strong, nonatomic) LeftMenuAlert *leftMenuAlert;
@end

@implementation LeftMenuViewController
@synthesize tempView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, PageW, PageH-20) style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = NO;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.backgroundView = nil;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.bounces = NO;
        tableView.scrollsToTop = NO;
        tableView;
    });
    self.view.backgroundColor = GlobalYellowColor;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FirstTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"LeftMenuFirstCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SecTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"LeftMenuSecCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([NormalTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"normalMenuCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SecDeviceTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"SecDeviceTableViewCell"];
    [self.view addSubview:self.tableView];
    
    [self loadUserInfo];
    
    [self updateNotificationCount];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadUserInfo) name:ModifiedUserInfoNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadUserInfo) name:LoginSuccussNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:LogoutSuccussNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNotificationCount) name:NotificationsHadReadNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoDeviceListController) name:BindDeviceSuccussNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:DeleteLocalOvenSuccessNotification object:nil];
    
    self.myWindow = [UIWindow new];
    self.myWindow.frame = CGRectMake(0, 0, PageW, PageH);
    self.myWindow.backgroundColor = [UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:0.3];
    self.myWindow.windowLevel = UIWindowLevelAlert;
    [self.myWindow makeKeyAndVisible];
    self.myWindow.userInteractionEnabled = YES;
    self.myWindow.hidden = YES;
    
    self.leftMenuAlert = [[LeftMenuAlert alloc]initWithFrame:alert_RectHidden];
    self.leftMenuAlert.delegate = self;
    [self.myWindow addSubview:self.leftMenuAlert];
    // Do any additional setup after loading the view.
    self.sideMenuViewController.delegate = self;
}

-(void)isGoingToLogin:(BOOL)goLogin{
    self.myWindow.hidden = YES;
    self.leftMenuAlert.frame = alert_RectHidden;
    
    if (goLogin) {
        [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"Login view controller"] animated:YES completion:nil];
    } else {
        
        [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"DeviceGuideListController"]]
                                                     animated:YES];
        [self.sideMenuViewController hideMenuViewController];
        
    }
    
    
}

- (void)cancelOperate
{
    self.myWindow.hidden = YES;
    self.leftMenuAlert.frame = alert_RectHidden;
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.tempView = nil;
}

- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController
{
    [self updateNotificationCount];
    [self loadUserInfo];
    [self reload];
}

- (void)reload
{
    [self.tableView reloadData];
}

- (void)gotoDeviceListController
{
    [self.tableView reloadData];
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"DeviceViewController"]]
                                                 animated:YES];
    [self.sideMenuViewController hideMenuViewController];
    
}

- (void)loadUserInfo
{
    if (!IsLogin) {
        return;
    }
    NSString* userBaseId = CurrentUserBaseId;
    [[InternetManager sharedManager] getUserInfoWithUserBaseId:userBaseId callBack:^(BOOL success, id obj, NSError *error) {
        if (success) {
            self.currentUser = obj;
            [self.tableView reloadData];
            
        }
    }];
}

- (void)updateNotificationCount
{
    if (!IsLogin) {
        return;
    }
    [[InternetManager sharedManager] getNotificationCountWithUserBaseId:CurrentUserBaseId callBack:^(BOOL success, id obj, NSError *error) {
        if (success) {
            self.notificationCount = [obj[@"data"] integerValue];
            
            [self.tableView reloadData];
            
            // 每隔2分钟获取一次未读通知数量
            [self performSelector:@selector(updateNotificationCount) withObject:nil afterDelay:2*60];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * footview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PageW, 30)];
    footview.backgroundColor = UIColorFromRGB(0xb06206);
    return footview;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}
#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
            
        case 0:
            
            if (IsLogin) {
                [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"PersonalCenterViewController"]]
                                                             animated:YES];
                [self.sideMenuViewController hideMenuViewController];
            } else {
                
//                [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"]]
//                                                             animated:YES];
//                [self.sideMenuViewController hideMenuViewController];
                
                [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"Login view controller"] animated:YES completion:nil];
                
            }
            
            
            break;
        case 1:
        {
            if (IsLogin) {
                if ([DataCenter sharedInstance].myOvens.count == 0) {
                    
                    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"DeviceGuideListController"]]
                                                                 animated:YES];
                    [self.sideMenuViewController hideMenuViewController];
                    
//                    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"AddDeviceStepOneController"]]
//                                                                 animated:YES];
//                    [self.sideMenuViewController hideMenuViewController];
                    break;
                }else{
                    
                    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"DeviceViewController"]]
                                                                 animated:YES];
                    [self.sideMenuViewController hideMenuViewController];
                    
                }
            } else {
                
                self.myWindow.hidden= NO;
                [UIView animateWithDuration:0.2 animations:^{
                    self.leftMenuAlert.frame = CGRectMake(25,PageH/2-85, PageW-50, 163);
                    
                }];
                break;
                
            }
            
            break;
            
        }
        case 2:
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"MainViewController"]]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
        case 3:
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"CookStarController"]]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
        case 4:
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"BakedGroupController"]]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
        case 5:
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"BakedHouseViewController"]]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
            
        case 6:
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"ShoppingListTableViewController"]]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;

        case 7:
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"NotificationTableViewController"]]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;

        case 8:
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"SettingViewController"]]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
            
        default:
            break;
    }
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row ==0) {
        return 115;
    }else
    return (PageH-115-5-20)/8;
//        return 56;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row ==0) {
       NSString *cellIdentifier =@"LeftMenuFirstCell";
        FirstTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        cell.backgroundColor = GlobalGrayColor;
        cell.delegate = self;
        cell.userNameLabel.font = [UIFont fontWithName:GlobalTitleFontName size:15];
        
        if (IsLogin) {
            cell.siginBtn.selected = [[DataCenter sharedInstance] getSignInFlag];
            
            cell.user = self.currentUser;
        } else {
            cell.siginBtn.selected = NO;
            cell.avaterImage.image = [UIImage imageNamed:@"default_avatar"];
            cell.userNameLabel.text = @"未登录";
            
        }
        return cell;
        
    }else if (indexPath.row==1){
        if ([DataCenter sharedInstance].myOvens.count != 0) {
            NSString *cellIdentifier =@"SecDeviceTableViewCell";
            SecDeviceTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            cell.backgroundColor = GlobalGrayColor;
            return cell;
        }else{
            NSString *cellIdentifier =@"LeftMenuSecCell";
            SecTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            cell.backgroundColor = GlobalGrayColor;
            return cell;
        }
    }else{
        
        NSString *cellIdentifier = @"normalMenuCell";
        NormalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        NSArray *titles = @[@"首页", @"厨神名人堂", @"烘焙圈", @"烘焙屋", @"购物清单",@"通知", @"设置"];
        NSArray *images = @[IMAGENAMED(@"shouye"),IMAGENAMED(@"mingrentang"),IMAGENAMED(@"hongbeiquan"),IMAGENAMED(@"hongbeiwu"),IMAGENAMED(@"gouwuqindan"),IMAGENAMED(@"tongzhi"),IMAGENAMED(@"shezhi")];
        cell.delegate = self;
        if (indexPath.row ==7) {
            cell.notificationCount = [NSString stringWithFormat:@" %d ", self.notificationCount];
        }
        cell.titleLabel.text = titles[indexPath.row-2];
        cell.titleLabel.font = [UIFont fontWithName:GlobalTitleFontName size:14];
        cell.titleImage.image = images[indexPath.row-2];
        cell.cellSelectedView.backgroundColor = UIColorFromRGB(0xb06206);
        cell.backgroundColor = GlobalOrangeColor;
        if (indexPath.row ==2&&!self.tempView) {
            self.tempView = cell.cellSelectedView;
            self.tempView.hidden = NO;
        }
        return cell;
    }
}


-(void)signIn:(UIButton *)btn{
    
    
    if (btn.selected) {
        return;
    }
    
    if (!IsLogin) {
        [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"Login view controller"] animated:YES completion:nil];
        return;
        
    }
    
    NSString* userBaseId = CurrentUserBaseId;
    [[InternetManager sharedManager] signInWithUserBaseId:userBaseId callBack:^(BOOL success, id obj, NSError *error) {
        if (success) {
            
            btn.selected = YES;
            [super showProgressCompleteWithLabelText:[NSString stringWithFormat:@"签到成功 点心＋%d", SignInScore] afterDelay:1.0];
            [[DataCenter sharedInstance] saveSignInFlag];
            
        } else {
            NSString* errorMsg = error.userInfo[NSLocalizedDescriptionKey];
            if ([errorMsg hasPrefix:@"您已签到！"]) {
                [super showProgressErrorWithLabelText:@"您已签到！" afterDelay:1.0];
                btn.selected = YES;
                [[DataCenter sharedInstance] saveSignInFlag];
            }
            
        }
        
    }];
}

-(void)ChangeController:(UIView *)btn{
    tempView.hidden = YES;
    tempView = btn;
    btn.hidden = NO;
}
@end
