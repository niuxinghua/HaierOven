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
#import "CompleteCookController.h"
#import "KKProgressTimer.h"
#import "TimeProgressAlertView.h"
#import "TimeOutView.h"
#import "OrderAlertView.h"


@interface DeviceBoardViewController () <MyPageViewDelegate, UIScrollViewDelegate, DeviceAlertViewDelegate,KKProgressTimerDelegate,TimeProgressAlertViewDelegate,TimeOutViewDelegate,OrderAlertViewDelegate, CompleteCookControllerDelegate>
{
    CGRect alertRectShow;
    CGRect alertRectHidden;
    NSInteger seconds;
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
@property (weak, nonatomic) IBOutlet UIButton *clockIcon;
@property (weak, nonatomic) IBOutlet KKProgressTimer *cookTimeView;
@property (strong, nonatomic) TimeProgressAlertView *clockAlert;
@property (strong, nonatomic) TimeOutView *timeOutAlert;
@property (strong, nonatomic) OrderAlertView *orderAlert;
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

@property (strong, nonatomic) OvenManager* ovenManager;

@property (strong, nonatomic) NSTimer* bakeTimer;

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
    self.deviceBoardStatus = DeviceBoardStatusClosed;
    [self loadMyOvenInstance];
    
    self.ovenManager = [OvenManager sharedManager];
    
    // 监控在线状态
    [self addObserver:self forKeyPath:@"self.ovenManager.currentStatus.isReady" options:NSKeyValueObservingOptionNew context:NULL];
    // 监控温度
    [self addObserver:self forKeyPath:@"self.ovenManager.currentStatus.temperature" options:NSKeyValueObservingOptionNew context:NULL];
    
    // 监控设备开机状态
    [self addObserver:self forKeyPath:@"self.ovenManager.currentStatus.opened" options:NSKeyValueObservingOptionNew context:NULL];
    
    [self addObserver:self forKeyPath:@"self.clockIcon.selected" options:NSKeyValueObservingOptionNew context:NULL];
    
}

#pragma mark - 监听烤箱状态并作出反应

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"******设备状态变化啦**********");
    NSLog(@"在线：%d, 开机：%d, 工作：%d, 温度：%d, 时间：%@", self.ovenManager.currentStatus.isReady, _ovenManager.currentStatus.opened, self.ovenManager.currentStatus.isWorking, _ovenManager.currentStatus.temperature, _ovenManager.currentStatus.bakeTime);
    
    if ([keyPath isEqualToString:@"self.ovenManager.currentStatus.isReady"]) {
        if (_ovenManager.currentStatus.isReady) {
            [self.deviceNameButton setTitle:[NSString stringWithFormat:@"%@已连接，待机中", self.currentOven.name] forState:UIControlStateNormal];
        } else {
            [self.deviceNameButton setTitle:[NSString stringWithFormat:@"%@已连接", self.currentOven.name] forState:UIControlStateNormal];
        }
        
    } else if ([keyPath isEqualToString:@"self.ovenManager.currentStatus.temperature"]) {
        // 温度变化，如果设有温度探针，则当烤箱到达指定温度后弹窗通知
        
        
    } else if ([keyPath isEqualToString:@"self.ovenManager.currentStatus.opened"]) {
        
        if (self.deviceBoardStatus == DeviceBoardStatusOpened && !_ovenManager.currentStatus.opened) {
            [self bootup];
        }
        
        
    } else if ([keyPath isEqualToString:@"self.clockIcon.selected"]) {
        self.cookTimeView.hidden = !self.clockIcon.selected;
        self.clockIcon.hidden = self.clockIcon.selected;
        
    }
    
    
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"self.ovenManager.currentStatus.isReady" context:NULL];
    [self removeObserver:self forKeyPath:@"self.ovenManager.currentStatus.temperature" context:NULL];
    [self removeObserver:self forKeyPath:@"self.ovenManager.currentStatus.opened" context:NULL];
    [self removeObserver:self forKeyPath:@"self.clockIcon.selected"];
    self.bakeTimer = nil;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.toolbarHidden = NO;
    
//    [self loadMyOvenInstance];
    
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
    
