//
//  BakedGroupController.m
//  HaierOven
//
//  Created by dongl on 15/1/8.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "BakedGroupController.h"
#import "PersonalCenterSectionView.h"
#import "MainViewNormalCell.h"
#import "BakeGroupAdviceCell.h"
#import "Cooker.h"
#import "MJRefresh.h"
#import "CookbookDetailControllerViewController.h"
#import "MainSearchViewController.h"
#import "UpLoadingMneuController.h"

#import "MainSearchViewController.h"
#import "UpLoadingMneuController.h"

#import "PersonalCenterViewController.h"
#import "CookStarDetailController.h"

@interface BakedGroupController ()<PersonalCenterSectionViewDelegate,BackGroupAdviceCellDelegate, searchViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) NSMutableArray *followedCookbooks;
@property (strong, nonatomic) NSMutableArray *recommendCookers;

@property (strong, nonatomic) NSMutableArray* searchedUsers;

/**
 *  searchView和switchView的container
 */
@property (strong, nonatomic) UIView* headerView;

@property (strong, nonatomic) SearchView* searchView;

@property (strong, nonatomic) PersonalCenterSectionView* switchView;

/**
 *  当前显示模式
 */
@property (nonatomic) ContentMode contentMode;

@property (nonatomic) NSInteger followPageIndex;
@property (nonatomic) NSInteger recommentPageIndex;
@property (nonatomic) NSInteger searchPageIndex;

@end
#define HeaderViewRate         0.1388888
#define CellImageRate   0.8
@implementation BakedGroupController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.followPageIndex = 1;
        self.recommentPageIndex = 1;
        self.searchPageIndex = 1;
        self.followedCookbooks = [NSMutableArray array];
        self.recommendCookers = [NSMutableArray array];
        self.searchedUsers = [NSMutableArray array];
        self.contentMode = ContentModeNormal;
    }
    return self;
}

#pragma mark - 网络请求

- (void)loadFollowedCookbooks
{
    if (!IsLogin) {
        [super openLoginController];
        return;
    }
    
    //统计页面加载耗时
    UInt64 startTime=[[NSDate date]timeIntervalSince1970]*1000;
    
    [super showProgressHUDWithLabelText:@"请稍候..." dimBackground:NO];
    NSString* userBaseId = CurrentUserBaseId;
    [[InternetManager sharedManager] getFriendCookbooksWithUserBaseId:userBaseId pageIndex:self.followPageIndex callBack:^(BOOL success, id obj, NSError *error) {
        [super hiddenProgressHUD];
        if (success) {
            NSArray* arr = obj;
            if (arr.count < PageLimit && _followPageIndex != 1) {
                [super showProgressErrorWithLabelText:@"没有更多了..." afterDelay:1];
            }
            if (_followPageIndex == 1) {
                if (arr.count == 0 && self.backGroupType == BackGroupTypeFollowed)
                    [super showProgressErrorWithLabelText:@"没有更多了..." afterDelay:1];
                self.followedCookbooks = obj;
            } else {
                [self.followedCookbooks addObjectsFromArray:arr];
            }
            
            [self.tableview reloadData];
            UInt64 endTime=[[NSDate date]timeIntervalSince1970]*1000;
            [uAnalysisManager onActivityResumeEvent:((long)(endTime-startTime)) withModuleId:@"烘焙圈页面"];
            
        } else {
            [super showProgressErrorWithLabelText:@"获取失败" afterDelay:1];
        }
    }];
    
}


- (void)loadRecommendCookers
{
    if (!IsLogin) {
//        [super openLoginController];
        return;
    }
    NSString* userBaseId = CurrentUserBaseId;
    [super showProgressHUDWithLabelText:@"请稍候..." dimBackground:NO];
    [[InternetManager sharedManager] getRecommentCookersWithUserBaseId:userBaseId pageIndex:self.recommentPageIndex callBack:^(BOOL success, id obj, NSError *error) {
        [super hiddenProgressHUD];
        if (success) {
            NSArray* arr = obj;
            if (arr.count < PageLimit && _recommentPageIndex != 1) {
                [super showProgressErrorWithLabelText:@"没有更多了..." afterDelay:1];
            }
            if (_recommentPageIndex == 1) {
                if (arr.count == 0 && self.backGroupType == BackGroupTypeAdvice)
                    [super showProgressErrorWithLabelText:@"没有更多了..." afterDelay:1];
                self.recommendCookers = obj;
            } else {
                [self.recommendCookers addObjectsFromArray:arr];
            }
           
            [self.tableview reloadData];
        } else {
            [super showProgressErrorWithLabelText:@"获取失败" afterDelay:1];
        }
    }];
    
}

