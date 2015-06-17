//
//  FoodListViewController.m
//  HaierOven
//
//  Created by dongl on 14/12/18.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "FoodListViewController.h"
#import "FoodListCell.h"
#import "MJRefresh.h"
#import "CookbookDetailControllerViewController.h"

@interface FoodListViewController ()

@property (strong, nonatomic) NSMutableArray* cookbooks;

@property (nonatomic) NSInteger pageIndex;

@end

@implementation FoodListViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.pageIndex = 1;
        self.cookbooks = [NSMutableArray array];
    }
    return self;
}

- (void)loadCookbooks
{
    //统计页面加载耗时
    UInt64 startTime=[[NSDate date]timeIntervalSince1970]*1000;
    if (_pageIndex == 1) {
        [super showProgressHUDWithLabelText:@"请稍候..." dimBackground:NO];
    }
    [[InternetManager sharedManager] getCookbooksWithTagIds:@[self.tagId] pageIndex:_pageIndex callBack:^(BOOL success, id obj, NSError *error) {
        [super hiddenProgressHUD];
        if (success) {
            NSArray* arr = obj;
            if (arr.count < PageLimit && _pageIndex != 1) {
//                [super showProgressErrorWithLabelText:@"没有更多了..." afterDelay:1];
            }
            if (_pageIndex == 1) {
                if (arr.count == 0) {
                    [super showProgressErrorWithLabelText:@"没有更多数据了..." afterDelay:1];
                    [self.tableView removeFooter];
                }
                
                self.cookbooks = obj;
            } else {
                [self.cookbooks addObjectsFromArray:arr];
            }
            
            [self.tableView reloadData];
            UInt64 endTime=[[NSDate date]timeIntervalSince1970]*1000;
            [uAnalysisManager onActivityResumeEvent:((long)(endTime-startTime)) withModuleId:@"标签食谱列表页面"];
            
        } else {
            if (error.code == InternetErrorCodeConnectInternetFailed) {
                [super showProgressErrorWithLabelText:@"无网络" afterDelay:1];
            } else {
                [super showProgressErrorWithLabelText:@"加载失败" afterDelay:1];
            }
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    // This screen name value will remain set on the tracker and sent with hits until it is set to a new value or to nil.
//    [[GAI sharedInstance].defaultTracker set:kGAIScreenName value:@"标签菜谱列表页面"];
//    [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createAppView] build]];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    [self addHeader];
    [self addFooter];
    [self loadCookbooks];
    
}

- (void)addHeader
{
    __unsafe_unretained typeof(self) vc = self;
    // 添加上拉刷新尾部控件
    
    [self.tableView addHeaderWithCallback:^{
        // 进入刷新状态就会回调这个Block
        
        // 增加根据pageIndex加载数据
        vc.pageIndex = 1;
        [vc loadCookbooks];
        
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
        [vc loadCookbooks];
        
        // 加载数据，0.5秒后执行
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            // 结束刷新
            [vc.tableView footerEndRefreshing];
            
        });
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)TurnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    NSString* category = [self.title stringByAppendingString:@" page"];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:category     // Event category (required)
                                                          action:@"Back"  // Event action (required)
                                                           label:nil          // Event label
                                                           value:nil] build]];    // Event value
}

#pragma mark TableDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellIdentifier =@"FoodListCell";
    FoodListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.backgroundColor = [UIColor whiteColor];
    
    cell.cookbook = self.cookbooks[indexPath.row];
    
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cookbooks.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        return 95;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Liukang" bundle:nil];
    CookbookDetailControllerViewController* cookbookDetailController = [storyboard instantiateViewControllerWithIdentifier:@"Cookbook detail controller"];
    Cookbook* cookbook = self.cookbooks[indexPath.row];
    cookbookDetailController.cookbookId = cookbook.ID;
    [self.navigationController pushViewController:cookbookDetailController animated:YES];
    
    NSString* category = [self.title stringByAppendingString:@" page"];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:category     // Event category (required)
                                                          action:cookbook.name  // Event action (required)
                                                           label:nil          // Event label
                                                           value:nil] build]];    // Event value
}

#pragma mark-

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
