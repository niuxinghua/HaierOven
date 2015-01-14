//
//  DeleteCookViewController.m
//  HaierOven
//
//  Created by dongl on 15/1/7.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "DeleteCookViewController.h"
#import "DeleteCookCell.h"
@interface DeleteCookViewController ()<DeleteCookCellDelegate>

@property (weak, nonatomic) IBOutlet UILabel *shoppingListCountLabel;

@property (strong, nonatomic) IBOutlet UIButton *deleteBtn;

/**
 *  纪录删除菜谱数组
 */
@property (strong, nonatomic) NSMutableArray *deleteArr;
@end

@implementation DeleteCookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.deleteArr = [NSMutableArray new];
    
    self.shoppingListCountLabel.text = [NSString stringWithFormat:@"已添加%d个菜谱", self.shoppingList.count];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)reload
{
    [self.tableView reloadData];
    self.shoppingListCountLabel.text = [NSString stringWithFormat:@"已添加%d个菜谱", self.shoppingList.count];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.shoppingList.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DeleteCookCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeleteCookCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.isAllselected = self.deleteBtn.selected;
    ShoppingOrder* shoppingOrder = self.shoppingList[indexPath.row];
    cell.cookString = shoppingOrder.cookbookName;
    // Configure the cell...
    
    return cell;
}


#pragma mark -  删除按钮点击事件
- (IBAction)DeleteFoods:(UIButton *)sender {
    if (sender.selected==NO) {
        sender.selected = YES;
        self.deleteArr = [self.shoppingList mutableCopy];
        [self reload];
        
    }else if (sender.selected ==YES){
        NSLog(@"我要删除了");
        sender.selected = NO;
        
        [self.shoppingList removeObjectsInArray:self.deleteArr];
        
        [self deleteShoppingList];

        [self reload];
    }
}

- (void)deleteShoppingList
{
    NSString* userBaseId = @"5";
    [[InternetManager sharedManager] deleteShoppingOrderWithUserBaseId:userBaseId
                                                           cookbooks:self.deleteArr
                                                              callBack:^(BOOL success, id obj, NSError *error) {
                                                                  if (success) {
                                                                      NSLog(@"删除成功");
                                                                  } else {
                                                                      NSLog(@"保存失败");
                                                                      [super showProgressErrorWithLabelText:@"保存失败" afterDelay:1];
                                                                  }
                                                              }];
}


#pragma mark- DeleteFoodCell回调事件
-(void)DeleteFoodCell:(UITableViewCell *)cell adnDeleteBtn:(UIButton *)btn{
    NSIndexPath *index = [self.tableView indexPathForCell:cell];
    
    if (btn.selected == NO) {
        [self.deleteArr removeObject:self.shoppingList[index.row]];
    }else{
        [self.deleteArr addObject:self.shoppingList[index.row]];
    }
    
    self.deleteBtn.selected = self.deleteArr.count > 0?YES:NO;
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