- (void)loadSearchedUsers
{
    if (self.searchView.searchTextFailed.text.length == 0) {
        [super showProgressErrorWithLabelText:@"搜索内容不能为空" afterDelay:1];
        return;
    }
    
    NSString* userBaseId = CurrentUserBaseId;
    [super showProgressHUDWithLabelText:@"请稍候..." dimBackground:NO];
    [[InternetManager sharedManager] searchUsersWithKeyword:self.searchView.searchTextFailed.text pageIndex:_searchPageIndex userBaseId:userBaseId callBack:^(BOOL success, id obj, NSError *error) {
        [super hiddenProgressHUD];
        if (success) {
            NSArray* arr = obj;
            if (arr.count < PageLimit && _searchPageIndex != 1) {
                [super showProgressErrorWithLabelText:@"没有更多了..." afterDelay:1];
            }
            if (_recommentPageIndex == 1) {
                if (arr.count == 0 && self.contentMode == ContentModeSearch)
                    [super showProgressErrorWithLabelText:@"没有更多了..." afterDelay:1];
                self.searchedUsers = obj;
            } else {
                [self.searchedUsers addObjectsFromArray:arr];
            }
            
            [self.tableview reloadData];
        } else {
            [super showProgressErrorWithLabelText:@"获取失败" afterDelay:1];
        }
    }];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self SetUpSubviews];
    
    //[self loadFollowedCookbooks]; 初始化的时候调用，这里不需要调用
    //[self loadRecommendCookers];
    
    [self addHeader];
    [self addFooter];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMarkStatus:) name:MessageCountUpdateNotification object:nil];
    if ([DataCenter sharedInstance].messagesCount > 0 && IsLogin) {
        [self markNewMessage];
    } else {
        [self deleteMarkLabel];
    }
    
    [MobClick event:@"bake_group"];
    // Do any additional setup after loading the view.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

- (void)addHeader
{
    __unsafe_unretained typeof(self) vc = self;
    // 添加上拉刷新尾部控件
    
    [self.tableview addHeaderWithCallback:^{
        // 进入刷新状态就会回调这个Block
        
        // 增加根据pageIndex加载数据
        
        if (vc.contentMode == ContentModeNormal) {
            if (vc.backGroupType == BackGroupTypeAdvice) {
                // 推荐
                vc.recommentPageIndex = 1;
                [vc loadRecommendCookers];
            } else  if (vc.backGroupType == BackGroupTypeFollowed) {
                vc.followPageIndex = 1;
                [vc loadFollowedCookbooks];
                
            }
        } else {
            vc.searchPageIndex = 1;
            [vc loadSearchedUsers];
        }
        
        // 加载数据，0.5秒后执行
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            // 结束刷新
            [vc.tableview headerEndRefreshing];
            
        });
        
    }];
    
}


- (void)addFooter
{
    
    __unsafe_unretained typeof(self) vc = self;
    // 添加上拉刷新尾部控件
    
    [self.tableview addFooterWithCallback:^{
        // 进入刷新状态就会回调这个Block
        
        // 增加根据pageIndex加载数据
        if (vc.contentMode == ContentModeNormal) {
            if (vc.backGroupType == BackGroupTypeAdvice) {
                // 推荐
                vc.recommentPageIndex++;
                [vc loadRecommendCookers];
            } else if (vc.backGroupType == BackGroupTypeFollowed) {
                vc.followPageIndex++;
                [vc loadFollowedCookbooks];
                
            }
        } else {
            vc.searchPageIndex++;
            [vc loadSearchedUsers];
        }
        
        // 加载数据，0.5秒后执行
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            // 结束刷新
            [vc.tableview footerEndRefreshing];
            
        });
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)SetUpSubviews{
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.backGroupType = BackGroupTypeFollowed;
    
    //构建搜索框和切换条
    UIView* headerContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PageW, PageW*HeaderViewRate + 38)];
    headerContainer.backgroundColor = [UIColor whiteColor];
    
    SearchView* searchView = [[SearchView alloc]initWithFrame:CGRectMake(12, 8, PageW-25, 30)];
    self.searchView = searchView;
    [searchView.confirmOrCancelButton setTitle:@"搜索" forState:UIControlStateNormal];
    [searchView.confirmOrCancelButton setTitle:@"取消" forState:UIControlStateSelected];
    searchView.searchTextFailed.placeholder = @"搜索其他好友";
    searchView.delegate = self;
    
    PersonalCenterSectionView* switchView = [[PersonalCenterSectionView alloc] initWithFrame:CGRectMake(0, 38, PageW, PageW*HeaderViewRate)];
    self.switchView = switchView;
    switchView.sectionType = sectionFollow;
    switchView.delegate = self;
    
    [headerContainer addSubview:searchView];
    [headerContainer addSubview:switchView];
    
    self.headerView = headerContainer;
    
    [self.tableview registerNib:[UINib nibWithNibName:NSStringFromClass([MainViewNormalCell class]) bundle:nil] forCellReuseIdentifier:@"MainViewNormalCell"];
    
    [self.tableview registerNib:[UINib nibWithNibName:NSStringFromClass([BakeGroupAdviceCell class] ) bundle:nil] forCellReuseIdentifier:@"BakeGroupAdviceCell"];
}

