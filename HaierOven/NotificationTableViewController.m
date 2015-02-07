//
//  NotificationTableViewController.m
//  HaierOven
//
//  Created by dongl on 15/1/15.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "NotificationTableViewController.h"
#import "SystemNotificationCell.h"
#import "PersonalCenterSectionView.h"
#import "NotificationSectionHeadView.h"

#import "CookbookDetailControllerViewController.h"
#import "ChatViewController.h"
#import "DeviceMessageCell.h"

typedef NS_ENUM(NSInteger, NotificationType)
{
    NotificationTypeOven    = 1,
    NotificationTypeSystem,
};

@interface NotificationTableViewController ()<PersonalCenterSectionViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *headView;

@property (nonatomic) NSInteger pageIndex;
@property (strong, nonatomic) NSMutableArray* allNotifications;

@property (strong, nonatomic) NSMutableArray* cookbookNotifications;

@property (strong, nonatomic) NSMutableArray* messagesNotifications;

@property (strong, nonatomic) NSMutableArray* ovenNotifications;

@property (nonatomic) NotificationType notificationType;

@end

@implementation NotificationTableViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.pageIndex = 1;
        self.allNotifications = [NSMutableArray array];
        self.cookbookNotifications = [NSMutableArray array];
        self.messagesNotifications = [NSMutableArray array];
        self.ovenNotifications = [NSMutableArray array];
        self.notificationType = NotificationTypeOven;
        
        
        
    }
    return self;
}

- (void)loadNotifications
{
//    if (!IsLogin) {
//        [super openLoginController];
//        return;
//    }
    
    if (self.notificationType == NotificationTypeSystem) {
        
        NSString* userBaseId = CurrentUserBaseId; //@"5";
        [[InternetManager sharedManager] getNotificationListWithUserBaseId:userBaseId status:0 pageIndex:_pageIndex callBack:^(BOOL success, id obj, NSError *error) {
            
            if (success) {
                // 15秒后设置为已读
                [self performSelector:@selector(updateReadStatus) withObject:nil afterDelay:10];
                
                NSArray* arr = obj;
                if (arr.count < PageLimit && _pageIndex != 1) {
                    [super showProgressErrorWithLabelText:@"没有更多了..." afterDelay:1];
                }
                if (_pageIndex == 1) {
                    self.allNotifications = obj;
                    if (arr.count == 0) {
                        [super showProgressErrorWithLabelText:@"您没有未读消息" afterDelay:1];
                    }
                } else {
                    [self.allNotifications addObjectsFromArray:arr];
                }
                [self reload];
            }
            
        }];
        
    } else {
        // 获取设备信息
        self.ovenNotifications = [[DataCenter sharedInstance] loadOvenNotifications];
        
        [self.tableView reloadData];
    }
    
    
    
}


- (void)updateReadStatus
{
    [[InternetManager sharedManager] updateNotificationReadStatusWithUserBaseId:CurrentUserBaseId callBack:^(BOOL success, id obj, NSError *error) {
        if (success) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationsHadReadNotification object:nil];
        }
    }];
}

- (void)reload
{
    if (self.notificationType == NotificationTypeSystem) {
        self.cookbookNotifications = [NSMutableArray array];
        self.messagesNotifications = [NSMutableArray array];
        for (NoticeInfo* notice in self.allNotifications) {
            if (notice.type == 3) { //私信
                [self.messagesNotifications addObject:notice];
            } else { // 1赞菜谱 2评论菜谱
                [self.cookbookNotifications addObject:notice];
            }
        }
    } else {
        
    }
    
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initHeadView];
    
    [self addHeader];
    [self addFooter];
    
    [self loadNotifications];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMarkStatus:) name:MessageCountUpdateNotification object:nil];
    if ([DataCenter sharedInstance].messagesCount > 0 && IsLogin) {
        [self markNewMessage];
    } else {
        [self deleteMarkLabel];
    }
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addHeader
{
    __unsafe_unretained typeof(self) vc = self;
    // 添加上拉刷新尾部控件
    
    [self.tableView addHeaderWithCallback:^{
        // 进入刷新状态就会回调这个Block
        
        // 增加根据pageIndex加载数据
        vc.pageIndex = 1;
        [vc loadNotifications];
        
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
        if (vc.notificationType == NotificationTypeSystem) {
            vc.pageIndex++;
        }
        
        [vc loadNotifications];
        
        // 加载数据，0.5秒后执行
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            // 结束刷新
            [vc.tableView footerEndRefreshing];
            
        });
        
    }];
    
}

