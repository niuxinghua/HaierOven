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
@interface LeftMenuViewController ()<FirstTableViewCellDelegate,NormalTableViewCellDelegate>
@property (strong, readwrite, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *tempView;
@property BOOL hadDevice;
@end

@implementation LeftMenuViewController
@synthesize tempView;
@synthesize hadDevice;
- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    hadDevice = [accountDefaults boolForKey:@"hadDevice"];
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
    
    

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * footview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PageW, 10)];
    footview.backgroundColor = UIColorFromRGB(0xb06206);
    return footview;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
            
        case 0:
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"PersonalCenterViewController"]]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
        case 1:
            if (!hadDevice) {
                [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"AddDeviceStepOneController"]]
                                                             animated:YES];
                [self.sideMenuViewController hideMenuViewController];
                break;
            }else{
                [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"DeviceViewController"]]
                                                             animated:YES];
                [self.sideMenuViewController hideMenuViewController];
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
            
            case 6:
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"ShoppingListTableViewController"]]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];

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
    return (PageH-115-10-20)/8;
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
        return cell;
    }else if (indexPath.row==1){
        if (hadDevice) {
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
        cell.titleLabel.text = titles[indexPath.row-2];
        cell.titleLabel.font = [UIFont fontWithName:GlobalTitleFontName size:14];
        cell.titleImage.image = images[indexPath.row-2];
        cell.cellSelectedView.backgroundColor = UIColorFromRGB(0xb06206);
        cell.backgroundColor = GlobalOrangeColor;
        if (indexPath.row ==2) {
            self.tempView = cell.cellSelectedView;
            self.tempView.hidden = NO;
        }
        return cell;
    }
}


-(void)SignIn:(UIButton *)btn{
    
    btn.selected = btn.selected==YES?NO:YES;
    [super showProgressCompleteWithLabelText:@"点心＋2" afterDelay:1.0];
}
-(void)ChangeController:(UIView *)btn{
    tempView.hidden = YES;
    tempView = btn;
    btn.hidden = NO;
}
@end
