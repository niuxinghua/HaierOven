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
#import "DeviceAlertView.h"
#import "MyPageView.h"

@interface DeviceBoardViewController () <MyPageViewDelegate, UIScrollViewDelegate,DeviceAlertViewDelegate>
{
    CGRect alertRectShow;
    CGRect alertRectHidden;
}


@property (strong, nonatomic) IBOutlet DeviceWorkView *startStatusView;

@property (weak, nonatomic) IBOutlet UILabel *bakeModeLabel;

@property (weak, nonatomic) IBOutlet UILabel *bakeTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *bakeTemperatureLabel;


@property (strong, nonatomic) NSTimer *timeable;
@property int time;
@property (strong, nonatomic) IBOutlet UIScrollView *deviceScrollView;

@property (weak, nonatomic) IBOutlet MyPageView *pageView;

@property (strong, nonatomic) NSMutableArray *workModelBtns;
@property (strong, nonatomic) UIBarButtonItem *startTab;
@property (strong, nonatomic) UIBarButtonItem *ksyrTab;
@property (strong, nonatomic) UIButton *ksyr;
@property (strong, nonatomic) UIBarButtonItem *tzyxTab;
@property (strong, nonatomic) UIBarButtonItem *fixbtn;
@property (strong, nonatomic) UIWindow *myWindow;
@property (strong, nonatomic) DeviceAlertView *deviceAlertView;

@property (weak, nonatomic) IBOutlet UIButton *deviceNameButton;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *deviceStatusBtns;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *allbtns;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *controlBtns;
@property (strong, nonatomic) IBOutlet UITableViewCell *actionCell;
@property (strong, nonatomic) UIButton *tempBtn;//记录模版上一个点击按钮

/**
 *  烘焙温度
 */
@property (strong, nonatomic) IBOutlet UIButton *temputure;

/**
 *  烘焙时间
 */
@property (strong, nonatomic) IBOutlet UIButton *howlong;

/**
 *  烘焙模式
 */
@property (strong, nonatomic) NSDictionary* bakeMode;

/**
 *  烤完了的本地通知
 */
@property (strong, nonatomic) UILocalNotification* bakeTimeNotification;

/**
 *  Oven实例
 */
@property (strong, nonatomic) uSDKDevice* myOven;

@property (nonatomic) AlertType alertType;
@property (strong, nonatomic) NSString *orderString;
@property (strong, nonatomic) NSString *clockString;
@property (strong, nonatomic) NSString *neddleString;
@property (strong, nonatomic) NSString *tempString;
@property (strong, nonatomic) NSString *timeString;
@property (strong, nonatomic) NSString *warmUpString;

/**
 *  烘焙模式命令value，与烘焙模式按钮一一对应
 */
@property (strong, nonatomic) NSArray* bakeModeValues;


@end

@implementation DeviceBoardViewController

