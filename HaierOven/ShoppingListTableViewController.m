//
//  ShoppingListTableViewController.m
//  HaierOven
//
//  Created by dongl on 15/1/5.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "ShoppingListTableViewController.h"
#import "CookListCell.h"
#import "DeleteCookViewController.h"
#import "CookbookDetailControllerViewController.h"
@interface ShoppingListTableViewController () <CookListCellDelegate>

@property (weak, nonatomic) IBOutlet UILabel *shoppingListCountLabel;

@property (strong, nonatomic) NSArray* shoppingList;

@end

@implementation ShoppingListTableViewController

#pragma mark - 获取购物清单列表

- (void)loadShoppingList
{
    if (!IsLogin) {
//        [super openLoginController];
//        return;
    }
    
    [super showProgressHUDWithLabelText:@"获取购物清单" dimBackground:NO];
    
    NSString* userBaseId = CurrentUserBaseId;
    
    [[InternetManager sharedManager] getShoppingListWithUserBaseId:userBaseId callBack:^(BOOL success, id obj, NSError *error) {
        [super hiddenProgressHUD];
        if (success) {
            self.shoppingList = obj;
            self.shoppingListCountLabel.text = [NSString stringWithFormat:@"已添加%d个菜谱",self.shoppingList.count];
            [self.tableView reloadData];
            
        } else {
            [super showProgressErrorWithLabelText:@"加载失败" afterDelay:1];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMarkStatus:) name:MessageCountUpdateNotification object:nil];
    if ([DataCenter sharedInstance].messagesCount > 0 && IsLogin) {
        [self markNewMessage];
    } else {
        [self deleteMarkLabel];
    }
    
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadShoppingList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return self.shoppingList.count;
}





-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShoppingOrder* shoppingOder = self.shoppingList[indexPath.section];
    return 50+(shoppingOder.foods.count*40);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CookListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CookListCell" forIndexPath:indexPath];
    cell.delegate = self;
    ShoppingOrder* shoppingOrder = self.shoppingList[indexPath.section];
    cell.foods = shoppingOrder.foods;
    [cell.cookbookNameBtn setTitle:shoppingOrder.cookbookName forState:UIControlStateNormal];
    // Configure the cell...
    
    return cell;
}

#pragma mark - CookListCellDelegate

- (void)turnCookDetailView:(UITableViewCell *)cell
{
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    ShoppingOrder* selectedOrder = self.shoppingList[indexPath.section];
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Liukang" bundle:nil];
    CookbookDetailControllerViewController* detailController = [storyboard instantiateViewControllerWithIdentifier:@"Cookbook detail controller"];
    detailController.cookbookId = selectedOrder.cookbookID;
    [self.navigationController pushViewController:detailController animated:YES];
}

- (void)purchaseFood:(PurchaseFood *)food inCell:(CookListCell *)cell isPurchased:(BOOL)isPurchased
{
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    ShoppingOrder* changedOrder = self.shoppingList[indexPath.section];
    [[InternetManager sharedManager] saveShoppingOrderWithShoppingOrder:changedOrder callBack:^(BOOL success, id obj, NSError *error) {
        if (success) {
            NSLog(@"成功");
        } else {
            [super showProgressErrorWithLabelText:@"保存失败" afterDelay:1];
        }
    }];
}


#pragma mark-  跳至删除页面
- (IBAction)turnDeleteCookView:(id)sender {
    DeleteCookViewController *deleteCook = [self.storyboard instantiateViewControllerWithIdentifier:@"DeleteCookViewController"];
    deleteCook.shoppingList = [self.shoppingList mutableCopy];
    [self.navigationController pushViewController:deleteCook animated:YES];
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
