//
//  CookStarController.m
//  HaierOven
//
//  Created by dongl on 15/1/5.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "CookStarController.h"
#import "CookStarCell.h"
#import "CookStarDetailController.h"
#import "MJRefresh.h"

#import "MainSearchViewController.h"
#import "UpLoadingMneuController.h"

@interface CookStarController () <CookStarCellDelegate, cookStarDetailControllerDelegate>

@property (strong, nonatomic) NSMutableArray* cookerStars;

@property (nonatomic)NSInteger pageIndex;

@end

@implementation CookStarController

#pragma mark - 网络请求

- (void)loadCookerStars
{
//    if (!IsLogin) {
//        [super openLoginController];
//        return;
//    }
    
    //统计页面加载耗时
    UInt64 startTime=[[NSDate date]timeIntervalSince1970]*1000;
    
    NSString* userBaseId = CurrentUserBaseId;
    if (_pageIndex == 1) {
        [super showProgressHUDWithLabelText:@"请稍候..." dimBackground:NO];
    }
    [[InternetManager sharedManager] getCookerStarsWithUserBaseId:userBaseId pageIndex:_pageIndex callBack:^(BOOL success, id obj, NSError *error) {
        [super hiddenProgressHUD];
        if (success) {
            NSArray* arr = obj;
            if (arr.count < PageLimit && _pageIndex != 1) {
                [self.tableView removeFooter];
            }
            if (_pageIndex == 1) {
                self.cookerStars = obj;
            } else {
                [self.cookerStars addObjectsFromArray:arr];
            }
            
            [self.tableView reloadData];
            UInt64 endTime=[[NSDate date]timeIntervalSince1970]*1000;
            [uAnalysisManager onActivityResumeEvent:((long)(endTime-startTime)) withModuleId:@"厨神名人堂页面"];
            
        } else {
            
        }
    }];
}

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

#pragma mark - 初始化和加载

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.pageIndex = 1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addFooter];
    [self addHeader];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self loadCookerStars];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMarkStatus:) name:MessageCountUpdateNotification object:nil];
    if ([DataCenter sharedInstance].messagesCount > 0 && IsLogin) {
        [self markNewMessage];
    } else {
        [self deleteMarkLabel];
    }
    
    [MobClick event:@"cookerStar_list"];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 195;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.cookerStars.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CookStarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CookStarCell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.delegate = self;
    cell.cookerStar = self.cookerStars[indexPath.row];
    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CookStarDetailController *csd = [self.storyboard instantiateViewControllerWithIdentifier:@"CookStarDetailController"];
    CookerStar* cooker = self.cookerStars[indexPath.row];
    csd.cookerStar = cooker;
    csd.delegate = self;
    [self.navigationController pushViewController:csd animated:YES];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Masterchef Page"     // Event category (required)
                                                          action:cooker.userName    // Event action (required)
                                                           label:nil          // Event label
                                                           value:nil] build]];    // Event value
}

#pragma mark - cookStarDetailControllerDelegate

- (void)cookerStarDidFollowd
{
    [self loadCookerStars];
}

#pragma mark - CookStarCellDelegate

- (void)cookStarCell:(CookStarCell *)cell followButtonTapped:(UIButton *)sender
{
    if (!IsLogin) {
        [super openLoginController];
        return;
    }
    
    NSIndexPath* index = [self.tableView indexPathForCell:cell];
    CookerStar* cooker = self.cookerStars[index.row];
    
    if ([cooker.userBaseId isEqualToString:CurrentUserBaseId]) {
        [super showProgressErrorWithLabelText:@"不能关注自己哦" afterDelay:1];
        return;
    }
    
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    CookerStar* selectedCooker = self.cookerStars[indexPath.row];
    NSString* userBaseId = CurrentUserBaseId;
    if (sender.selected) {
        // 已关注，取消关注
        [[InternetManager sharedManager] deleteFollowWithUserBaseId:userBaseId andFollowedUserBaseId:selectedCooker.userBaseId callBack:^(BOOL success, id obj, NSError *error) {
            if (success) {
                NSLog(@"取消关注成功");
                [super showProgressCompleteWithLabelText:@"取消关注" afterDelay:1];
                sender.selected = NO;
            } else {
                [super showProgressErrorWithLabelText:@"取消失败" afterDelay:1];
            }
        }];
    } else {
        // 未关注，添加关注
        [[InternetManager sharedManager] addFollowWithUserBaseId:userBaseId andFollowedUserBaseId:selectedCooker.userBaseId callBack:^(BOOL success, id obj, NSError *error) {
            if (success) {
                NSLog(@"关注成功");
                [super showProgressCompleteWithLabelText:@"已关注" afterDelay:1];
                sender.selected = YES;
            } else {
                [super showProgressErrorWithLabelText:@"关注失败" afterDelay:1];
            }
        }];
    }
    
    //sender.selected = !sender.selected;
}

- (void)addHeader
{
    __unsafe_unretained typeof(self) vc = self;
    // 添加上拉刷新尾部控件
    
    [self.tableView addHeaderWithCallback:^{
        // 进入刷新状态就会回调这个Block
        
        // 增加根据pageIndex加载数据
        vc.pageIndex = 1;
        [vc loadCookerStars];
        
        // 加载数据，0.5秒后执行
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            // 结束刷新
            [vc.tableView headerEndRefreshing];
            
        });
        
    }];
    
}


- (void)addFooter
{
    
    __unsafe_unretained typeof(self) vc = self;
    // 添加上拉刷新尾部控件
    
    [self.tableView addFooterWithCallback:^{
        // 进入刷新状态就会回调这个Block
        
        // 增加根据pageIndex加载数据
        
        vc.pageIndex++;
        [vc loadCookerStars];
        
        // 加载数据，0.5秒后执行
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            // 结束刷新
            [vc.tableView footerEndRefreshing];
            
        });
        
    }];
    
}

- (IBAction)search:(id)sender {
    
    MainSearchViewController* search = [self.storyboard instantiateViewControllerWithIdentifier:@"Search view controller"];
    
    [self.navigationController pushViewController:search animated:YES];
    
}

- (IBAction)addCookbook:(id)sender {
    
    if (IsLogin) {
        UpLoadingMneuController* upload = [self.storyboard instantiateViewControllerWithIdentifier:@"UpLoadingMneuController"];
        [self.navigationController pushViewController:upload animated:YES];
    } else {
        [super openLoginController];
    }
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
