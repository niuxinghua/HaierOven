//
//  DeviceEditController.m
//  HaierOven
//
//  Created by dongl on 14/12/23.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "DeviceEditController.h"
#import "YIPopupTextView.h"

@interface DeviceEditController () <YIPopupTextViewDelegate>
@property (strong, nonatomic) IBOutlet UIButton *deleteBtn;
@property (strong, nonatomic) YIPopupTextView* popupTextView;
@end

@implementation DeviceEditController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SetUpSubviews];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)SetUpSubviews{
    self.deleteBtn.layer.masksToBounds = YES;
    self.deleteBtn.layer.cornerRadius = 15;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}
- (IBAction)DeleteBtn:(id)sender {
    NSLog(@"删除");
    
    [[DataCenter sharedInstance] removeOvenInLocal:self.currentOven];
    
    [super showProgressErrorWithLabelText:@"设备已删除" afterDelay:1];
    
    [self performSelector:@selector(close) withObject:nil afterDelay:2];
    [[NSNotificationCenter defaultCenter] postNotificationName:DeleteLocalOvenSuccessNotification object:nil];
    
}
- (IBAction)TurnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)close
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (self.popupTextView) {
        [self.popupTextView resignFirstResponder];
        self.popupTextView = nil;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {   //重命名
        
        BOOL editable = YES;
        
        YIPopupTextView* popupTextView =
        [[YIPopupTextView alloc] initWithPlaceHolder:@"请输入留言内容"
                                            maxCount:500
                                         buttonStyle:YIPopupTextViewButtonStyleRightCancelAndDone];
        popupTextView.delegate = self;
        popupTextView.caretShiftGestureEnabled = YES;       // default = NO. using YISwipeShiftCaret is recommended.
        popupTextView.editable = editable;                  // set editable=NO to show without keyboard
        
        popupTextView.outerBackgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        
        [popupTextView showInViewController:self];
        
        popupTextView.text = self.currentOven.name;
        
        _popupTextView = popupTextView;
        
        
#if defined(__IPHONE_7_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
        if (IS_IOS_AT_LEAST(@"7.0")) {
            [self setNeedsStatusBarAppearanceUpdate];
        }
#endif
        
    } else {    //设置时间
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"hh:mm";
        NSString* time = [formatter stringFromDate:[NSDate date]];
        
        uSDKDeviceAttribute* cmd = [[OvenManager sharedManager] structureWithCommandName:kBootUp commandAttrValue:kBootUp];
        [[OvenManager sharedManager] executeCommands:[@[cmd] mutableCopy]
                                            toDevice:self.myOven
                                        andCommandSN:0
                                 andGroupCommandName:@""
                                            callback:^(BOOL success, uSDKErrorConst errorCode) {
                                                
                                                uSDKDeviceAttribute* command = [[OvenManager sharedManager] structureWithCommandName:@"20v00i" commandAttrValue:time];
                                                [super showProgressHUDWithLabelText:@"请稍候..." dimBackground:NO];
                                                [[OvenManager sharedManager] executeCommands:[@[command] mutableCopy] toDevice:self.myOven andCommandSN:0 andGroupCommandName:@"" callback:^(BOOL success, uSDKErrorConst errorCode) {
                                                    [super hiddenProgressHUD];
                                                    [super showProgressCompleteWithLabelText:@"时间已同步" afterDelay:1];
                                                }];
                                                
                                            }];
        
    }
}

#pragma mark YIPopupTextViewDelegate

- (void)popupTextView:(YIPopupTextView *)textView willDismissWithText:(NSString *)text cancelled:(BOOL)cancelled
{
    _popupTextView = nil;
    
#if defined(__IPHONE_7_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
    if (IS_IOS_AT_LEAST(@"7.0")) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
#endif
}

- (void)popupTextView:(YIPopupTextView *)textView didDismissWithText:(NSString *)text cancelled:(BOOL)cancelled
{
    NSLog(@"did dismiss: cancelled=%d",cancelled);
    if (!cancelled) {
        if (text.length == 0) {
            [super showProgressErrorWithLabelText:@"烤箱名称不能为空" afterDelay:1];
        } else {
            
            
            self.currentOven.name = text;
            [[NSNotificationCenter defaultCenter] postNotificationName:MyOvensInfoHadChangedNotificatin object:nil];
            [super showProgressCompleteWithLabelText:@"修改成功" afterDelay:1];
            
        }
    }
}


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

@end