@synthesize startTab;
@synthesize ksyrTab;
@synthesize tzyxTab;
@synthesize fixbtn;
@synthesize ksyr;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self SetUpSubviews];
    [self SetUPAlertView];
    [self setupToolbarItems];
    self.deviceBoardStatus = DeviceBoardStatusClose;
    [self loadMyOvenInstance];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.toolbarHidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.navigationController.toolbarHidden = YES;
}
- (void)setupToolbarItems
{
    // 设置工具栏颜色 这里的图片需要黑色半透明图片
    self.navigationController.toolbarHidden = NO;
    self.navigationController.toolbar.height = PageW*0.18;
    self.navigationController.toolbar.frame = CGRectMake(0, PageH-PageW*0.18, PageW, PageW*0.18);
    
    [self.navigationController.toolbar setBackgroundImage:IMAGENAMED(@"sectionbg") forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    self.navigationController.toolbar.clipsToBounds = YES;
    
    //工具栏  ToolBar
    ksyr = [[UIButton alloc] init];
    [ksyr setImage:IMAGENAMED(@"ksyr-xz") forState:UIControlStateNormal];
//    [ksyr setImage:IMAGENAMED(@"ksyr-wxz") forState:UIControlStateDisabled];
    [ksyr setImage:IMAGENAMED(@"ksyr-cxz") forState:UIControlStateSelected];
    [ksyr addTarget:self action:@selector(StartWarmUp:) forControlEvents:UIControlEventTouchUpInside];
    float width = (PageW-50)/2;
    ksyr.frame = CGRectMake(0, 0, width, width *0.272);
    
    
    UIButton * start = [UIButton buttonWithType:UIButtonTypeCustom];
    [start setImage:IMAGENAMED(@"kaishi-xz") forState:UIControlStateNormal];
//    [start setImage:IMAGENAMED(@"kaishi") forState:UIControlStateDisabled];
    [start setImage:IMAGENAMED(@"kaishi-cxz") forState:UIControlStateSelected];
    [start addTarget:self action:@selector(StartWorking) forControlEvents:UIControlEventTouchUpInside];
    start.frame = CGRectMake(0, 0, width, width *0.272);

    
    UIButton * tzyx = [UIButton buttonWithType:UIButtonTypeCustom];
    [tzyx setImage:IMAGENAMED(@"tzyx-cxz") forState:UIControlStateNormal];
    [tzyx addTarget:self action:@selector(StopWorking) forControlEvents:UIControlEventTouchUpInside];
    tzyx.frame = CGRectMake(0, 0, PageW-30, width *0.272);
    

    //木棍
    fixbtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    startTab = [[UIBarButtonItem alloc]initWithCustomView:start];
    tzyxTab = [[UIBarButtonItem alloc]initWithCustomView:tzyx];
    ksyrTab = [[UIBarButtonItem alloc] initWithCustomView:ksyr];

    self.toolbarItems = @[ fixbtn,ksyrTab,fixbtn,startTab,fixbtn];
}

-(void)SetUpSubviews{
    self.tableView.backgroundView = [[UIImageView alloc]initWithImage:IMAGENAMED(@"boardbg")];
    
    self.bakeModeValues = @[@{@"30v0M6" :@"传统烘焙"},
                            @{@"30v0M8" :@"对流烘焙"} /*对流烘焙*/,
                            @{@"30v0M5" :@"热风烧烤" }/*热风烧烤*/,
                            @{@"30v0Mf" :@"焙烤" }/*应该是焙烤，这里是传统烧烤*/,
                            @{@"30v0Me" :@"烧烤" }/*烧烤*/,
                            @{@"30v0Mc" :@"3D热风"} /*3D热风*/,
                            @{@"30v0M9" :@"3D烧烤" }/*3D烧烤*/,
                            @{@"30v0Md" :@"披萨模式" }/*披萨模式*/,
                            @{@"30v0Ma" :@"解冻功能" }/*解冻功能*/,
                            @{@"30v0Mb" :@"发酵功能" }/*发酵功能*/,
                            @{@"30v0Mg" :@"下烧烤" }/*下烧烤*/,
                            @{@"30V1Mh" :@"上烧烤＋蒸汽"} /*上烧烤＋蒸汽*/,
                            @{@"30v2Mi" :@"传统烘焙" }/*上下烧烤＋蒸汽*/,
                            @{@"30v3Mj" :@"上下烧烤＋蒸汽"} /*纯蒸汽*/,
                            @{@"30v4Mk" :@"消毒 1" }/*消毒 1*/,
                            @{@"30v5Ml" :@"消毒 2" }/*消毒 2*/,
                            @{@"30v6Mm" :@"全烧烤" }/*全烧烤*/,
                            @{@"30v7Mn" :@"热分全烧烤"} /*热分全烧烤*/];
    
    NSArray *cxz = @[@"cthp-cxz",@"dlfp-cxz",@"rfpk-cxz",@"pk-cxz",@"sk-cxz",@"cthp-cxz",@"dlfp-cxz",@"rfpk-cxz",@"pk-cxz",@"sk-cxz",@"cthp-cxz",@"dlfp-cxz",@"rfpk-cxz",@"pk-cxz",@"sk-cxz",@"cthp-cxz",@"dlfp-cxz",@"rfpk-cxz",@"pk-cxz",@"sk-cxz"];
    NSArray *xz = @[@"cthp-xz",@"dlfp-xz",@"rfpk-xz",@"pk-xz",@"sk-xz",@"cthp-xz",@"dlfp-xz",@"rfpk-xz",@"pk-xz",@"sk-xz",@"cthp-xz",@"dlfp-xz",@"rfpk-xz",@"pk-xz",@"sk-xz",@"cthp-xz",@"dlfp-xz",@"rfpk-xz",@"pk-xz",@"sk-xz"];
    NSArray *wxz = @[@"cthp-wxz",@"dlfp-wxz",@"rfpk-wxz",@"pk-wxz",@"sk-wxz",@"cthp-wxz",@"dlfp-wxz",@"rfpk-wxz",@"pk-wxz",@"sk-wxz",@"cthp-wxz",@"dlfp-wxz",@"rfpk-wxz",@"pk-wxz",@"sk-wxz",@"cthp-wxz",@"dlfp-wxz",@"rfpk-wxz",@"pk-wxz",@"sk-wxz"];
    self.workModelBtns = [NSMutableArray new];
    for (int i = 0; i<cxz.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:IMAGENAMED(xz[i]) forState:UIControlStateNormal];
        [btn setBackgroundImage:IMAGENAMED(cxz[i]) forState:UIControlStateSelected];
        [btn setBackgroundImage:IMAGENAMED(wxz[i]) forState:UIControlStateDisabled];
        btn.tag = i;
        [btn addTarget:self action:@selector(WorkModelChick:) forControlEvents:UIControlEventTouchUpInside];
        float high = PageW/5/69.0*89;
        btn.frame = CGRectMake(1.5+i*(PageW/5), 4, (PageW/5-3), high);
        [self.deviceScrollView addSubview:btn];
        [self.workModelBtns addObject:btn];
    }
    
    [self.deviceNameButton setTitle:[NSString stringWithFormat:@"%@已连接，待机中", self.currentOven.name] forState:UIControlStateSelected];
    [self.deviceNameButton setTitle:[NSString stringWithFormat:@"%@已连接，关机中", self.currentOven.name] forState:UIControlStateNormal];
    
#warning 调试PageView
    self.pageView.numberOfPages = 4;
    self.deviceScrollView.contentSize = CGSizeMake(_deviceScrollView.frame.size.width * 4, _deviceScrollView.frame.size.height);
    self.deviceScrollView.pagingEnabled = YES;
    self.deviceScrollView.delegate = self;
}
-(void)SetUPAlertView{
    alertRectHidden = CGRectMake(PageW/2, PageH/2, 0, 0);
    alertRectShow = CGRectMake(20, (PageH-((PageW-40)*1.167))/2, PageW-40, (PageW-40)*1.167);

    
    self.myWindow = [UIWindow new];
    self.myWindow.frame = CGRectMake(0, 0, PageW, PageH);
    self.myWindow.backgroundColor = [UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:0.3];
    self.myWindow.windowLevel = UIWindowLevelAlert;
    [self.myWindow makeKeyAndVisible];
    self.myWindow.userInteractionEnabled = YES;
    self.myWindow.hidden = YES;

    self.deviceAlertView = [[DeviceAlertView alloc]initWithFrame:alertRectHidden];
//    self.deviceAlertView = [[DeviceAlertView alloc]initWithFrame:CGRectMake(0, 0, PageW-40, (PageW-40)*1.167)];
    self.deviceAlertView.delegate = self;
    [self.myWindow addSubview:self.deviceAlertView];
}

