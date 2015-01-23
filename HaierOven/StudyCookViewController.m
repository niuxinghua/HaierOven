//
//  StudyCookViewController.m
//  HaierOven
//
//  Created by dongl on 15/1/20.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "StudyCookViewController.h"
#import "StudyCookCell.h"
#import "StudyDetailController.h"
@interface StudyCookViewController ()<StudyCookCellDelegate,StudyCookViewDelegate>
{
    BOOL      isfixed;
    NSInteger indexFiex;
    
}
@property (strong, nonatomic) NSArray *arr;
@property (strong, nonatomic) NSArray *images;
@property (strong, nonatomic) UIButton *tempBtn;
@end

@implementation StudyCookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.arr=@[@"123",@"123",@"123",@"123",@"123"];
    self.images = @[IMAGENAMED(@"fresh-group-1.png"),IMAGENAMED(@"fresh-group-2.png"),IMAGENAMED(@"fresh-group-3.png")];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[MyTool createImageWithColor:GlobalOrangeColor] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
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
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  isfixed&&indexFiex == indexPath.row? 80 + self.arr.count * 45+16:80;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StudyCookCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StudyCookCell" forIndexPath:indexPath];
    cell.details=self.arr;
    cell.bkImage = self.images[indexPath.row];
    cell.title = @"标题";
    cell.delegate = self;
    // Configure the cell...
    
    return cell;
}

-(void)fixedCell:(StudyCookCell *)cell{
    NSIndexPath *index = [self.tableView indexPathForCell:cell];
    
    if (self.tempBtn.tag != index.row)
        self.tempBtn.selected = !self.tempBtn.selected;
    
    
    isfixed = cell.icon.selected;
    if (cell.icon.selected) {
        indexFiex = index.row;
        
        self.tempBtn = cell.icon;
        self.tempBtn.tag = index.row;
    }
    [self.tableView reloadData];
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
- (IBAction)TurnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)getSelectedView:(StudyCookView *)studycook{
    NSLog(@"%d",studycook.tag);
    StudyDetailController * detail = [self.storyboard instantiateViewControllerWithIdentifier:@"StudyDetailController"];
    [self.navigationController pushViewController:detail animated:YES];
}

@end