- (void)setContentMode:(ContentMode)contentMode
{
    _contentMode = contentMode;
    for (UIView* view in self.headerView.subviews) {
        [view removeFromSuperview];
    }
    if (contentMode == ContentModeNormal) {
        self.headerView.frame = CGRectMake(0, 0, PageW, PageW*HeaderViewRate + 38);
        [self.headerView addSubview:self.searchView];
        [self.headerView addSubview:self.switchView];
        self.searchView.searchTextFailed.text = @"";
    } else {
        self.headerView.frame = CGRectMake(0, 0, PageW, PageW*HeaderViewRate);
        [self.headerView addSubview:self.searchView];
        _searchedUsers = [NSMutableArray array];
        _searchPageIndex = 1;
    }
    [self.tableview reloadData];
    
}

#pragma mark - SearchViewDelegate

/**
 *  点击取消/搜索按钮时调用，这里是“搜索”按钮
 */
-(void)TouchUpInsideCancelBtn
{
    self.searchView.confirmOrCancelButton.selected = !self.searchView.confirmOrCancelButton.selected;
    if (self.searchView.confirmOrCancelButton.selected) {
        self.contentMode = ContentModeSearch;
        if (self.searchView.searchTextFailed.text.length == 0) {
            [super showProgressErrorWithLabelText:@"搜索内容不能为空" afterDelay:1];
            return;
        }
        [self loadSearchedUsers];
    } else {
        self.contentMode = ContentModeNormal;
        
    }
    
}

/**
 *  点击输入框开始搜索
 *
 *  @param searchTextFailed 输入框
 */
-(void)StartReach:(UITextField*)searchTextFailed
{
    
}

/**
 *  点击输入框内清除按钮时调用，会清除文本
 */
-(void)Cancel
{
    
}

/**
 *  输入框文本变化时
 *
 *  @param text 文本内容
 */
- (void)textFieldTextChanged:(NSString*)text
{
    
}

/**
 *  点击键盘回车按钮调用
 *
 *  @param string 输入框文本
 */
-(void)TouchUpInsideDone:(NSString *)string
{
    if (!self.searchView.confirmOrCancelButton.selected) {
        self.searchView.confirmOrCancelButton.selected = YES;
        self.contentMode = ContentModeSearch;
    }
    if (self.searchView.searchTextFailed.text.length == 0) {
        [super showProgressErrorWithLabelText:@"搜索内容不能为空" afterDelay:1];
        return;
    }
    [self loadSearchedUsers];
    
}


#pragma mark - PersonalCenterSectonViewDelegate


-(void)SectionType:(NSInteger)type
{
    self.backGroupType = type;
}



-(void)setBackGroupType:(BackGroupType)backGroupType{
    _backGroupType = backGroupType;
    
    if (backGroupType == BackGroupTypeAdvice) {
        [self loadRecommendCookers];
    } else {
        [self loadFollowedCookbooks];
    }
    
    //[self.tableview reloadData];
}