#pragma mark - PageView&DeviceScrollView setting

- (void)updatePager
{
    self.pageView.page = floorf(_deviceScrollView.contentOffset.x / _deviceScrollView.frame.size.width);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView
{
    [self updatePager];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self updatePager];
    }
}

- (void)pageView:(MyPageView *)pageView didUpdateToPage:(NSInteger)newPage
{
    CGPoint offset = CGPointMake(_deviceScrollView.frame.size.width * self.pageView.page, 0);
    [_deviceScrollView setContentOffset:offset animated:YES];
}

#pragma mark - Actions




#pragma mark -选择工作模式

-(void)WorkModelChick:(UIButton*)sender{
    _tempBtn.selected = _tempBtn.selected==YES?NO:YES;
    sender.selected = sender.selected==YES?NO:YES;
    _tempBtn = sender;
    self.deviceBoardStatus = DeviceBoardStatusChoseModel;
    
    self.bakeMode = self.bakeModeValues[sender.tag];
    
    //点击了工作模式
//    uSDKDeviceAttribute* command = [[OvenManager sharedManager] structureWithCommandName:kBakeMode
//                                                                        commandAttrValue:self.bakeModeValues[sender.tag]];
//    [[OvenManager sharedManager] executeCommands:[@[command] mutableCopy]
//                                        toDevice:self.myOven
//                                    andCommandSN:0
//                             andGroupCommandName:@""
//                                       andResult:^(BOOL result) {
//                                           
//                                       }];
    
    
}
#pragma mark - 