//    NSArray *cxz = @[@"cthp-cxz",@"dlfp-cxz",@"rfpk-cxz",@"pk-cxz",@"sk-cxz",@"cthp-cxz",@"dlfp-cxz",@"rfpk-cxz",@"pk-cxz",@"sk-cxz",@"cthp-cxz",@"dlfp-cxz",@"rfpk-cxz",@"pk-cxz",@"sk-cxz",@"cthp-cxz",@"dlfp-cxz",@"rfpk-cxz",@"pk-cxz",@"sk-cxz"];
//    
//    NSArray *xz = @[@"cthp-xz",@"dlfp-xz",@"rfpk-xz",@"pk-xz",@"sk-xz",@"cthp-xz",@"dlfp-xz",@"rfpk-xz",@"pk-xz",@"sk-xz",@"cthp-xz",@"dlfp-xz",@"rfpk-xz",@"pk-xz",@"sk-xz",@"cthp-xz",@"dlfp-xz",@"rfpk-xz",@"pk-xz",@"sk-xz"];
//    NSArray *wxz = @[@"cthp-wxz",@"dlfp-wxz",@"rfpk-wxz",@"pk-wxz",@"sk-wxz",@"cthp-wxz",@"dlfp-wxz",@"rfpk-wxz",@"pk-wxz",@"sk-wxz",@"cthp-wxz",@"dlfp-wxz",@"rfpk-wxz",@"pk-wxz",@"sk-wxz",@"cthp-wxz",@"dlfp-wxz",@"rfpk-wxz",@"pk-wxz",@"sk-wxz"];
    
    NSArray *cxz = @[@"icon_ssk_n", @"icon_sxsk_n", @"icon_xsk_n", @"icon_fj_n", @"icon_jd_n", @"icon_3Dhb_n",
                     @"icon_3Dsk_n", @"icon_psms_n", @"icon_cthb_n", @"icon_rfsk_n", @"icon_dlhb_n", @"icon_rfqsk_n"];
    
    NSArray *xz = @[@"icon_ssk_s", @"icon_sxsk_s", @"icon_xsk_s", @"icon_fj_s", @"icon_jd_s", @"icon_3Dhb_s",
                    @"icon_3Dsk_s", @"icon_psms_s", @"icon_cthb_s", @"icon_rfsk_s", @"icon_dlhb_s", @"icon_rfqsk_s"];
    
    self.workModelBtns = [NSMutableArray new];
    for (int i = 0; i<cxz.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:IMAGENAMED(cxz[i]) forState:UIControlStateNormal];
        [btn setBackgroundImage:IMAGENAMED(xz[i]) forState:UIControlStateSelected];
//        [btn setBackgroundImage:IMAGENAMED(wxz[i]) forState:UIControlStateDisabled];
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
    self.pageView.numberOfPages = 3;
    self.deviceScrollView.contentSize = CGSizeMake(_deviceScrollView.frame.size.width * 3, _deviceScrollView.frame.size.height);
    self.deviceScrollView.pagingEnabled = YES;
    self.deviceScrollView.delegate = self;
    
    CGPoint point = self.pageView.center;
    point.x = Main_Screen_Width / 2;
    self.pageView.center = point;
    
    self.cookTimeView.delegate = self;
    self.cookTimeView.progressColor = GlobalOrangeColor;
    self.cookTimeView.progressBackgroundColor = [UIColor whiteColor];
    self.cookTimeView.circleBackgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TouchTimeView)];
    [self.cookTimeView addGestureRecognizer:tap];
    
}

-(void)TouchTimeView{
    self.myWindow.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
//        self.deviceAlertView.frame = alertRectShow;
//        self.clockAlert.frame = CGRectMake(alertRectShow.origin.x, alertRectShow.origin.y, alertRectShow.size.width, 200);
        self.clockAlert.frame = alertRectShow;
    } completion:^(BOOL finished) {
        
    }];

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
    self.deviceAlertView.delegate = self;
    [self.myWindow addSubview:self.deviceAlertView];
    
    self.clockAlert = [[TimeProgressAlertView alloc]initWithFrame:alertRectHidden];
    self.clockAlert.delegate = self;
    [self.myWindow addSubview:self.clockAlert];
    
    self.timeOutAlert = [[TimeOutView alloc]initWithFrame:alertRectHidden];
    self.timeOutAlert.delegate = self;
    [self.myWindow addSubview:self.timeOutAlert];
    
    self.orderAlert = [[OrderAlertView alloc]initWithFrame:alertRectHidden];
    self.orderAlert.delegate = self;
    [self.myWindow addSubview:self.orderAlert];
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
    if (self.deviceBoardStatus == DeviceBoardStatusWorking) {
        [super showProgressErrorWithLabelText:@"停止运行后，参数可调" afterDelay:1];
        return;
    }
    
    for (UIButton* button in self.workModelBtns) {
        button.selected = NO;
    }

    sender.selected = YES;

    self.deviceBoardStatus = DeviceBoardStatusSelectMode;
    
    self.howlong.selected = NO;
    self.temputure.selected = NO;
    
    self.bakeMode = self.ovenManager.bakeModes[sender.tag];
    
}