#pragma mark TableDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.contentMode == ContentModeNormal) {
        switch (self.backGroupType) {
            case BackGroupTypeAdvice:
                return self.recommendCookers.count;
                break;
            case BackGroupTypeFollowed:
                return self.followedCookbooks.count;
                break;
            default:
                return 0;
                break;
        }
    } else {
        return self.searchedUsers.count;
    }
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.contentMode == ContentModeNormal) {
        switch (self.backGroupType) {
            case BackGroupTypeAdvice:
                return 93;
                break;
            case BackGroupTypeFollowed:
                return PageW*CellImageRate;
                break;
                
            default:
                return 0;
                break;
        }
    } else {
        return 93;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.contentMode == ContentModeNormal) {
        return PageW*HeaderViewRate + 38;
    } else {
        return PageW*HeaderViewRate;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.contentMode == ContentModeNormal) {
        
        switch (self.backGroupType) {
            case BackGroupTypeFollowed:
            {
                NSString *cellIdentifier =@"MainViewNormalCell";
                MainViewNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                //    cell.cookbook = self.advices[indexPath.row];
                cell.AuthorityLabel.hidden = YES;
                cell.cookbook = self.followedCookbooks[indexPath.row];
                return cell;
                break;
            }
            case BackGroupTypeAdvice:
            {
                NSString *cellIdentifier =@"BakeGroupAdviceCell";
                BakeGroupAdviceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                cell.delegate = self;
                cell.cooker = self.recommendCookers[indexPath.row];
                //    cell.cookbook = self.advices[indexPath.row];
                return cell;
                break;
            }
                
            default:
            {
                
            }
        }
        
    } else {
        NSString *cellIdentifier =@"BakeGroupAdviceCell";
        BakeGroupAdviceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        cell.delegate = self;
        cell.searchedUser = self.searchedUsers[indexPath.row];
        //    cell.cookbook = self.advices[indexPath.row];
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.contentMode == ContentModeNormal) {
        if (self.backGroupType == BackGroupTypeFollowed) {
            //关注人的菜谱
            Cookbook* selectedCookbook = self.followedCookbooks[indexPath.row];
            UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Liukang" bundle:nil];
            CookbookDetailControllerViewController* detailController = [storyboard instantiateViewControllerWithIdentifier:@"Cookbook detail controller"];
            detailController.cookbookId = selectedCookbook.ID;
            detailController.isAuthority = selectedCookbook.isAuthority;
            [self.navigationController pushViewController:detailController animated:YES];
        } else if(self.backGroupType == BackGroupTypeAdvice) {
            //推荐厨师
            Cooker* selectedUser = self.recommendCookers[indexPath.row];
            
            PersonalCenterViewController* personalViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PersonalCenterViewController"];
            
            personalViewController.currentUserId = selectedUser.userBaseId;
            [self.navigationController pushViewController:personalViewController animated:YES];
            
        }
    } else {
        //搜索的用户
        Friend* selectedUser = self.searchedUsers[indexPath.row];
        
        PersonalCenterViewController* personalViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PersonalCenterViewController"];
        
        personalViewController.currentUserId = selectedUser.userBaseId;
        [self.navigationController pushViewController:personalViewController animated:YES];
        
//        if (selectedUser.userLevel == 1 || selectedUser.userLevel == 2) {
//            //跳转到厨神详情
//            
//        } else {
//            //跳转到个人中心
//            
//        }
        
        
        
    }
    
    
}

#define HeaderViewRate         0.1388888

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.headerView;
}


- (void)bakeGroupAdviceCell:(BakeGroupAdviceCell *)cell followed:(UIButton *)sender
{
    if (!IsLogin) {
        [super openLoginController];
        return;
    }
    NSIndexPath* indexPath = [self.tableview indexPathForCell:cell];
    NSString* selectedUserId;
    if (self.contentMode == ContentModeNormal) {
        Cooker* selectedUser = self.recommendCookers[indexPath.row];
        selectedUserId = selectedUser.userBaseId;
    } else {
        Friend* selectedUser = self.searchedUsers[indexPath.row];
        selectedUserId = selectedUser.userBaseId;
    }
    
    NSString* userBaseId = CurrentUserBaseId;
    if (sender.selected) {
        // 已关注，取消关注
        [[InternetManager sharedManager] deleteFollowWithUserBaseId:userBaseId andFollowedUserBaseId:selectedUserId callBack:^(BOOL success, id obj, NSError *error) {
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
        [[InternetManager sharedManager] addFollowWithUserBaseId:userBaseId andFollowedUserBaseId:selectedUserId callBack:^(BOOL success, id obj, NSError *error) {
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
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
