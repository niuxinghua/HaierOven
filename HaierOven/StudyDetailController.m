//
//  StudyDetailController.m
//  HaierOven
//
//  Created by dongl on 15/1/20.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "StudyDetailController.h"
#import "StudyDetailCell.h"
#import "StudyDetailFiexView.h"
@interface StudyDetailController ()
{
    CGFloat fiexViewHeight;
}
@property (weak, nonatomic) IBOutlet UIButton *titleBtn;
@property (strong, nonatomic) UIWindow *myWindow;
@property (strong, nonatomic) NSArray *tools;
@property (strong, nonatomic) StudyDetailFiexView *fiexView;
@end

@implementation StudyDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fakeData];
    self.myWindow = [UIWindow new];
    self.myWindow.frame = CGRectMake(0, 64, PageW, PageH);
    self.myWindow.backgroundColor = [UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:0.3];
    self.myWindow.windowLevel = UIWindowLevelAlert;
    [self.myWindow makeKeyAndVisible];
    self.myWindow.userInteractionEnabled = YES;
    self.myWindow.hidden = YES;

    [self addObserver:self forKeyPath:@"self.myWindow.hidden" options:NSKeyValueObservingOptionNew context:NULL];
    
    self.fiexView = [StudyDetailFiexView new];
    self.fiexView.backgroundColor    = [UIColor yellowColor];
    fiexViewHeight = self.tools.count*44+16;
    self.fiexView.frame = CGRectMake(25, 0, PageW-50, 0);
    [self.myWindow addSubview:self.fiexView];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


-(void)fakeData{
    self.tools = @[@"123",@"123",@"123",@"123",@"123"];
}
- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"self.myWindow.hidden"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"self.myWindow.hidden"]) {

    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 3;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StudyDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StudyDetailCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
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
- (IBAction)fiexViewShow:(UIButton*)sender {
    self.myWindow.hidden = sender.selected;
    sender.selected = !sender.selected;
    if (self.myWindow.hidden) {
        CGRectMake(25, 0, PageW-50, 0);
    }else{
    [UIView animateWithDuration:0.5 animations:^{
        self.fiexView.frame = CGRectMake(25, 0, PageW-50, fiexViewHeight);
    }];
    }
    
}

- (IBAction)TurnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