-(void)initHeadView{
    CGRect rect = self.headView.frame;
    rect.size.height = PageW*0.1388888;
    self.headView.frame = rect;
    PersonalCenterSectionView *head = [[PersonalCenterSectionView alloc]initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    head.delegate = self;
    head.sectionType = sectionNotification;
    [self.headView addSubview:head];
    
}

-(void)SectionType:(NSInteger)type{
    NSLog(@"%d",type);
    self.notificationType = type;
    _pageIndex = 1;
    [self loadNotifications];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.notificationType == NotificationTypeSystem ? 2 : 1;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)sectio{
//    return @"123";
//}    // fixed font style. use custom view (UILabel) if you want something different

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (self.notificationType == NotificationTypeSystem) {
        NotificationSectionHeadView *sectionview = [[NotificationSectionHeadView alloc]initWithFrame:CGRectMake(0, 0, PageW, 44)];
//        if (self.allNotifications.count == 0) {
//            return [[UIView alloc] init];
//        }
        if (section == 0) {
//            if (self.cookbookNotifications.count == 0) {
//                return [[UIView alloc] init];
//            }
//            sectionview.sectionTitleLabel.text = self.cookbookNotifications.count == 0 ? @"" : @"菜谱";
            sectionview.sectionTitleLabel.text = @"菜谱";
        } else {
//            if (self.messagesNotifications.count == 0) {
//                return [[UIView alloc] init];
//            }
//            sectionview.sectionTitleLabel.text = self.messagesNotifications.count == 0 ? @"" : @"厨神";
            sectionview.sectionTitleLabel.text = @"厨神";
        }
        
        return sectionview;
    } else {
        return [[UIView alloc] init];
    }
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.notificationType == NotificationTypeOven) {
        CGSize size = CGSizeZero;
        NSDictionary* info = self.ovenNotifications[indexPath.row];
        
        size = [MyUtils getTextSizeWithText:info[@"desc"] andTextAttribute:@{NSFontAttributeName :[UIFont fontWithName:GlobalTextFontName size:14]} andTextWidth:self.view.width-80];
        
        return size.height+35;
    } else {
        
        return 53;
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.notificationType == NotificationTypeSystem ? 44 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.notificationType == NotificationTypeSystem) {
        if (section == 0) {
            return self.cookbookNotifications.count;
        }
        return self.messagesNotifications.count;
    } else {
        return self.ovenNotifications.count;
    }
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    // Configure the cell...
    if (self.notificationType == NotificationTypeSystem) {
        SystemNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SystemNotificationCell" forIndexPath:indexPath];
        if (indexPath.section == 0) {
            
            cell.notice = self.cookbookNotifications[indexPath.row];
            
        } else {
            
            cell.notice = self.messagesNotifications[indexPath.row];
            
        }
        
        return cell;
    } else {
        DeviceMessageCell* cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceMessageCell" forIndexPath:indexPath];
        
        NSDictionary* info = self.ovenNotifications[indexPath.row];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm"];
        NSDate *date = [dateFormatter dateFromString:info[@"time"]];
        
        cell.messageTime.text = [MyTool intervalSinceNow:date];
        cell.messageLabel.text = info[@"desc"];
        
        CGSize size = CGSizeZero;
        size = [MyUtils getTextSizeWithText:info[@"desc"] andTextAttribute:@{NSFontAttributeName :cell.messageLabel.font} andTextWidth:cell.width-80];
        cell.messageLabel.frame = CGRectMake(20, cell.messageTime.bottom, size.width, size.height);
        
        //cell.ovenNotification = self.ovenNotifications[indexPath.row];
        
        return cell;
    }

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.notificationType == NotificationTypeSystem) {
        
        if (indexPath.section == 0) {
            
            UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Liukang" bundle:nil];
            CookbookDetailControllerViewController* cookbookDetailController = [storyboard instantiateViewControllerWithIdentifier:@"Cookbook detail controller"];
            //        cookbookDetailController.cookbook = self.cookbooks[indexPath.row];
            NoticeInfo* selectedNotice = self.cookbookNotifications[indexPath.row];
            cookbookDetailController.cookbookId = selectedNotice.relatedId;
            
            
            [self.navigationController pushViewController:cookbookDetailController animated:YES];
            
        } else {
            // 跳转到聊天界面
            
            NoticeInfo* selectedNotice = self.messagesNotifications[indexPath.row];
            UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Liukang" bundle:nil];
            ChatViewController* chatViewController = [storyboard instantiateViewControllerWithIdentifier:@"Chat view controller"];
            chatViewController.toUserId = selectedNotice.promoter.userBaseId;
            chatViewController.toUserName = selectedNotice.promoter.nickName;
            
            [self.navigationController pushViewController:chatViewController animated:YES];
            
        }
        
    } else {
        //烤箱信息
        
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
