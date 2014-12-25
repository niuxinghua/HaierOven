//
//  DeviceBoardViewController.m
//  HaierOven
//
//  Created by dongl on 14/12/23.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "DeviceBoardViewController.h"
#import "DeviceMessageController.h"
#import "DeviceEditController.h"
#import "DeviceWorkView.h"
@interface DeviceBoardViewController ()
@property (strong, nonatomic) IBOutlet DeviceWorkView *startStatusView;
@property (strong, nonatomic) NSTimer *timeable;
@property int time;
@property (strong, nonatomic) IBOutlet UIScrollView *deviceScrollView;
@property (strong, nonatomic) NSMutableArray *workModelBtns;
@end

@implementation DeviceBoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SetUpSubviews];
    
}

-(void)SetUpSubviews{
    self.tableView.backgroundView = [[UIImageView alloc]initWithImage:IMAGENAMED(@"boardbg")];
    
    //点击运行后显示
    self.timeable =  [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    self.time = 30;
    float animateDueation = 30;
    self.startStatusView.animationDuration = animateDueation;
    [self.startStatusView.lineProgressView setCompleted:1.0*80 animated:YES];

    NSArray *cxz = @[@"cthp-cxz",@"dlfp-cxz",@"rfpk-cxz",@"pk-cxz",@"sk-cxz"];
    NSArray *xz = @[@"cthp-xz",@"dlfp-xz",@"rfpk-xz",@"pk-xz",@"sk-xz"];
    NSArray *wxz = @[@"cthp-wxz",@"dlfp-wxz",@"rfpk-wxz",@"pk-wxz",@"sk-wxz"];
    self.workModelBtns = [NSMutableArray new];
    for (int i = 0; i<cxz.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:IMAGENAMED(cxz[i]) forState:UIControlStateNormal];
        [btn setBackgroundImage:IMAGENAMED(xz[i]) forState:UIControlStateSelected];
        [btn setBackgroundImage:IMAGENAMED(wxz[i]) forState:UIControlStateDisabled];
        btn.tag = i;
        [btn addTarget:self action:@selector(WorkModelChick:) forControlEvents:UIControlEventTouchUpInside];
        float high = PageW/5/69.0*89;
        btn.frame = CGRectMake(1.5+i*(PageW/5), 4, (PageW/5-3), high);
        [self.deviceScrollView addSubview:btn];
        [self.workModelBtns addObject:btn];
    }
    
    for (UIButton *btn in self.workModelBtns) {
        [btn setEnabled:NO];
    }
}

-(void)WorkModelChick:(UIButton*)sender{

}
-(void)timerAction:(NSTimer *)time{
    if (time == 0) {
        [self.timeable invalidate];
        self.timeable = nil;
    }
    self.time = self.time==0? 0:self.time-1;
    self.startStatusView.leftTime = [NSString stringWithFormat:@"%i s",self.time];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
          return PageW*0.167;
            break;
        case 1:
         return   PageW*0.278;
            break;
        case 2:
          return  PageW*0.33;
            break;
        case 4:
            return  PageW*0.1528;
            break;
        case 5:
            return  PageW*0.1528;
            break;
        case 3:
          return  PageW*0.375;
            break;
        default:
            return 0;
            break;
    }
}
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
- (IBAction)TurnEdit:(id)sender {
    DeviceEditController *edit = [self.storyboard instantiateViewControllerWithIdentifier:@"DeviceEditController"];
    [self.navigationController pushViewController:edit animated:YES];
}
- (IBAction)TurnMessage:(id)sender {
    DeviceMessageController *message = [self.storyboard instantiateViewControllerWithIdentifier:@"DeviceMessageController"];
    [self.navigationController pushViewController:message animated:YES];
}

@end
