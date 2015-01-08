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
@property (strong, nonatomic) NSArray* cookbooks;
@property (strong, nonatomic) NSMutableArray* tags;
@end

@implementation MenuDraftController

- (void)loadCookbookDrafts
{
    [super showProgressHUDWithLabelText:@"请稍后..." dimBackground:NO];
    [[InternetManager sharedManager] getCookbooksWithUserBaseId:@"5" cookbookStatus:0 pageIndex:1 callBack:^(BOOL success, id obj, NSError *error) {
        [super hiddenProgressHUD];
        if (success) {
            self.cookbooks = obj;
            [self.tableView reloadData];
        } else {
            if (error.code == InternetErrorCodeConnectInternetFailed) {
                [super showProgressErrorWithLabelText:@"无网络" afterDelay:1];
            } else {
                [super showProgressErrorWithLabelText:@"获取草稿失败" afterDelay:1];
            }
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MenuDraftTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"MenuDraftTableViewCell"];
    self.deleteBtn.selected = NO;
    self.delete = self.deleteBtn.selected;
    
    [self loadCookbookDrafts];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return PageW*0.597;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CreatMneuController* editCookbookController = [self.storyboard instantiateViewControllerWithIdentifier:@"CreatMneuController"];
    
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