-(void)timerAction:(NSTimer *)time{
    if (time == 0) {
        [self.timeable invalidate];
        self.timeable = nil;
    }
    self.time = self.time==0? 0:self.time-1;
    self.startStatusView.leftTime = [NSString stringWithFormat:@"%i:%i",self.time/60, self.time%60];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadMyOvenInstance
{
    [super showProgressHUDWithLabelText:@"请稍后..." dimBackground:NO];
    [[OvenManager sharedManager] getDevicesCompletion:^(BOOL success, id obj, NSError *error) {
        [super hiddenProgressHUD];
        if (success) {
            //找到Wifi下烤箱列表，并获取指定烤箱对象
            NSArray* ovenList = obj;
            for (uSDKDevice* oven in ovenList) {
                if ([self.currentOven.mac isEqualToString:oven.mac]) {
                    self.myOven = oven;
                    //搜索到设备则开始订阅通知，订阅成功烤箱即进入就绪状态，可以发送指令
//                    [[OvenManager sharedManager] subscribeDevice:self.myOven];
                    [[OvenManager sharedManager] subscribeAllNotificationsWithDevice:self.myOven];
                    
                }
            }
        } else {
            [super showProgressErrorWithLabelText:@"烤箱连接失败" afterDelay:1];
        }
    }];
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
            return  self.deviceBoardStatus ==DeviceBoardStatusStart? PageW*0.33:0;
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
        case 6:
            return  PageW*0.298;
            break;
        case 7:
            return  PageW*0.180-44;
            break;
        default:
            return 0;
            break;
    }
}




#pragma mark - 设备指令

- (void)bootup //开机
{
    [[OvenManager sharedManager] bootupToDevice:self.myOven result:^(BOOL result) {
        if (!result) {
            [super showProgressErrorWithLabelText:@"开机失败" afterDelay:1];
        }
    }];
}

- (void)shutdown
{
    [[OvenManager sharedManager] shutdownToDevice:self.myOven result:^(BOOL result) {
        if (!result) {
            [super showProgressErrorWithLabelText:@"关机失败" afterDelay:1];
        }
    }];
}



#pragma mark - toolbarAction
-(void)StartWarmUp:(UIButton*)sender{
    self.myWindow.hidden = NO;
    if (sender.selected==NO) {
        [UIView animateWithDuration:0.2 animations:^{
            self.deviceAlertView.frame = alertRectShow;
        } completion:^(BOOL finished) {
            
        }];
        
        self.deviceAlertView.alertType = alertWormUp;
    }
//    self.toolbarItems = @[ fixbtn,tzyxTab,fixbtn];
    

}

#pragma mark - 开始运行 & 结束运行

