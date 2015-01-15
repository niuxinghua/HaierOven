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

@interface BakedGroupController ()<PersonalCenterSectionViewDelegate,BackGroupAdviceCellDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) NSMutableArray *followedCookbooks;
@property (strong, nonatomic) NSMutableArray *recommendCookers;
@property (strong, nonatomic) PersonalCenterSectionView* headerView;
@property (nonatomic) NSInteger followPageIndex;
@property (nonatomic) NSInteger recommentPageIndex;
@end
#define HeaderViewRate         0.1388888
#define CellImageRate   0.6
@implementation BakedGroupController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.followPageIndex = 1;
        self.recommentPageIndex = 1;
        self.followedCookbooks = [NSMutableArray array];
        self.recommendCookers = [NSMutableArray array];
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
    [super showProgressHUDWithLabelText:@"请稍后" dimBackground:NO];
    NSString* userBaseId = CurrentUserBaseId;
    [[InternetManager sharedManager] getFriendCookbooksWithUserBaseId:userBaseId pageIndex:self.followPageIndex callBack:^(BOOL success, id obj, NSError *error) {
        [super hiddenProgressHUD];
        if (success) {
            NSArray* arr = obj;
            if (arr.count < PageLimit && _followPageIndex != 1) {
                [super showProgressErrorWithLabelText:@"没有更多了..." afterDelay:1];
            }
            if (_followPageIndex == 1) {
                self.followedCookbooks = obj;
            } else {
                [self.followedCookbooks addObjectsFromArray:arr];
            }
            
            [self.tableview reloadData];
            
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
    [[InternetManager sharedManager] getRecommentCookersWithUserBaseId:userBaseId pageIndex:self.recommentPageIndex callBack:^(BOOL success, id obj, NSError *error) {
        if (success) {
            NSArray* arr = obj;
            if (arr.count < PageLimit && _recommentPageIndex != 1) {
                [super showProgressErrorWithLabelText:@"没有更多了..." afterDelay:1];
            }
            if (_recommentPageIndex == 1) {
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


- (void)viewDidLoad {
    [super viewDidLoad];
    [self SetUpSubviews];
    
    [self loadFollowedCookbooks];
    [self loadRecommendCookers];
    
    [self addHeader];
    [self addFooter];
    
    // Do any additional setup after loading the view.
}

- (void)addHeader
{
    __unsafe_unretained typeof(self) vc = self;
    // 添加上拉刷新尾部控件
    
    [self.tableview addHeaderWithCallback:^{
        // 进入刷新状态就会回调这个Block
        
        // 增加根据pageIndex加载数据
        
        if (vc.backGroupType == BackGroupTypeAdvice) {
            // 推荐
            vc.recommentPageIndex = 1;
            [vc loadRecommendCookers];
        } else {
            vc.followPageIndex = 1;
            [vc loadFollowedCookbooks];
            
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
        if (vc.backGroupType == BackGroupTypeAdvice) {
            // 推荐
            vc.recommentPageIndex++;
            [vc loadRecommendCookers];
        } else {
            vc.followPageIndex++;
            [vc loadFollowedCookbooks];
            
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
    
    self.headerView = [[PersonalCenterSectionView alloc] initWithFrame:CGRectMake(0, 0, PageW, PageW*HeaderViewRate) ];
    self.headerView.sectionType = sectionFollow;
    self.headerView.delegate = self;

    
    [self.tableview registerNib:[UINib nibWithNibName:NSStringFromClass([MainViewNormalCell class]) bundle:nil] forCellReuseIdentifier:@"MainViewNormalCell"];
    
    [self.tableview registerNib:[UINib nibWithNibName:NSStringFromClass([BakeGroupAdviceCell class] ) bundle:nil] forCellReuseIdentifier:@"BakeGroupAdviceCell"];
}

#pragma mark TableDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.backGroupType ==BackGroupTypeAdvice?self.recommendCookers.count:self.followedCookbooks.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  self.backGroupType ==BackGroupTypeAdvice?93:PageW*CellImageRate;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return PageW*HeaderViewRate;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (self.backGroupType) {
        case BackGroupTypeFollowed:{
            NSString *cellIdentifier =@"MainViewNormalCell";
            MainViewNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            //    cell.cookbook = self.advices[indexPath.row];
            cell.AuthorityLabel.hidden = YES;
            cell.cookbook = self.followedCookbooks[indexPath.row];
            return cell;
            break;
        }
            
        default:{
            NSString *cellIdentifier =@"BakeGroupAdviceCell";
            BakeGroupAdviceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            cell.delegate = self;
            cell.cooker = self.recommendCookers[indexPath.row];
            //    cell.cookbook = self.advices[indexPath.row];
            return cell;
            break;
        }
    }
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.backGroupType == BackGroupTypeFollowed) {
        //关注人的菜谱
        Cookbook* selectedCookbook = self.followedCookbooks[indexPath.row];
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Liukang" bundle:nil];
        CookbookDetailControllerViewController* detailController = [storyboard instantiateViewControllerWithIdentifier:@"Cookbook detail controller"];
        detailController.cookbook = selectedCookbook;
        [self.navigationController pushViewController:detailController animated:YES];
    } else {
        //推荐厨师
        
    }
}

#define HeaderViewRate         0.1388888
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    return self.headerView;
}

-(void)SectionType:(NSInteger)type{
    self.backGroupType = type;
}



-(void)setBackGroupType:(BackGroupType)backGroupType{
    _backGroupType = backGroupType;
    [self.tableview reloadData];
}

- (void)bakeGroupAdviceCell:(BakeGroupAdviceCell *)cell followed:(UIButton *)sender
{
    if (!IsLogin) {
        [super openLoginController];
        return;
    }
    NSIndexPath* indexPath = [self.tableview indexPathForCell:cell];
    Cooker* selectedCooker = self.recommendCookers[indexPath.row];
    NSString* userBaseId = CurrentUserBaseId;
    if (sender.selected) {
        // 已关注，取消关注
        [[InternetManager sharedManager] deleteFollowWithUserBaseId:userBaseId andFollowedUserBaseId:selectedCooker.userBaseId callBack:^(BOOL success, id obj, NSError *error) {
            if (success) {
                NSLog(@"取消关注成功");
            } else {
                [super showProgressErrorWithLabelText:@"取消失败" afterDelay:1];
            }
        }];
    } else {
        // 未关注，添加关注
        [[InternetManager sharedManager] addFollowWithUserBaseId:userBaseId andFollowedUserBaseId:selectedCooker.userBaseId callBack:^(BOOL success, id obj, NSError *error) {
            if (success) {
                NSLog(@"关注成功");
            } else {
                [super showProgressErrorWithLabelText:@"关注失败" afterDelay:1];
            }
        }];
    }
    
    
    
    
    sender.selected = !sender.selected;
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
