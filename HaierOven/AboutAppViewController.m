//
//  AboutAppViewController.m
//  HaierOven
//
//  Created by dongl on 15/1/20.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "AboutAppViewController.h"
#import "AboutAppCell.h"
@interface AboutAppViewController ()
@property (strong, nonatomic) NSArray * contentArr;
@property (strong, nonatomic) NSArray * titleArr;
@end

@implementation AboutAppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentArr = @[@"“味之道”，由海尔开发并运营。我们致力于建立一个美食平台。在此平台上可获取精准的美食菜谱、可与好友分享美食以及其中经验与快乐，以享受最佳的烹饪体验。",
                        @"美食可带来无尽的欢乐，而这种快乐需要与家人、好友进行分享，这种快乐可以让亲情、友情、爱情更紧密。而我们要做的就是教你如何制造生活的欢乐并将这份欢乐传递出去。",
                        @"依托于海尔强大创新能力以及资源整合能力，我们有近百人团队以及数十位酒店大厨一起研究最适合中国厨房的美味和厨房电器。",
                        
                        @"我们的美食实验室会不断的研发新的菜谱，酒店大厨、美食达人也会不断的入驻，只为为您提供提供更丰富、更精准、更精致的菜谱。\n您可通过我们的平台上传菜谱与好友分享，并进行收藏和点评。\n您可通过不断的经验积累逐渐成为大厨，与我们一道服务用户。\n您可以通过此平台与我们交流您期望的产品和服务，以便我们不断进步。\n欢迎您现在就加入“味之道”！"];
    
    self.titleArr = @[@"“味之道”是什么",
                      @"一个美食社区",
                      @"我们的团队",
                      @"我们的服务"];
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
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AboutAppCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AboutAppCell" forIndexPath:indexPath];
    cell.title = self.titleArr[indexPath.row];
    cell.content = self.contentArr[indexPath.row];
    // Configure the cell...
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [MyUtils getTextSizeWithText:self.contentArr[indexPath.row] andTextAttribute:@{NSFontAttributeName:[UIFont fontWithName:GlobalTextFontName size:12]} andTextWidth:PageW - 36].height+20+8+4+21;
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

@end