-(void)StartWorking{
    
    self.deviceBoardStatus = DeviceBoardStatusStart;
    
    //点击运行后显示
    self.timeable =  [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    
    NSRange range = [self.howlong.currentTitle rangeOfString:@" 分钟"];
    NSString* timeStr = [self.howlong.currentTitle substringToIndex:range.location];
    
    self.time = [timeStr integerValue] * 60;
    float animateDueation = [timeStr integerValue] * 60;
    self.startStatusView.animationDuration = animateDueation;
    [self.startStatusView.lineProgressView setCompleted:1.0*80 animated:YES];
    
    self.toolbarItems = @[ fixbtn,tzyxTab,fixbtn];
    
    
    
    self.bakeModeLabel.text = [NSString stringWithFormat:@"工作模式：%@", [[self.bakeMode allValues] firstObject]];
    self.bakeTimeLabel.text = [NSString stringWithFormat:@"时间：%@", self.howlong.currentTitle];
    self.bakeTemperatureLabel.text = [NSString stringWithFormat:@"目标温度：%@", self.temputure.currentTitle];
    
    
    
    if (!self.temputure.selected) {
        [self setBakeTemperature:self.temputure.currentTitle];
    }
    
    if (!self.howlong.selected) {
        [self setBakeTime:self.howlong.currentTitle];
    }
    
    
    
    uSDKDeviceAttribute* command = [[OvenManager sharedManager] structureWithCommandName:kBakeMode
                                                                        commandAttrValue:[[self.bakeMode allKeys] firstObject]];
    [[OvenManager sharedManager] executeCommands:[@[command] mutableCopy]
                                        toDevice:self.myOven
                                    andCommandSN:0
                             andGroupCommandName:@""
                                       andResult:^(BOOL result) {
                                           
                                       }];

    
    command = [[OvenManager sharedManager] structureWithCommandName:kStartUp commandAttrValue:kStartUp];
    [[OvenManager sharedManager] executeCommands:[@[command] mutableCopy]
                                        toDevice:self.myOven
                                    andCommandSN:0
                             andGroupCommandName:@""
                                       andResult:^(BOOL result) {
                                           
                                       }];
    
    if (self.bakeTimeNotification != nil) {
        [[UIApplication sharedApplication] cancelLocalNotification:self.bakeTimeNotification];
    }
    
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    self.bakeTimeNotification = localNotification;
    NSInteger seconds = [timeStr integerValue] * 60;
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:seconds];
    localNotification.alertBody = [NSString stringWithFormat:@"您的食物已经烤好了"];
    localNotification.alertAction = @"alertAction";
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.applicationIconBadgeNumber = 1;
    localNotification.userInfo = @{@"name": @"sansang", @"age": @99}; //給将来的此程序传参
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
}

-(void)StopWorking{
    self.toolbarItems = @[ fixbtn,ksyrTab,fixbtn,startTab,fixbtn];
    [self.timeable invalidate];
    self.timeable = nil;
    self.deviceBoardStatus = DeviceBoardStatusOpen;
    
    uSDKDeviceAttribute* command = [[OvenManager sharedManager] structureWithCommandName:kPause commandAttrValue:kPause];
    [[OvenManager sharedManager] executeCommands:[@[command] mutableCopy]
                                        toDevice:self.myOven
                                    andCommandSN:0
                             andGroupCommandName:@""
                                       andResult:^(BOOL result) {
                                           
                                       }];
    

}

#pragma mark - 按钮响应事件

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


- (IBAction)deviceControlsTapped:(UIButton *)sender
{
    uSDKDeviceAttribute* command;
    switch (sender.tag) {
        case 1:     //风扇
        {
            command = sender.selected ?
            [[OvenManager sharedManager] structureWithCommandName:kCloseAirFan commandAttrValue:kCloseAirFan] :
            [[OvenManager sharedManager] structureWithCommandName:kOpenAirFan commandAttrValue:kOpenAirFan];
            
            break;
        }
        case 2:     //旋转
        {
            command = sender.selected ?
            [[OvenManager sharedManager] structureWithCommandName:kCloseChassisRotation commandAttrValue:kCloseChassisRotation] :
            [[OvenManager sharedManager] structureWithCommandName:kOpenChassisRotation commandAttrValue:kOpenChassisRotation];
            break;
        }
        case 3:     //照明
        {
            command = sender.selected ?
            [[OvenManager sharedManager] structureWithCommandName:kOffLighting commandAttrValue:kOffLighting] :
            [[OvenManager sharedManager] structureWithCommandName:kLighting commandAttrValue:kLighting];
            break;
        }
        case 4:     //锁定
        {
            command = sender.selected ?
            [[OvenManager sharedManager] structureWithCommandName:kUnlock commandAttrValue:kUnlock] :
            [[OvenManager sharedManager] structureWithCommandName:kLock commandAttrValue:kLock];
            
            
            break;
        }
        default:
            break;
    }
    
    [[OvenManager sharedManager] executeCommands:[@[command] mutableCopy]
                                        toDevice:self.myOven
                                    andCommandSN:0
                             andGroupCommandName:@""
                                       andResult:^(BOOL result) {
                                           
                                       }];
    
    sender.selected = !sender.selected;
}


