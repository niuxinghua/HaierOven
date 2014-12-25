//
//  RelationshipListViewController.m
//  HaierOven
//
//  Created by dongl on 14/12/22.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "RelationshipListViewController.h"
#import "RelationshipCell.h"
#define CellRate 0.167
@interface RelationshipListViewController ()
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation RelationshipListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = self.iswathching?@"已关注列表":@"粉丝列表";
    
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
    return 10;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RelationshipCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RelationshipCell" forIndexPath:indexPath];
    cell.watchingBtn.selected = self.iswathching;
    // Configure the cell...
    
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
