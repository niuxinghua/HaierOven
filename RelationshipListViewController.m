//
//  RelationshipListViewController.m
//  HaierOven
//
//  Created by dongl on 14/12/22.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "RelationshipListViewController.h"
#import "RelationshipCell.h"
#import "MJRefresh.h"
#define CellRate 0.167
@interface RelationshipListViewController ()
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) NSMutableArray* friends;
@property (nonatomic) NSInteger pageIndex;
@end

@implementation RelationshipListViewController

- (void)loadMyFans // 粉丝
{
    [[InternetManager sharedManager] getFansWithUserBaseId:self.userBaseId andPageIndex:_pageIndex callBack:^(BOOL success, id obj, NSError *error) {
        if (success) {
            NSArray* arr = obj;
            if (arr.count < PageLimit && _pageIndex != 1) {
                [super showProgressErrorWithLabelText:@"没有更多了..." afterDelay:1];
            }
            if (_pageIndex == 1) {
                self.friends = obj;
            } else {
                [self.friends addObjectsFromArray:arr];
            }
            
            [self.tableView reloadData];
        }
    }];
    
}

- (void)loadMyFollowers //我关注的人
{
    [[InternetManager sharedManager] getFollowersWithUserBaseId:self.userBaseId andPageIndex:_pageIndex callBack:^(BOOL success, id obj, NSError *error) {
        if (success) {
            NSArray* arr = obj;
            if (arr.count < PageLimit && _pageIndex != 1) {
                [super showProgressErrorWithLabelText:@"没有更多了..." afterDelay:1];
            }
            if (_pageIndex == 1) {
                self.friends = obj;
            } else {
                [self.friends addObjectsFromArray:arr];
            }
            
            [self.tableView reloadData];
        }
    }];
    
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.friends = [NSMutableArray array];
        self.pageIndex = 1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = self.iswathching?@"已关注列表":@"粉丝列表";
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self addHeader];
    [self addFooter];
    
    if (self.iswathching) {
        [self loadMyFollowers];
    } else {
        [self loadMyFans];
    }
    
}

- (void)addHeader
{
    __unsafe_unretained typeof(self) vc = self;
    // 添加上拉刷新尾部控件
    
    [self.tableView addHeaderWithCallback:^{
        // 进入刷新状态就会回调这个Block
        
        // 增加根据pageIndex加载数据
        vc.pageIndex = 1;
        if (vc.iswathching) {
            [vc loadMyFollowers];
        } else {
            [vc loadMyFans];
        }
        
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
        if (vc.iswathching) {
            [vc loadMyFollowers];
        } else {
            [vc loadMyFans];
        }
        
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.friends.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RelationshipCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RelationshipCell" forIndexPath:indexPath];
    cell.watchingBtn.selected = self.iswathching;
    // Configure the cell...
    cell.user = self.friends[indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return PageW*CellRate;
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
- (IBAction)TurnAdd:(id)sender {
    NSLog(@"添加");
}
- (IBAction)TurnSearch:(id)sender {
    NSLog(@"搜索");
}
- (IBAction)TurnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