#pragma mark - 开机关机
- (IBAction)onoff:(UIButton*)sender {
    for (UIButton *btn in self.deviceStatusBtns) {
        btn.selected = !btn.selected;
    }
    
    UIButton *btn = [self.deviceStatusBtns firstObject];
    self.deviceBoardStatus = btn.selected ==NO?DeviceBoardStatusClose:DeviceBoardStatusOpen;
    
    UIButton* button = sender;
    if (button.selected) {
        [self bootup];
    } else {
        [self shutdown];
    }
    
}

-(void)setDeviceBoardStatus:(DeviceBoardStatus)deviceBoardStatus{
    _deviceBoardStatus = deviceBoardStatus;
    switch (_deviceBoardStatus) {
        case DeviceBoardStatusClose:
            for (UIButton* btn in self.allbtns) {
                btn.enabled = NO;
            }
            
            for (UIButton *btn in self.controlBtns) {
                btn.enabled = NO;
            }
            for (UIButton *btn in self.workModelBtns) {
                btn.enabled = NO;
            }
            
            for (UIBarButtonItem *btn in self.toolbarItems) {
                btn.enabled = NO;
            }
            self.actionCell.hidden = YES;
            [self.tableView reloadData];
            break;
            
        case DeviceBoardStatusOpen:
            for (UIButton* btn in self.allbtns) {
                btn.enabled = NO;
            }
            
            for (UIButton *btn in self.controlBtns) {
                btn.enabled = YES;
            }
            
            for (UIButton *btn in self.workModelBtns) {
                btn.enabled =YES;
            }
            
            for (UIBarButtonItem *btn in self.toolbarItems) {
                btn.enabled = NO;
            }
            
            self.actionCell.hidden = YES;
            [self.tableView reloadData];
            break;

        case DeviceBoardStatusStart:
            for (UIButton* btn in self.allbtns) {
                btn.enabled = YES;
            }
            
            for (UIButton *btn in self.controlBtns) {
                btn.enabled = YES;
            }
            
            for (UIButton *btn in self.workModelBtns) {
                btn.enabled =YES;
            }
            
            for (UIBarButtonItem *btn in self.toolbarItems) {
                btn.enabled = YES;
            }
            self.actionCell.hidden = NO;
            [self.tableView reloadData];
            break;
            
            
        case DeviceBoardStatusChoseModel:
            for (UIButton* btn in self.allbtns) {
                btn.enabled = YES;
            }
            
            for (UIButton *btn in self.controlBtns) {
                btn.enabled = YES;
            }
            
            for (UIButton *btn in self.workModelBtns) {
                btn.enabled =YES;
            }
            
            for (UIBarButtonItem *btn in self.toolbarItems) {
                btn.enabled = YES;
            }
            
            self.actionCell.hidden = YES;
            [self.tableView reloadData];
            break;
            
            
        default:
            break;
    }
    
}

#pragma mark -

// 设置烘焙时间
- (void)setBakeTime:(NSString*)timeString
{
    NSRange range = [timeString rangeOfString:@" 分钟"];
    NSString* timeStr = [timeString substringToIndex:range.location];
    NSInteger minutes = [timeStr integerValue];
    NSString* timeValue = [NSString stringWithFormat:@"%02d:%02d", minutes/60, minutes%60];
    uSDKDeviceAttribute* command = [[OvenManager sharedManager] structureWithCommandName:kBakeTime commandAttrValue:timeValue];
    [[OvenManager sharedManager] executeCommands:[@[command] mutableCopy]
                                        toDevice:self.myOven
                                    andCommandSN:0
                             andGroupCommandName:@""
                                       andResult:^(BOOL result) {
                                           
                                       }];
}

