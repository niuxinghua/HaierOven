//
//  MenuDraftController.m
//  HaierOven
//
//  Created by dongl on 14/12/28.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "MenuDraftController.h"
#import "MenuDraftTableViewCell.h"
#import "CreatMneuController.h"
@interface MenuDraftController ()<MenuDraftTableViewCellDelegate>
@property (strong, nonatomic) IBOutlet UIButton *deleteBtn;
@property bool delete;
@property (strong, nonatomic) NSMutableArray* cookbooks;
@property (strong, nonatomic) NSMutableArray* tags;
@property (nonatomic) NSInteger pageIndex;
@end

@implementation MenuDraftController

#pragma mark - 获取菜谱列表

- (void)loadCookbookDrafts
{
    if (!IsLogin) {
        [super openLoginController];
        return;
    }
    
    //统计页面加载耗时
    UInt64 startTime=[[NSDate date]timeIntervalSince1970]*1000;
    if (_pageIndex == 1) {
        [super showProgressHUDWithLabelText:@"请稍候..." dimBackground:NO];
    }
    
    [[InternetManager sharedManager] getCookbooksWithUserBaseId:CurrentUserBaseId cookbookStatus:0 pageIndex:_pageIndex callBack:^(BOOL success, id obj, NSError *error) {
        [super hiddenProgressHUD];
        if (success) {
            
            NSArray* arr = obj;
            if (arr.count < PageLimit && _pageIndex != 1) {
                [self.tableView removeFooter];
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
            [uAnalysisManager onActivityResumeEvent:((long)(endTime-startTime)) withModuleId:@"草稿箱页面"];
            
        } else {
            if (error.code == InternetErrorCodeConnectInternetFailed) {
                [super showProgressErrorWithLabelText:@"无网络" afterDelay:1];
            } else {
                [super showProgressErrorWithLabelText:@"获取草稿失败" afterDelay:1];
            }
        }
    }];
}

#pragma mark - 加载和初始化

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.pageIndex = 1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Upload Cookbook"     // Event category (required)
                                                          action:@"draft box"  // Event action (required)
                                                           label:nil          // Event label
                                                           value:nil] build]];    // Event value
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MenuDraftTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"MenuDraftTableViewCell"];
    self.deleteBtn.selected = NO;
    self.delete = self.deleteBtn.selected;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self loadCookbookDrafts];
    
    [self addHeader];
    [self addFooter];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadCookbookDrafts) name:SubmitCookbookSuccessNotification object:nil];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addHeader
{
    __unsafe_unretained typeof(self) vc = self;
    // 添加上拉刷新尾部控件
    
    [self.tableView addHeaderWithCallback:^{
        // 进入刷新状态就会回调这个Block
        
        // 增加根据pageIndex加载数据
        vc.pageIndex = 1;
        [vc loadCookbookDrafts];
        
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
        [vc loadCookbookDrafts];
        
        // 加载数据，0.5秒后执行
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            // 结束刷新
            [vc.tableView footerEndRefreshing];
            
        });
        
    }];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
//    return 10;
    return self.cookbooks.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuDraftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuDraftTableViewCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.tag      = indexPath.row;
    cell.isEdit   = self.delete;
    cell.cookbook = self.cookbooks[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return PageW*0.8;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CreatMneuController* editCookbookController = [self.storyboard instantiateViewControllerWithIdentifier:@"CreatMneuController"];
    MenuDraftTableViewCell* cell = (MenuDraftTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    editCookbookController.cookbookCoverPhoto = cell.coverImage.image;
    editCookbookController.cookbook = self.cookbooks[indexPath.row];
    editCookbookController.isDraft = YES;
    [self loadTagsCompletion:^(BOOL result) {
        editCookbookController.tags = self.tags;
        [self.navigationController pushViewController:editCookbookController animated:YES];
    }];
    
}

- (void)loadTagsCompletion:(result)callback
{
    [super showProgressHUDWithLabelText:@"请稍候..." dimBackground:NO];
    [[InternetManager sharedManager] getTagsCallBack:^(BOOL success, id obj, NSError *error) {
        [super hiddenProgressHUD];
        if (success) {
            
            self.tags = obj;
            
            callback(YES);
        } else {
            if (error.code == InternetErrorCodeConnectInternetFailed) {
                [super showProgressErrorWithLabelText:@"网络连接失败" afterDelay:1];
            } else {
                [super showProgressErrorWithLabelText:@"获取标签失败" afterDelay:1];
            }
            callback(NO);
        }
    }];
}

-(void)DeleteDraftMneu:(UITableViewCell *)cell{
    NSLog(@"%d",cell.tag);
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    Cookbook* cookbook = self.cookbooks[indexPath.row];
    [self.cookbooks removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    [[InternetManager sharedManager] deleteCookbookWithCookbookId:cookbook.ID callBack:^(BOOL success, id obj, NSError *error) {
        if (success) {
            NSLog(@"删除成功");
        } else {
            NSLog(@"删除失败");
        }
    }];
    
}
- (IBAction)Delete:(UIButton*)sender {
    sender.selected = sender.selected ==YES?NO:YES;
    self.delete = sender.selected;
    [self.tableView reloadData];
}
- (IBAction)TurnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