#pragma mark - 

-(void)timerAction:(NSTimer *)time{
    if (time == 0) {
        [self.timeable invalidate];
        self.timeable = nil;
    }
    self.time = self.time==0? 0:self.time-1;
    self.startStatusView.leftTime = [NSString stringWithFormat:@"%02d:%02d",self.time/60, self.time%60];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadMyOvenInstance
{
    if (self.myOven != nil && [self.currentOven.mac isEqualToString:self.myOven.mac]) {
        [[OvenManager sharedManager] subscribeAllNotificationsWithDevice:self.myOven];
    } else {
        
        [super showProgressHUDWithLabelText:@"请稍候..." dimBackground:NO];
        [[OvenManager sharedManager] getDevicesCompletion:^(BOOL success, id obj, NSError *error) {
            [super hiddenProgressHUD];
            if (success) {
                //找到Wifi下烤箱列表，并获取指定烤箱对象
                NSArray* ovenList = obj;
                for (uSDKDevice* oven in ovenList) {
                    if ([self.currentOven.mac isEqualToString:oven.mac]) {
                        self.myOven = oven;
                        [OvenManager sharedManager].subscribedDevice = self.myOven;
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
            return  self.deviceBoardStatus ==DeviceBoardStatusWorking? PageW*0.33:0;
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
    if (self.myOven == nil) {
        [super showProgressErrorWithLabelText:@"烤箱连接失败" afterDelay:1];
        return;
    }
    uSDKDeviceAttribute* cmd = [[OvenManager sharedManager] structureWithCommandName:kBootUp commandAttrValue:kBootUp];
    [[OvenManager sharedManager] executeCommands:[@[cmd] mutableCopy]
                                        toDevice:self.myOven
                                    andCommandSN:0
                             andGroupCommandName:@""
                                        callback:^(BOOL success, uSDKErrorConst errorCode) {
                                            
                                        }];
}

- (void)shutdown
{
    
    uSDKDeviceAttribute* cmd = [[OvenManager sharedManager] structureWithCommandName:kShutDown commandAttrValue:kShutDown];
    [[OvenManager sharedManager] executeCommands:[@[cmd] mutableCopy]
                                        toDevice:self.myOven
                                    andCommandSN:0
                             andGroupCommandName:@""
                                        callback:^(BOOL success, uSDKErrorConst errorCode) {
                                            
                                        }];
}



#pragma mark - toolbarAction

-(void)StartWarmUp:(UIButton*)sender{
    if (self.myOven == nil) {
        [super showProgressErrorWithLabelText:@"烤箱连接失败" afterDelay:1];
        return;
    }
    
    self.myWindow.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.deviceAlertView.frame = alertRectShow;
    } completion:^(BOOL finished) {
        
    }];
    
    self.deviceAlertView.alertType = alertWormUp;

}

#pragma mark - 开始运行 & 结束运行

-(void)StartWorking
{
    if (self.myOven == nil) {
        [super showProgressErrorWithLabelText:@"烤箱连接失败" afterDelay:1];
        return;
    }
    
    NSRange range = [self.howlong.currentTitle rangeOfString:@" 分钟"];
    NSString* timeStr = [self.howlong.currentTitle substringToIndex:range.location];
    
    self.bakeModeLabel.text = [NSString stringWithFormat:@"工作模式：%@", [[self.bakeMode allValues] firstObject]];
    self.bakeTimeLabel.text = [NSString stringWithFormat:@"时间：%@", self.howlong.currentTitle];
    self.bakeTemperatureLabel.text = [NSString stringWithFormat:@"目标温度：%@", self.temputure.currentTitle];
    
    range = [self.temputure.currentTitle rangeOfString:@"°"];
    NSString* temperatureValue = [self.temputure.currentTitle substringToIndex:range.location];
    
    NSInteger minutes = [timeStr integerValue];
    NSString* timeValue = [NSString stringWithFormat:@"%02d:%02d", minutes/60, minutes%60];
    
//    调用顺序：检测是否已开机 - 设置模式 - 启动 - 设置温度 - 设置时间
    //调用顺序：检测是否已开机 - 设置模式 - 设置温度 - 设置时间 - 启动
    
    if (!self.ovenManager.currentStatus.opened) {
        [self bootup];
    }
    
    [super showProgressHUDWithLabelText:@"请稍候..." dimBackground:NO];
    [[OvenManager sharedManager] setBakeMode:[[self.bakeMode allKeys] firstObject] callback:^(BOOL success, uSDKErrorConst errorCode) {
        [super hiddenProgressHUD];
        if (success) {
            [super showProgressHUDWithLabelText:@"请稍候..." dimBackground:NO];
            [[OvenManager sharedManager] setBakeTime:timeValue callback:^(BOOL success, uSDKErrorConst errorCode) {
                [super hiddenProgressHUD];
                if (success) {
                    [super showProgressHUDWithLabelText:@"请稍候..." dimBackground:NO];
                    [[OvenManager sharedManager] setBakeTemperature:temperatureValue callback:^(BOOL success, uSDKErrorConst errorCode) {
                        [super hiddenProgressHUD];
                        if (success) {
                            
                            uSDKDeviceAttribute* command = [[OvenManager sharedManager] structureWithCommandName:kStartUp commandAttrValue:kStartUp];
                            [super showProgressHUDWithLabelText:@"请稍候..." dimBackground:NO];
                            [[OvenManager sharedManager] executeCommands:[@[command] mutableCopy]
                                                                toDevice:self.myOven
                                                            andCommandSN:0
                                                     andGroupCommandName:@""
                                                                callback:^(BOOL success, uSDKErrorConst errorCode) {
                                                                    [super hiddenProgressHUD];
                                                                    self.deviceBoardStatus = DeviceBoardStatusWorking;
                                                                    
                                                                    //点击运行后显示
                                                                    [self.timeable invalidate];
                                                                    self.timeable =  [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
                                                                    
                                                                    self.time = [timeStr integerValue] * 60;
                                                                    float animateDueation = [timeStr integerValue] * 60;
                                                                    self.startStatusView.animationDuration = animateDueation;
                                                                    
                                                                    
                                                                    [self.startStatusView.lineProgressView setCompleted:1.0*80 animated:YES];
                                                                    
                                                                    self.toolbarItems = @[ fixbtn,tzyxTab,fixbtn];
                                                                    
                                                                    NSTimeInterval bakeSeconds = [timeStr integerValue] * 60.0;
                                                                    [[DataCenter sharedInstance] sendLocalNotification:LocalNotificationTypeBakeComplete fireTime:bakeSeconds alertBody:@"您的食物烘焙完成了"];
                                                                    
                                                                    NSDictionary* info = @{@"time" : [MyTool getCurrentTime],
                                                                                           @"desc" : [NSString stringWithFormat:@"设备\"%@\"开始烘焙，模式：%@，时间：%@，温度：%@",self.currentOven.name, [[self.bakeMode allValues] firstObject], self.howlong.currentTitle,  self.temputure.currentTitle]};
                                                                    
                                                                    [[DataCenter sharedInstance] addOvenNotification:info];
                                                                    
                                                                    //[self performSelector:@selector(completeBake) withObject:nil afterDelay:bakeSeconds];
                                                                    self.bakeTimer = [NSTimer scheduledTimerWithTimeInterval:bakeSeconds target:self selector:@selector(completeBake) userInfo:nil repeats:NO];
                                                                    
                                                                }];
                            
                        } else {
                            
                            [super showProgressErrorWithLabelText:@"设置烘焙温度失败" afterDelay:1];
                            
                        }
                        
                    }];
                    
                } else {
                    [super showProgressErrorWithLabelText:@"设置烘焙时间失败" afterDelay:1];
                }
                
                
            }];
            
        } else {
            [super showProgressErrorWithLabelText:@"设置烘焙模式失败" afterDelay:1];
        }
        
    }];
  
}

- (void)completeBake
{
    self.toolbarItems = @[fixbtn,ksyrTab,fixbtn,startTab,fixbtn];
    
    self.deviceBoardStatus = DeviceBoardStatusOpened;
    
    NSDictionary* info = @{@"time" : [MyTool getCurrentTime],
                           @"desc" : [NSString stringWithFormat:@"设备\"%@\"烘焙完成",self.currentOven.name]};
    
    [[DataCenter sharedInstance] addOvenNotification:info];
    
    CompleteCookController* completeController = [self.storyboard instantiateViewControllerWithIdentifier:@"Complete cook controller"];
    completeController.completeTye = CompleteTyeCook;
    completeController.delegate = self;
    completeController.myOven = self.myOven;
    [self.navigationController pushViewController:completeController animated:YES];
    
    
}

- (void)completeWarmUp
{
    self.toolbarItems = @[fixbtn,ksyrTab,fixbtn,startTab,fixbtn];
    
    self.deviceBoardStatus = DeviceBoardStatusOpened;
    
    CompleteCookController* completeController = [self.storyboard instantiateViewControllerWithIdentifier:@"Complete cook controller"];
    completeController.completeTye = CompleteTyeWarmUp;
    completeController.delegate = self;
    completeController.myOven = self.myOven;
    [self.navigationController pushViewController:completeController animated:YES];
    
}

-(void)StopWorking{
    if (self.myOven == nil) {
        [super showProgressErrorWithLabelText:@"烤箱连接失败" afterDelay:1];
        return;
    }
    
    [self.bakeTimer invalidate];
    self.toolbarItems = @[ fixbtn,ksyrTab,fixbtn,startTab,fixbtn];
    [self.timeable invalidate];
    self.timeable = nil;
    self.deviceBoardStatus = DeviceBoardStatusOpened;
    
    uSDKDeviceAttribute* command = [[OvenManager sharedManager] structureWithCommandName:kPause commandAttrValue:kPause];
    
    [[OvenManager sharedManager] executeCommands:[@[command] mutableCopy]
                                        toDevice:self.myOven
                                    andCommandSN:0
                             andGroupCommandName:@""
                                        callback:^(BOOL success, uSDKErrorConst errorCode) {
        
    }];
    

}

#pragma mark - CompleteCookControllerDelegate

- (void)cookCompleteToShutdown:(BOOL)shutdown
{
    if (shutdown) {
        self.deviceBoardStatus = DeviceBoardStatusClosed;
        
        NSDictionary* info = @{@"time" : [MyTool getCurrentTime],
                               @"desc" : [NSString stringWithFormat:@"设备\"%@\"关机了",self.currentOven.name]};
        
        [[DataCenter sharedInstance] addOvenNotification:info];
        
        for (UIButton* button in self.deviceStatusBtns) {
            button.selected = NO;
        }
    } else {
        self.deviceBoardStatus = DeviceBoardStatusOpened;
        
        NSDictionary* info = @{@"time" : [MyTool getCurrentTime],
                               @"desc" : [NSString stringWithFormat:@"设备\"%@\"开机了",self.currentOven.name]};
        
        [[DataCenter sharedInstance] addOvenNotification:info];
        
        for (UIButton* button in self.deviceStatusBtns) {
            button.selected = YES;
        }
    }
}

#pragma mark - 按钮响应事件

- (IBAction)TurnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)TurnEdit:(id)sender {
    DeviceEditController *edit = [self.storyboard instantiateViewControllerWithIdentifier:@"DeviceEditController"];
    
    edit.currentOven = self.currentOven;
    edit.myOven = self.myOven;
    
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
                                        callback:^(BOOL success, uSDKErrorConst errorCode) {
                                            
                                        }];

    
    sender.selected = !sender.selected;
}

/**
 *  同步时钟
 *
 *  @param sender 同步时钟按钮
 */
- (IBAction)syncronizeTime:(UIButton *)sender
{
    sender.selected = YES;
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"hh:mm";
    NSString* time = [formatter stringFromDate:[NSDate date]];
    
    uSDKDeviceAttribute* command = [[OvenManager sharedManager] structureWithCommandName:@"20v00i" commandAttrValue:time];
    [super showProgressHUDWithLabelText:@"请稍候..." dimBackground:NO];
    [[OvenManager sharedManager] executeCommands:[@[command] mutableCopy] toDevice:self.myOven andCommandSN:0 andGroupCommandName:@"" callback:^(BOOL success, uSDKErrorConst errorCode) {
        [super hiddenProgressHUD];
        [super showProgressCompleteWithLabelText:@"时间已同步" afterDelay:1];
    }];
    
}



#pragma mark - 开机关机

- (IBAction)onoff:(UIButton*)sender {
    if (self.myOven == nil) {
        [super showProgressErrorWithLabelText:@"烤箱连接失败" afterDelay:1];
        return;
    }
    
    for (UIButton *btn in self.deviceStatusBtns) {
        btn.selected = !btn.selected;
    }
    
    UIButton *btn = [self.deviceStatusBtns firstObject];
    self.deviceBoardStatus = btn.selected ==NO?DeviceBoardStatusClosed:DeviceBoardStatusOpened;
    
    UIButton* button = sender;
    if (button.selected) {
        [self bootup];
        
        NSDictionary* info = @{@"time" : [MyTool getCurrentTime],
                               @"desc" : [NSString stringWithFormat:@"设备\"%@\"开机了",self.currentOven.name]};
        
        [[DataCenter sharedInstance] addOvenNotification:info];
        
    } else {
        [self shutdown];
        
        NSDictionary* info = @{@"time" : [MyTool getCurrentTime],
                               @"desc" : [NSString stringWithFormat:@"设备\"%@\"关机了",self.currentOven.name]};
        
        [[DataCenter sharedInstance] addOvenNotification:info];
        
    }
    
}

-(void)setDeviceBoardStatus:(DeviceBoardStatus)deviceBoardStatus{
    _deviceBoardStatus = deviceBoardStatus;
    switch (_deviceBoardStatus) {
        case DeviceBoardStatusClosed:
            for (UIButton* btn in self.allbtns) {
                btn.enabled = NO;
                btn.selected = NO;
            }
            
            for (UIButton *btn in self.controlBtns) {
                btn.enabled = NO;
                btn.selected = NO;
            }
            for (UIButton *btn in self.workModelBtns) {
                btn.enabled = NO;
                btn.selected = NO;
            }
            
            for (UIBarButtonItem *btn in self.toolbarItems) {
                btn.enabled = NO;
            }
            self.actionCell.hidden = YES;
            [self.tableView reloadData];
            break;
            
        case DeviceBoardStatusOpened:
            for (UIButton* btn in self.allbtns) {
                btn.enabled = YES;
                btn.selected = NO;
            }
            
            for (UIButton *btn in self.controlBtns) {
                btn.enabled = btn.tag == 3 ? YES : NO;
                btn.selected = NO;
            }
            
            for (UIButton *btn in self.workModelBtns) {
                btn.enabled =YES;
                btn.selected = NO;
            }
            
            for (UIBarButtonItem *btn in self.toolbarItems) {
                btn.enabled = NO;
            }
            
            //初始状态下闹钟按钮和快速预热可点击
            self.clockIcon.enabled = YES;
            self.ksyrTab.enabled = YES;
            
            self.actionCell.hidden = YES;
            [self.tableView reloadData];
            break;

        case DeviceBoardStatusWorking:
            for (UIButton* btn in self.allbtns) {
                btn.enabled = YES;
            }
            
            for (UIButton *btn in self.controlBtns) {
                btn.enabled = YES;
            }
            
            for (UIButton *btn in self.workModelBtns) {
                btn.enabled = YES;
            }
            
            for (UIBarButtonItem *btn in self.toolbarItems) {
                btn.enabled = YES;
            }
            self.actionCell.hidden = NO;
            
            [self.tableView reloadData];
            break;
            
            
        case DeviceBoardStatusSelectMode:
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
                                        callback:^(BOOL success, uSDKErrorConst errorCode) {
                                            
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
                                        callback:^(BOOL success, uSDKErrorConst errorCode) {
                                            
                                        }];
}

// 闹钟
- (void)setClockTime:(NSString*)clockString
{
    clockString = clockString?clockString:@"1 分钟";
    
    NSRange range = [clockString rangeOfString:@" 分钟"];
    NSString* timeStr = [clockString substringToIndex:range.location];
    NSInteger minutes = [timeStr integerValue];
    seconds = minutes*60;
    __block CGFloat i = 0;
    [self.cookTimeView startWithBlock:^CGFloat{
        return i++ / seconds;
    }];
    
    self.clockAlert.seconds = seconds;
    self.clockAlert.start = YES;
    
    [[DataCenter sharedInstance] sendLocalNotification:LocalNotificationTypeClockTimeUp fireTime:seconds alertBody:@"您设定的闹钟时间到了。"];
    
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
                                        callback:^(BOOL success, uSDKErrorConst errorCode) {
                                            
                                        }];
    
}

// 温度探针
- (void)setNeedleTemperature:(NSString*)temperatureString
{
    
    
}

// 预热
- (void)setWarmUpTemperature:(NSString*)temperatureString
{
  
    NSString* timeStr = @"5";   //设置默认预热5分钟
    
    self.bakeModeLabel.text = [NSString stringWithFormat:@"工作模式：%@", @"快速预热"];
    self.bakeTimeLabel.text = [NSString stringWithFormat:@"时间：%@ 分钟", timeStr];
    self.bakeTemperatureLabel.text = [NSString stringWithFormat:@"目标温度：%@", temperatureString];
    
    NSRange range = [temperatureString rangeOfString:@"°"];
    NSString* temperatureValue = [temperatureString substringToIndex:range.location];
    
    NSInteger minutes = [timeStr integerValue];
    NSString* timeValue = [NSString stringWithFormat:@"%02d:%02d", minutes/60, minutes%60];
    
    //    调用顺序：检测是否已开机 - 设置模式 - 启动 - 设置温度 - 设置时间
    //调用顺序：检测是否已开机 - 设置模式 - 设置温度 - 设置时间 - 启动
    
    if (!self.ovenManager.currentStatus.opened) {
        [self bootup];
    }
    
    [super showProgressHUDWithLabelText:@"请稍候..." dimBackground:NO];
    [[OvenManager sharedManager] setBakeMode:@"30v0M1" callback:^(BOOL success, uSDKErrorConst errorCode) {     //快速预热模式
        [super hiddenProgressHUD];
        if (success) {
            [super showProgressHUDWithLabelText:@"请稍候..." dimBackground:NO];
            [[OvenManager sharedManager] setBakeTime:timeValue callback:^(BOOL success, uSDKErrorConst errorCode) {
                [super hiddenProgressHUD];
                if (success) {
                    [super showProgressHUDWithLabelText:@"请稍候..." dimBackground:NO];
                    [[OvenManager sharedManager] setBakeTemperature:temperatureValue callback:^(BOOL success, uSDKErrorConst errorCode) {
                        [super hiddenProgressHUD];
                        if (success) {
                            
                            uSDKDeviceAttribute* command = [[OvenManager sharedManager] structureWithCommandName:kStartUp commandAttrValue:kStartUp];
                            [super showProgressHUDWithLabelText:@"请稍候..." dimBackground:NO];
                            [[OvenManager sharedManager] executeCommands:[@[command] mutableCopy]
                                                                toDevice:self.myOven
                                                            andCommandSN:0
                                                     andGroupCommandName:@""
                                                                callback:^(BOOL success, uSDKErrorConst errorCode) {
                                                                    [super hiddenProgressHUD];
                                                                    self.deviceBoardStatus = DeviceBoardStatusWorking;
                                                                    
                                                                    //点击运行后显示
                                                                    self.timeable =  [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
                                                                    
                                                                    self.time = [timeStr integerValue] * 60;
                                                                    float animateDueation = [timeStr integerValue] * 60;
                                                                    self.startStatusView.animationDuration = animateDueation;
                                                                    [self.startStatusView.lineProgressView setCompleted:1.0*80 animated:YES];
                                                                    
                                                                    self.toolbarItems = @[ fixbtn,tzyxTab,fixbtn];
                                                                    
                                                                    NSTimeInterval bakeSeconds = [timeStr integerValue] * 60.0;
                                                                    [[DataCenter sharedInstance] sendLocalNotification:LocalNotificationTypeWarmUp fireTime:bakeSeconds alertBody:@"您的烤箱预热完成了"];
                                                                    
                                                                    NSDictionary* info = @{@"time" : [MyTool getCurrentTime],
                                                                                           @"desc" : [NSString stringWithFormat:@"设备\"%@\"开始烘焙，模式：快速预热，时间：%@，温度：%@",
                                                                                                      self.currentOven.name,
                                                                                                      timeStr,
                                                                                                      temperatureString]};
                                                                    
                                                                    [[DataCenter sharedInstance] addOvenNotification:info];
                                                                    
//                                                                    [self performSelector:@selector(completeWarmUp) withObject:nil afterDelay:bakeSeconds];
                                                                    self.bakeTimer = [NSTimer scheduledTimerWithTimeInterval:bakeSeconds target:self selector:@selector(completeWarmUp) userInfo:nil repeats:NO];
                                                                    
                                                                }];
                            
                        } else {
                            
                            [super showProgressErrorWithLabelText:@"设置烘焙温度失败" afterDelay:1];
                            
                        }
                        
                    }];
                    
                } else {
                    [super showProgressErrorWithLabelText:@"设置烘焙时间失败" afterDelay:1];
                }
                
                
            }];
            
        } else {
            [super showProgressErrorWithLabelText:@"设置烘焙模式失败" afterDelay:1];
        }
        
    }];

    
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
//            [self setBakeTime:string];
            break;
        case alertTempture:
            self.tempString = string;
//            [self setBakeTemperature:string];
            break;
        case alertClock:
            self.clockString = string;
            [self setClockTime:string];
            break;
//        case alertOrder:    //预约
//            self.orderString = string;
//            [self setOrderTime:string];
//            break;
        case alertNeedle:   //温度探针
            self.neddleString = string;
            [self setNeedleTemperature:string];
            break;
        case alertWormUp:
            self.warmUpString = string;
            ksyr.selected = !ksyr.selected;
            [self setWarmUpTemperature:string];
            
            break;
            
        default:
            break;
    }
    
    self.myWindow.hidden = YES;
    self.deviceAlertView.frame = alertRectHidden;

}

#pragma mark - 弹出设定窗口

- (IBAction)alertView:(UIButton *)sender {
    NSLog(@"%d",sender.tag);
    if (sender.tag ==5) {   // 预约按钮按下
        
        if (!self.howlong.selected) {
            [super showProgressErrorWithLabelText:@"请先设定预约的烘焙时长" afterDelay:2];
            return;
        }
        
        NSRange range = [self.howlong.currentTitle rangeOfString:@" 分钟"];
        NSString* timeStr = [self.howlong.currentTitle substringToIndex:range.location];

        self.orderAlert.minimumInteval = [timeStr integerValue] * 60.0;
        
        [UIView animateWithDuration:0.2 animations:^{
            self.orderAlert.frame = alertRectShow;
            
            self.myWindow.hidden = NO;

        } completion:^(BOOL finished) {
            
        }];

    } else if (sender.selected ==NO ||sender.tag==1||sender.tag==2) {
        self.deviceAlertView.alertType = sender.tag;
        self.deviceAlertView.btn = sender;
        
        switch (sender.tag) {
                
            case 1:
                if (self.deviceBoardStatus == DeviceBoardStatusWorking) {
                    [super showProgressErrorWithLabelText:@"停止运行后，参数可调" afterDelay:1];
                    return;
                }
                self.deviceAlertView.string = @"180°";
                break;
            case 2:
                if (self.deviceBoardStatus == DeviceBoardStatusWorking) {
                    [super showProgressErrorWithLabelText:@"停止运行后，参数可调" afterDelay:1];
                    return;
                }
                self.deviceAlertView.string = @"30 分钟";
                break;
            default:
                break;
        }
        
        self.myWindow.hidden = NO;

        
        [UIView animateWithDuration:0.2 animations:^{
            self.deviceAlertView.frame = alertRectShow;
        } completion:^(BOOL finished) {
            
        }];
    } else sender.selected = NO;

}

#pragma mark - 选择了预约时间

-(void)SettingOrder:(NSDate *)date{
    
    [self OrderAlertViewHidden];
    
    // 计算开始烘焙时间，已确保在预约时间之前完成烘焙：开始烘焙时间 = 预约完成时间 - 烘焙所需时间间隔
    
    // 1. 得到预约完成时间距离现在的秒数
    NSTimeInterval inteval = [date timeIntervalSinceNow];
    // 2. 得到开始烘焙的时间距离现在的秒数
    inteval = inteval - self.orderAlert.minimumInteval;
    
    // 3. inteval时间后发送预约指令
#warning 这里需要补全
    
    
}

-(void)OrderAlertViewHidden{
    self.orderAlert.frame = alertRectHidden;
    self.myWindow.hidden = YES;
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



#pragma kkprogressTimerDelegate
- (void)didUpdateProgressTimer:(KKProgressTimer *)progressTimer percentage:(CGFloat)percentage {
    
    if (percentage >= 1) {
        [progressTimer stop];
    }
//    NSInteger remainSeconds = (long)(self.seconds - self.seconds * percentage);
//    self.remainLabel.text = [NSString stringWithFormat:@"%02d:%02d", remainSeconds/60, remainSeconds%60];
    
}

- (void)didStopProgressTimer:(KKProgressTimer *)progressTimer percentage:(CGFloat)percentage {
    NSLog(@"%s %f", __PRETTY_FUNCTION__, percentage);
    if (self.myWindow.hidden) {
        [self StopClock];
        [self TimeOutAlertShow];
    }
}


#pragma  mark- TimeAlertDelegate

-(void)HiddenClockAlert{
    self.myWindow.hidden = YES;
    self.clockAlert.frame = alertRectHidden;
}

-(void)StopClock{
    self.myWindow.hidden = YES;
    self.clockAlert.frame = alertRectHidden;
    self.clockIcon.selected = NO;
    self.clockAlert.start = NO;
}



-(void)timeOutAlertHidden{
    self.myWindow.hidden = YES;
    self.timeOutAlert.frame = alertRectHidden;
    self.clockIcon.selected = NO;
}

-(void)TimeOutAlertShow{
    self.clockAlert.frame = alertRectHidden;
    self.myWindow.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        //        self.deviceAlertView.frame = alertRectShow;
        //        self.clockAlert.frame = CGRectMake(alertRectShow.origin.x, alertRectShow.origin.y, alertRectShow.size.width, 200);
    self.timeOutAlert.frame = CGRectMake(alertRectShow.origin.x,PageH/2-40, alertRectShow.size.width, 81);
    } completion:^(BOOL finished) {
        
    }];

}
@end