// 设置烘焙温度
- (void)setBakeTemperature:(NSString*)temperatureString
{
    NSRange range = [temperatureString rangeOfString:@"°"];
    NSString* temperatureValue = [temperatureString substringToIndex:range.location];
    uSDKDeviceAttribute* command = [[OvenManager sharedManager] structureWithCommandName:kBakeTemperature
                                                                        commandAttrValue:temperatureValue];
    [[OvenManager sharedManager] executeCommands:[@[command] mutableCopy]
                                        toDevice:self.myOven
                                    andCommandSN:0
                             andGroupCommandName:@""
                                       andResult:^(BOOL result) {
                                           
                                       }];
}

// 闹钟
- (void)setClockTime:(NSString*)clockString
{
    
    NSRange range = [clockString rangeOfString:@" 分钟"];
    NSString* timeStr = [clockString substringToIndex:range.location];
    NSInteger minutes = [timeStr integerValue];
    
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    NSInteger seconds = minutes * 60;
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:seconds];
    localNotification.alertBody = [NSString stringWithFormat:@"您设置的闹钟%@时间已到哦", clockString];
    localNotification.alertAction = @"alertAction";
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.applicationIconBadgeNumber = 1;
    localNotification.userInfo = @{@"name": @"sansang", @"age": @99}; //給将来的此程序传参
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
}

// 预约
- (void)setOrderTime:(NSString*)timeString
{
    
    uSDKDeviceAttribute* command = [[OvenManager sharedManager] structureWithCommandName:kOrderTime
                                                                        commandAttrValue:timeString];
    [[OvenManager sharedManager] executeCommands:[@[command] mutableCopy]
                                        toDevice:self.myOven
                                    andCommandSN:0
                             andGroupCommandName:@""
                                       andResult:^(BOOL result) {
                                           
                                       }];
    
}

// 温度探针
- (void)setNeedleTemperature:(NSString*)temperatureString
{
    
    
    
}

// 预热
- (void)setWarmUpTemperature:(NSString*)temperatureString
{
    
}

#pragma mark- 提示框显示deviceAlertView
-(void)cancel{
    self.myWindow.hidden = YES;
    self.deviceAlertView.frame = alertRectHidden;
   
}

-(void)confirm:(NSString *)string andAlertTye:(NSInteger)type andbtn:(UIButton *)btn{
    self.alertType = type;
    btn.selected = YES;
    switch (self.alertType) {
        case alertTime:
            self.timeString = string;
            [self setBakeTime:string];
            break;
        case alertTempture:
            self.tempString = string;
            [self setBakeTemperature:string];
            break;
        case alertClock:
            self.clockString = string;
            [self setClockTime:string];
            break;
        case alertOrder:    //预约
            self.orderString = string;
            [self setOrderTime:string];
            break;
        case alertNeedle:   //温度探针
            self.neddleString = string;
            [self setNeedleTemperature:string];
            break;
        case alertWormUp:
            self.warmUpString = string;
            [self setWarmUpTemperature:string];
            ksyr.selected = ksyr.selected==YES?NO:YES;
            break;
            
        default:
            break;
    }
    self.myWindow.hidden = YES;
    self.deviceAlertView.frame = alertRectHidden;

}

- (IBAction)alertView:(UIButton *)sender {
    NSLog(@"%d",sender.tag);
    if (sender.selected ==NO ||sender.tag==1||sender.tag==2) {
        self.deviceAlertView.alertType = sender.tag;
        self.deviceAlertView.btn = sender;
        self.myWindow.hidden = NO;
        switch (sender.tag) {
            case 1:
                self.deviceAlertView.string = @"180°";
                break;
            case 2:
                self.deviceAlertView.string = @"30 分钟";
                break;
            default:
                break;
        }
        [UIView animateWithDuration:0.2 animations:^{
            self.deviceAlertView.frame = alertRectShow;
        } completion:^(BOOL finished) {
            
        }];
    }else sender.selected = NO;

}

#pragma mark-

-(void)setTempString:(NSString *)tempString{
    _tempString = tempString;
    [self.temputure setTitle:_tempString forState:UIControlStateNormal];
}

-(void)setTimeString:(NSString *)timeString{
    _timeString = timeString;
    [self.howlong setTitle:_timeString forState:UIControlStateNormal];
}
@end
