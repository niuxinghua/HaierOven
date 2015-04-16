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
#import "OvenOperator.h"

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

///**
// *  烘焙倒计时
// */
//@property (strong, nonatomic) NSTimer *timeable;

/**
 * 烘焙时间是否已到
 */
//@property (strong, nonatomic) NSTimer* bakeTimer;

//@property int time;

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
 *  烘焙温度按钮
 */
@property (strong, nonatomic) IBOutlet UIButton *temputure;

/**
 *  烘焙时间按钮
 */
@property (strong, nonatomic) IBOutlet UIButton *howlong;

/**
 *  预约按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *orderButton;

/**
 *  烘焙模式
 */
@property (strong, nonatomic) NSDictionary* bakeMode;

/**
 *  Oven实例
 */
@property (strong, nonatomic) uSDKDevice* myOven;


@property (nonatomic) AlertType alertType;
@property (copy, nonatomic) NSString *orderString;
@property (copy, nonatomic) NSString *clockString;
@property (copy, nonatomic) NSString *neddleString;
@property (copy, nonatomic) NSString *tempString;
@property (copy, nonatomic) NSString *timeString;
@property (copy, nonatomic) NSString *warmUpString;

@property (strong, nonatomic) OvenManager* ovenManager;

@property (strong, nonatomic) OvenOperator* ovenOperator;


/**
 *  设置的探针温度字符串
 */
@property (copy, nonatomic) NSString* selectedNeedleTemperature;

/**
 *  设置的快速预热温度字符串
 */
@property (copy, nonatomic) NSString* selectedWarmUpTempearature;

/**
 *  设置的预约时间(完成时间)
 */
@property (strong, nonatomic) NSDate* selectedOrderTime;

/**
 *  检查预约开始时间是否已到
 */
//@property (strong, nonatomic) NSTimer* orderingTimer;

/**
 *  是否取消闹钟，取消闹钟则不发通知
 */
@property (nonatomic) BOOL clockStopFlag;

/**
 *  是不是上次订阅的设备
 */
@property (nonatomic) BOOL isLastDevice;


#pragma mark - 约束

/**
 *  控制开关左边约束
 */
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *controlConstraintArr;

/**
 *  控制开关宽度约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *controlWidthConstraint;

/**
 *  辅助功能按钮左边约束
 */
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *functionConstraintArr;

/**
 *  辅助功能按钮宽度约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *functionWidthConstraint;


@end

@implementation DeviceBoardViewController

@synthesize startTab;
@synthesize ksyrTab;
@synthesize tzyxTab;
@synthesize fixbtn;
@synthesize ksyr;

#pragma mark - 更新约束

- (void)updateViewConstraints
{
    
    [self autoArrangeBoxWithConstraints:self.controlConstraintArr width:self.controlWidthConstraint.constant];
    
    [self autoArrangeBoxWithConstraints:self.functionConstraintArr width:self.functionWidthConstraint.constant];
    
    [super updateViewConstraints];
}

- (void)autoArrangeBoxWithConstraints:(NSArray*)constraintArray width:(CGFloat)width
{
    CGFloat step = (self.view.frame.size.width - (width * constraintArray.count)) / (constraintArray.count + 1);
    for (int i = 0; i < constraintArray.count; i++) {
        NSLayoutConstraint* constraint = constraintArray[i];
        constraint.constant = step * (i + 1) + width * i;
    }
    
    
}

#pragma mark - 初始化

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupSubviews];
    
    [self setupAlertViews];
    
    [self setupToolbarItems];
    
    [self setObservers];
    
    [self loadMyOvenInstance];
    
}

- (void)setupSubviews
{
    self.tableView.backgroundView = [[UIImageView alloc]initWithImage:IMAGENAMED(@"boardbg")];
    
    NSMutableArray* modes = [[OvenManager sharedManager] bakeModesForType:self.currentOven.typeIdentifier];
    self.workModelBtns = [NSMutableArray new];
    for (int i = 0; i < modes.count; i++) {
        NSDictionary* modeDict = modes[i];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:IMAGENAMED(modeDict[@"normalImage"]) forState:UIControlStateNormal];
        [btn setBackgroundImage:IMAGENAMED(modeDict[@"selectedImage"]) forState:UIControlStateSelected];
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
    
    self.pageView.numberOfPages = ceilf(modes.count/5.0);
    self.deviceScrollView.contentSize = CGSizeMake(_deviceScrollView.frame.size.width * self.pageView.numberOfPages, _deviceScrollView.frame.size.height);
    self.deviceScrollView.pagingEnabled = YES;
    self.pageView.delegate = self;
    self.deviceScrollView.delegate = self;
    self.deviceScrollView.tag = 10;
    
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

- (void)setupAlertViews
{
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
    [tzyx addTarget:self action:@selector(stopWorking) forControlEvents:UIControlEventTouchUpInside];
    tzyx.frame = CGRectMake(0, 0, PageW-30, width *0.272);
    
    
    //木棍
    fixbtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    startTab = [[UIBarButtonItem alloc]initWithCustomView:start];
    tzyxTab = [[UIBarButtonItem alloc]initWithCustomView:tzyx];
    ksyrTab = [[UIBarButtonItem alloc] initWithCustomView:ksyr];
    
    //初始状态显示快速预热和开始运行
    self.toolbarItems = @[ fixbtn,ksyrTab,fixbtn,startTab,fixbtn];
}


- (void)loadMyOvenInstance
{
    // 初始状态是关机状态
    self.deviceBoardStatus = DeviceBoardStatusClosed;
    
    self.ovenManager = [OvenManager sharedManager];
    
    self.ovenOperator = [OvenOperator sharedOperator];
    
    self.ovenOperator.currentLocalOven = self.currentOven;
    
    if (self.myOven != nil && [self.currentOven.mac isEqualToString:self.myOven.mac]) {
        [self.ovenManager subscribeAllNotificationsWithDevice:@[self.myOven.mac]];
    } else {
        
        if (DebugOvenFlag) {
            //[super showProgressHUDWithLabelText:@"请稍候..." dimBackground:NO];
            self.deviceBoardStatus = DeviceBoardStatusOpened;  //调试
            [self updateOvenStatus];
            
        } else {
            [super showProgressHUDWithLabelText:@"请稍候..." dimBackground:NO];
        }
        
        [self.ovenManager getDevicesCompletion:^(BOOL success, id obj, NSError *error) {
            
            if (success) {
                //找到Wifi下烤箱列表，并获取指定烤箱对象
                NSArray* ovenList = obj;
                for (uSDKDevice* oven in ovenList) {
                    if ([self.currentOven.mac isEqualToString:oven.mac]) {
                        self.myOven = oven;
                        [OvenManager sharedManager].subscribedDevice = self.myOven;
                        //搜索到设备则开始订阅通知，订阅成功烤箱即进入就绪状态，可以发送指令
                        //                    [[OvenManager sharedManager] subscribeDevice:self.myOven];
                        [[OvenManager sharedManager] subscribeAllNotificationsWithDevice:@[self.myOven.mac]];
                        
                        [self updateOvenStatus];
                        
                    }
                }
            } else {
                [super showProgressErrorWithLabelText:@"烤箱连接失败" afterDelay:1];
            }
        }];
        
    }
    
}

- (void)setObservers
{
    // 监控在线状态
    [self addObserver:self forKeyPath:@"self.ovenManager.currentStatus.isReady" options:NSKeyValueObservingOptionNew context:NULL];
    // 监控温度
    [self addObserver:self forKeyPath:@"self.ovenManager.currentStatus.temperature" options:NSKeyValueObservingOptionNew context:NULL];
    
    // 监控设备开机状态
    [self addObserver:self forKeyPath:@"self.ovenManager.currentStatus.opened" options:NSKeyValueObservingOptionNew context:NULL];
    // 监控是否有闹钟
    [self addObserver:self forKeyPath:@"self.clockIcon.selected" options:NSKeyValueObservingOptionNew context:NULL];
    
    // 监控烘焙倒计时时间的变化
    [self addObserver:self forKeyPath:@"self.ovenOperator.bakeLeftSeconds" options:NSKeyValueObservingOptionNew context:NULL];
    
    // 收听设备是否开始工作
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didStartWorking:) name:DeviceStartWorkNotification object:nil];
    
    // 收听是否工作完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(completeBake:) name:DeviceWorkCompletedNotification object:nil];
    
}



#pragma mark - 监听烤箱状态并作出反应

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
//    NSLog(@"******设备状态变化啦**********");
//    NSLog(@"在线：%d, 开机：%d, 工作：%d, 温度：%d, 时间：%@", self.ovenManager.currentStatus.isReady, _ovenManager.currentStatus.opened, self.ovenManager.currentStatus.isWorking, _ovenManager.currentStatus.temperature, _ovenManager.currentStatus.bakeTime);
    
    if ([keyPath isEqualToString:@"self.ovenManager.currentStatus.isReady"]) {
        if (_ovenManager.currentStatus.isReady) {
            [self.deviceNameButton setTitle:[NSString stringWithFormat:@"%@已连接，待机中", self.currentOven.name] forState:UIControlStateNormal];
        } else {
            [self.deviceNameButton setTitle:[NSString stringWithFormat:@"%@未连接，请稍候", self.currentOven.name] forState:UIControlStateNormal];
        }
        
    } else if ([keyPath isEqualToString:@"self.ovenManager.currentStatus.temperature"]) {
        // 温度变化，如果设有温度探针，则当烤箱到达指定温度后弹窗通知
        
        
    } else if ([keyPath isEqualToString:@"self.ovenManager.currentStatus.opened"]) {

        
    } else if ([keyPath isEqualToString:@"self.clockIcon.selected"]) {
        
        self.cookTimeView.hidden = !self.clockIcon.selected;
        self.clockIcon.hidden = self.clockIcon.selected;
        
    } else if ([keyPath isEqualToString:@"self.ovenOperator.bakeLeftSeconds"]) {
        
        //烘焙倒计时更新UI
        if (self.ovenOperator.deviceStatus == CurrentDeviceStatusWorking) {
            self.startStatusView.leftTime = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",
                                             self.ovenOperator.bakeLeftSeconds/3600,
                                             (self.ovenOperator.bakeLeftSeconds%3600)/60,
                                             (self.ovenOperator.bakeLeftSeconds%3600)%60];
        }
        
    }
    
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"self.ovenManager.currentStatus.isReady" context:NULL];
    [self removeObserver:self forKeyPath:@"self.ovenManager.currentStatus.temperature" context:NULL];
    [self removeObserver:self forKeyPath:@"self.ovenManager.currentStatus.opened" context:NULL];
    [self removeObserver:self forKeyPath:@"self.clockIcon.selected"];
    [self removeObserver:self forKeyPath:@"self.ovenOperator.bakeLeftSeconds" context:NULL];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // 保存上次订阅设备的Mac
    if (self.myOven != nil) {
        self.ovenManager.lastSubscribedDeviceMac = self.myOven.mac;
    }
    
//    self.bakeTimer = nil;
}

#pragma mark - 显示系列

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.toolbarHidden = NO;
    self.navigationController.toolbar.height = PageW*0.18;
    self.navigationController.toolbar.frame = CGRectMake(0, PageH-PageW*0.18, PageW, PageW*0.18);
    
    if (self.deviceBoardStatus == DeviceBoardStatusWorking) {
        [self.startStatusView resetAnimate];
        self.startStatusView.animationDuration = self.ovenOperator.bakeLeftSeconds;
        [self.startStatusView.lineProgressView setCompleted:1.0*80 animated:YES];
    }
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.navigationController.toolbarHidden = YES;
}

#pragma mark - 获取烤箱的状态

- (BOOL)isLastDevice
{
    return [self.myOven.mac isEqualToString:[OvenManager sharedManager].lastSubscribedDeviceMac];
}

- (void)updateOvenStatus
{
    // 从菜谱详情跳转，需直接开始烘焙
    if (self.startBakeOvenInfo != nil) {
        
        if (!self.ovenManager.currentStatus.opened) {
            [self bootup];
            [NSThread sleepForTimeInterval:1];
        }
        
        if (!DebugOvenFlag) {
            [super hiddenProgressHUD];
        }
        
        NSInteger bakeModeIndex = 0;
        // 默认状态是传统烘焙
        if ([self.startBakeOvenInfo.roastStyle hasPrefix:@"上下烘焙"] || self.startBakeOvenInfo.roastStyle == nil || self.startBakeOvenInfo.roastStyle.length == 0) {
            self.startBakeOvenInfo.roastStyle = @"传统烘焙";
        }
        for (NSDictionary* mode in [[OvenManager sharedManager] bakeModesForType:self.currentOven.typeIdentifier]) {
            NSDictionary* bakeMode = mode[@"bakeMode"];
            NSString* modeName = [[bakeMode allValues] firstObject];
            if ([modeName hasPrefix:self.startBakeOvenInfo.roastStyle]) {
                self.bakeMode = mode;
                bakeModeIndex = [[[OvenManager sharedManager] bakeModesForType:self.currentOven.typeIdentifier] indexOfObject:mode];
                break;
            }
        }
        
        self.ovenOperator.bakeLeftSeconds = [self.startBakeOvenInfo.roastTime integerValue] * 60; //转换为秒
        
        NSString* modeStr = [[self.bakeMode[@"bakeMode"] allValues] firstObject];
        
        self.bakeModeLabel.text = [NSString stringWithFormat:@"工作模式：%@", modeStr];
        self.bakeTimeLabel.text = [NSString stringWithFormat:@"时间：%d 分钟", self.ovenOperator.bakeLeftSeconds/60];
        self.bakeTemperatureLabel.text = [NSString stringWithFormat:@"目标温度：%@°", self.startBakeOvenInfo.roastTemperature];
        
        [self.howlong setTitle:[NSString stringWithFormat:@"%d 分钟", self.ovenOperator.bakeLeftSeconds/60] forState:UIControlStateNormal];
        [self.temputure setTitle:[NSString stringWithFormat:@"%@°", self.startBakeOvenInfo.roastTemperature] forState:UIControlStateNormal];
        
        UIButton* currentModeBtn = self.workModelBtns[bakeModeIndex];
        currentModeBtn.selected = YES;
        
        [self startBake];
        
        return;
    }
    
    // 获取烤箱当前的状态，并更新UI
    [[OvenManager sharedManager] getOvenStatus:self.currentOven.mac status:^(BOOL success, id obj, NSError *error) {
        OvenStatus* status = obj;
        if (success) {
            
            if (status.isReady) {
                
                [super hiddenProgressHUD];
                
                if (status.opened) {
                    self.deviceBoardStatus = DeviceBoardStatusOpened;
                }
                if (status.closed) {
                    self.deviceBoardStatus = DeviceBoardStatusClosed;
                }
                if (status.isWorking) {
                    
                    NSInteger bakeModeIndex = 0;
                    
                    for (NSDictionary* mode in [[OvenManager sharedManager] bakeModesForType:self.currentOven.typeIdentifier]) {
                        NSDictionary* bakeMode = mode[@"bakeMode"];
                        if ([[[bakeMode allKeys] firstObject] isEqualToString:status.bakeMode]) {
                            self.bakeMode = mode;
                            bakeModeIndex = [[[OvenManager sharedManager] bakeModesForType:self.currentOven.typeIdentifier] indexOfObject:mode];
                            break;
                        }
                    }
                    
                    float animateDueation = self.ovenOperator.bakeLeftSeconds;
                    [self.startStatusView resetAnimate];
                    self.startStatusView.animationDuration = animateDueation;
                    [self.startStatusView.lineProgressView setCompleted:1.0*80 animated:YES];
                    
                    NSString* modeStr = [[self.bakeMode[@"bakeMode"] allValues] firstObject];
                    
                    if (modeStr == nil) {
                        modeStr = @"快速预热";
                    } else {
                        UIButton* currentModeBtn = self.workModelBtns[bakeModeIndex];
                        currentModeBtn.selected = YES;
                    }
                    
                    if (self.isLastDevice) {
                        // 点进来的是上次的设备
                        NSInteger totalSeconds = [[self.ovenOperator.totalBakeTime substringToIndex:2] integerValue] * 60 * 60 + [[self.ovenOperator.totalBakeTime substringFromIndex:3] integerValue] * 60;
                        
                        if (self.ovenOperator.deviceStatus == CurrentDeviceStatusPreheating) {
                            
                            self.deviceBoardStatus = DeviceBoardStatusPreheating;
                            
                            [self.startStatusView resetAnimate];
                            self.startStatusView.leftTime = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",
                                                             totalSeconds/3600,
                                                             (totalSeconds%3600)/60,
                                                             (totalSeconds%3600)%60];
                            [self.howlong setTitle:[NSString stringWithFormat:@"%d 分钟", totalSeconds/60] forState:UIControlStateNormal];
                            [self.temputure setTitle:[NSString stringWithFormat:@"%@°", self.ovenOperator.currentBakeTemperature] forState:UIControlStateNormal];
                            self.bakeTimeLabel.text = [NSString stringWithFormat:@"时间：%d 分钟", totalSeconds/60];
                            
                        } else if (self.ovenOperator.deviceStatus == CurrentDeviceStatusWorking) {
                            
                            [self.howlong setTitle:[NSString stringWithFormat:@"%d 分钟", totalSeconds/60] forState:UIControlStateNormal];
                            [self.temputure setTitle:[NSString stringWithFormat:@"%d°", status.temperature] forState:UIControlStateNormal];
                            
                            self.bakeTimeLabel.text = [NSString stringWithFormat:@"时间：%d 分钟", totalSeconds/60];
                            self.deviceBoardStatus = DeviceBoardStatusWorking;
                            
                        } else {
                            
                            self.ovenOperator.bakeLeftSeconds = [[status.bakeTime substringToIndex:2] integerValue] * 60 * 60 + [[status.bakeTime substringFromIndex:3] integerValue] * 60;
                            self.ovenOperator.totalBakeTime = status.bakeTime;
                            
                            [self.howlong setTitle:[NSString stringWithFormat:@"%d 分钟", self.ovenOperator.bakeLeftSeconds/60] forState:UIControlStateNormal];
                            [self.temputure setTitle:[NSString stringWithFormat:@"%d°", status.temperature] forState:UIControlStateNormal];
                            
                            NSTimeInterval bakeSeconds = self.ovenOperator.bakeLeftSeconds;
                            [[DataCenter sharedInstance] sendLocalNotification:LocalNotificationTypeBakeComplete fireTime:bakeSeconds alertBody:@"您的食物烘焙完成了"];
                            
                            self.deviceBoardStatus = DeviceBoardStatusWorking;
                            self.ovenOperator.deviceStatus = CurrentDeviceStatusWorking;
                            
                            self.bakeTimeLabel.text = [NSString stringWithFormat:@"时间：%d 分钟", self.ovenOperator.bakeLeftSeconds/60];
                        }
                        
                    } else {
                        // 点进来的不是上次控制的设备
                        self.ovenOperator.bakeLeftSeconds = [[status.bakeTime substringToIndex:2] integerValue] * 60 * 60 + [[status.bakeTime substringFromIndex:3] integerValue] * 60;
                        self.ovenOperator.totalBakeTime = status.bakeTime;
                        
                        [self.howlong setTitle:[NSString stringWithFormat:@"%d 分钟", self.ovenOperator.bakeLeftSeconds/60] forState:UIControlStateNormal];
                        [self.temputure setTitle:[NSString stringWithFormat:@"%d°", status.temperature] forState:UIControlStateNormal];
                        
                        NSTimeInterval bakeSeconds = self.ovenOperator.bakeLeftSeconds;
                        [[DataCenter sharedInstance] sendLocalNotification:LocalNotificationTypeBakeComplete fireTime:bakeSeconds alertBody:@"您的食物烘焙完成了"];
                        
                        self.deviceBoardStatus = DeviceBoardStatusWorking;
                        self.ovenOperator.deviceStatus = CurrentDeviceStatusWorking;
                        
                        self.bakeTimeLabel.text = [NSString stringWithFormat:@"时间：%d 分钟", self.ovenOperator.bakeLeftSeconds/60];
                        
                    }
                    self.bakeModeLabel.text = [NSString stringWithFormat:@"工作模式：%@", modeStr];
                    self.bakeTemperatureLabel.text = [NSString stringWithFormat:@"目标温度：%d°", status.temperature];
                    
                }
                
            } else {
                [self performSelector:@selector(updateOvenStatus) withObject:nil afterDelay:2];
            }
            
        }
        
    }];
}


#pragma mark - PageView & DeviceScrollView 设置

- (void)updatePager
{
//    self.pageView.page = floorf(_deviceScrollView.contentOffset.x / _deviceScrollView.frame.size.width);
    self.pageView.page = ceilf(_deviceScrollView.contentOffset.x * 1.0 / _deviceScrollView.frame.size.width);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //[self updatePager];
    if (scrollView.tag == 10) {
        NSLog(@"-----%.2f------", scrollView.contentOffset.x * 1.0 / scrollView.frame.size.width);
//        self.pageView.page = floorf(_deviceScrollView.contentOffset.x / _deviceScrollView.frame.size.width);
        self.pageView.page = ceilf(scrollView.contentOffset.x * 1.0 / scrollView.frame.size.width);
    }
    
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

#pragma mark - 点击了闹钟倒计时小图标

- (void)TouchTimeView
{
    self.myWindow.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.clockAlert.frame = alertRectShow;
    } completion:^(BOOL finished) {
        
    }];
    
}

#pragma mark -选择工作模式

-(void)WorkModelChick:(UIButton*)sender
{
    if (self.deviceBoardStatus == DeviceBoardStatusWorking || self.deviceBoardStatus == DeviceBoardStatusOrdering || self.deviceBoardStatus == DeviceBoardStatusPreheating) {
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
    
    self.bakeMode = [self.ovenManager bakeModesForType:self.currentOven.typeIdentifier][sender.tag];
    
    [self.howlong setTitle:[NSString stringWithFormat:@"%@ 分钟", self.bakeMode[@"defaultTime"]] forState:UIControlStateNormal];
    [self.temputure setTitle:[NSString stringWithFormat:@"%@°", self.bakeMode[@"defaultTemperature"]] forState:UIControlStateNormal];
    
    self.temputure.enabled = [self.bakeMode[@"temperatureChangeble"] boolValue];
    
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
            return  self.deviceBoardStatus == DeviceBoardStatusWorking || self.deviceBoardStatus == DeviceBoardStatusOrdering || self.deviceBoardStatus == DeviceBoardStatusPreheating ? PageW*0.33 : 0;
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

#pragma mark - 设备开关机方法

- (void)bootup //开机
{
    
    if (self.myOven == nil && !DebugOvenFlag) {
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
    [NSThread sleepForTimeInterval:0.5];
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



#pragma mark - toolbarAction 工具栏按钮事件

#pragma mark - 点击快速预热

-(void)StartWarmUp:(UIButton*)sender{
    
    if (self.myOven == nil && !DebugOvenFlag) {
        [super showProgressErrorWithLabelText:@"烤箱连接失败" afterDelay:1];
        return;
    }
    
    self.deviceAlertView.selectedTemperature = self.selectedWarmUpTempearature;
    
    // 判断有没有设定温度
    if ([self.temputure.currentTitle isEqualToString:@"--"]) {
        self.myWindow.hidden = NO;
        [UIView animateWithDuration:0.2 animations:^{
            self.deviceAlertView.frame = alertRectShow;
        } completion:^(BOOL finished) {
            
        }];
        
        self.deviceAlertView.alertType = alertWormUp;
    } else {
        [self setWarmUpTemperature:self.temputure.currentTitle];
    }
    
    

}

#pragma mark - 开始运行 & 结束运行

-(void)StartWorking
{
    @try {
        [self.startStatusView resetAnimate];
        [self.tableView reloadData];
        if (self.selectedOrderTime != nil && self.orderButton.selected) {
            // 有设置预约
            
            if (self.myOven == nil && !DebugOvenFlag) {
                [super showProgressErrorWithLabelText:@"烤箱连接失败" afterDelay:1];
                return;
            }
            
            NSString* modeStr = [[self.bakeMode[@"bakeMode"] allValues] firstObject];
            
            NSRange range = [self.howlong.currentTitle rangeOfString:@" 分钟"];
            NSString* timeStr = [self.howlong.currentTitle substringToIndex:range.location];
            NSInteger minutes = [timeStr integerValue];
            NSString* timeValue = [NSString stringWithFormat:@"%02d:%02d", minutes/60, minutes%60];
            
            range = [self.temputure.currentTitle rangeOfString:@"°"];
            NSString* temperatureValue = [self.temputure.currentTitle substringToIndex:range.location];
            
            self.bakeModeLabel.text = [NSString stringWithFormat:@"工作模式：%@", modeStr];
            self.bakeTimeLabel.text = [NSString stringWithFormat:@"时间：%@", self.howlong.currentTitle];
            self.bakeTemperatureLabel.text = [NSString stringWithFormat:@"目标温度：%@", self.temputure.currentTitle];
            
            [self.ovenOperator startOrderWithDate:self.selectedOrderTime
                                         bakeTime:timeValue
                                      temperature:temperatureValue
                                             mode:self.bakeMode
                                    operateResult:^(BOOL success, id obj, NSError *error) {
                                        
                                        if (success) {
                                            self.deviceBoardStatus = DeviceBoardStatusOrdering;
                                        }
                                        
                                    }];
            
            self.ovenOperator.bakeLeftSeconds = [timeStr integerValue] * 60;
            self.startStatusView.leftTime = [NSString stringWithFormat:@"%02d:%02d:%02d",
                                             self.ovenOperator.bakeLeftSeconds/3600,
                                             (self.ovenOperator.bakeLeftSeconds%3600)/60,
                                             (self.ovenOperator.bakeLeftSeconds%3600)%60];
            
            //self.startStatusView.animationDuration = 0;
            //self.startStatusView.lineProgressView.radius = 0;
            //self.startStatusView.lineProgressView.innerRadius = 0;
            
            [self.startStatusView.lineProgressView setCompleted:1.0*80 animated:NO];
            
        } else {
            [self preheatAndBake];
        }
    }
    @catch (NSException *exception) {
        [super showProgressErrorWithLabelText:@"发生错误" afterDelay:1];
    }
    @finally {
        
    }
    
}

- (void)preheatAndBake
{
    if (self.myOven == nil && !DebugOvenFlag) {
        [super showProgressErrorWithLabelText:@"烤箱连接失败" afterDelay:1];
        return;
    }
    
    NSRange range = [self.howlong.currentTitle rangeOfString:@" 分钟"];
    NSString* timeStr = [self.howlong.currentTitle substringToIndex:range.location];
    NSInteger minutes = [timeStr integerValue];
    NSString* timeValue = [NSString stringWithFormat:@"%02d:%02d", minutes/60, minutes%60];
    range = [self.temputure.currentTitle rangeOfString:@"°"];
    NSString* temperatureValue = [self.temputure.currentTitle substringToIndex:range.location];
    NSString* modeStr = [[self.bakeMode[@"bakeMode"] allValues] firstObject];
    
    self.bakeModeLabel.text = [NSString stringWithFormat:@"工作模式：%@", modeStr];
    self.bakeTimeLabel.text = [NSString stringWithFormat:@"时间：%@", self.howlong.currentTitle];
    self.bakeTemperatureLabel.text = [NSString stringWithFormat:@"目标温度：%@", self.temputure.currentTitle];
    
    NSInteger totalSeconds = minutes * 60;
    self.startStatusView.leftTime = [NSString stringWithFormat:@"%02d:%02d:%02d",
                                     totalSeconds/3600,
                                     (totalSeconds%3600)/60,
                                     (totalSeconds%3600)%60];
    [self.startStatusView.lineProgressView setCompleted:1.0*80 animated:NO];
    
    //调用顺序：检测是否已开机 - 设置模式 - 设置温度 - 设置时间 - 启动
    
    [super showProgressHUDWithLabelText:@"请稍候..." dimBackground:NO];
    
    [self.ovenOperator preheatToBakeWithTime:timeValue
                                 temperature:temperatureValue
                                        mode:self.bakeMode
                               operateResult:^(BOOL success, id obj, NSError *error) {
                                   
                                   [super hiddenProgressHUD];
                                   if (success) {
                                       
                                       self.deviceBoardStatus = DeviceBoardStatusPreheating;
                                       
                                       [MobClick event:@"start_bake"];
                                       
                                   } else {
                                       [super showProgressErrorWithLabelText:error.userInfo[NSLocalizedDescriptionKey] afterDelay:1];
                                   }
                                   
                               }];
}

/**
 *  没有预热直接开始烘焙
 */
- (void)startBake
{
    
    if (self.myOven == nil && !DebugOvenFlag) {
        [super showProgressErrorWithLabelText:@"烤箱连接失败" afterDelay:1];
        return;
    }
    
    NSRange range = [self.howlong.currentTitle rangeOfString:@" 分钟"];
    NSString* timeStr = [self.howlong.currentTitle substringToIndex:range.location];
    NSInteger minutes = [timeStr integerValue];
    NSString* timeValue = [NSString stringWithFormat:@"%02d:%02d", minutes/60, minutes%60];
    range = [self.temputure.currentTitle rangeOfString:@"°"];
    NSString* temperatureValue = [self.temputure.currentTitle substringToIndex:range.location];
    NSString* modeStr = [[self.bakeMode[@"bakeMode"] allValues] firstObject];
    
    //调用顺序：检测是否已开机 - 设置模式 - 设置温度 - 设置时间 - 启动
    
    [super showProgressHUDWithLabelText:@"请稍候..." dimBackground:NO];
    
    [[OvenOperator sharedOperator] startBakeWithTime:timeValue
                                         temperature:temperatureValue
                                                mode:self.bakeMode
                                       operateResult:^(BOOL success, id obj, NSError *error) {
                                           [super hiddenProgressHUD];
                                           if (success) {
                                               self.ovenOperator.deviceStatus = CurrentDeviceStatusWorking;
                                               
                                               NSString* notificationBody = [NSString stringWithFormat:@"设备\"%@\"开始烘焙，模式：%@，时间：%ld，温度：%@°",self.currentOven.name, modeStr, minutes,  temperatureValue];
                                               NSDictionary* info = @{@"time" : [MyTool getCurrentTime],
                                                                      @"desc" : notificationBody};
                                               [[DataCenter sharedInstance] addOvenNotification:info];
                                               
                                               [[DataCenter sharedInstance] sendLocalNotification:LocalNotificationTypeBakeComplete fireTime:self.ovenOperator.bakeLeftSeconds alertBody:notificationBody];
                                               
                                               [MobClick event:@"start_bake"];
                                               
                                           } else {
                                               [super showProgressErrorWithLabelText:error.userInfo[NSLocalizedDescriptionKey] afterDelay:1];
                                           }
                                       }];
    
}

- (void)didStartWorking:(NSNotification*)notification
{
    if (![notification.userInfo[@"DeviceMac"] isEqualToString:self.currentOven.mac]) {
        return;
    }
    NSString* modeStr = [[self.bakeMode[@"bakeMode"] allValues] firstObject];
    
    NSRange range;
    NSString* timeStr;
    if ([self.howlong.currentTitle hasSuffix:@" 分钟"]) {
        range = [self.howlong.currentTitle rangeOfString:@" 分钟"];
        timeStr = [self.howlong.currentTitle substringToIndex:range.location];
    }
    
    
    self.bakeModeLabel.text = [NSString stringWithFormat:@"工作模式：%@", modeStr];
    self.bakeTimeLabel.text = [NSString stringWithFormat:@"时间：%@", self.howlong.currentTitle];
    self.bakeTemperatureLabel.text = [NSString stringWithFormat:@"目标温度：%@", self.temputure.currentTitle];
    
    float animateDueation = [timeStr integerValue] * 60;
    [self.startStatusView resetAnimate];
    self.startStatusView.animationDuration = animateDueation;
    [self.startStatusView.lineProgressView setCompleted:1.0*80 animated:YES];
    
    self.deviceBoardStatus = DeviceBoardStatusWorking;
}

#pragma mark - 完成烘焙

- (void)completeBake:(NSNotification*)notification
{
    if (![notification.userInfo[@"DeviceMac"] isEqualToString:self.currentOven.mac]) { //如果不是当前设备则不用作出反应
        return;
    }
    
    self.deviceBoardStatus = DeviceBoardStatusOpened;
    
    NSDictionary* info = @{@"time" : [MyTool getCurrentTime],
                           @"desc" : [NSString stringWithFormat:@"设备\"%@\"烘焙完成",self.currentOven.name]};
    
    [[DataCenter sharedInstance] addOvenNotification:info];
    
    CompleteCookController* completeController = [self.storyboard instantiateViewControllerWithIdentifier:@"Complete cook controller"];
    completeController.completeTye = CompleteTyeCook;
    completeController.delegate = self;
    completeController.myOven = self.myOven;
    [self.navigationController pushViewController:completeController animated:YES];
    
    [self stopWorking];
    
}

#pragma mark - 预热完成

- (void)completeWarmUp
{
    self.deviceBoardStatus = DeviceBoardStatusOpened;
    
    NSDictionary* info = @{@"time" : [MyTool getCurrentTime],
                           @"desc" : [NSString stringWithFormat:@"设备\"%@\"预热完成",self.currentOven.name]};
    
    [[DataCenter sharedInstance] addOvenNotification:info];
    
    CompleteCookController* completeController = [self.storyboard instantiateViewControllerWithIdentifier:@"Complete cook controller"];
    completeController.completeTye = CompleteTyeWarmUp;
    completeController.delegate = self;
    completeController.myOven = self.myOven;
    [self.navigationController pushViewController:completeController animated:YES];
    
    [self stopWorking];
    
}

#pragma mark - 结束运行

- (void)stopWorking
{
    if (self.myOven == nil && !DebugOvenFlag) {
        [super showProgressErrorWithLabelText:@"烤箱连接失败" afterDelay:1];
        return;
    }
   
    self.deviceBoardStatus = DeviceBoardStatusStop;
    
    self.ovenOperator.deviceStatus = CurrentDeviceStatusReady;
    
    uSDKDeviceAttribute* command = [[OvenManager sharedManager] structureWithCommandName:kWaiting commandAttrValue:kWaiting];
    
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
        
//        for (UIButton* button in self.deviceStatusBtns) {
//            button.selected = NO;
//        }
    } else {
        self.deviceBoardStatus = DeviceBoardStatusOpened;
        
        NSDictionary* info = @{@"time" : [MyTool getCurrentTime],
                               @"desc" : [NSString stringWithFormat:@"设备\"%@\"开机了",self.currentOven.name]};
        
        [[DataCenter sharedInstance] addOvenNotification:info];
        
//        for (UIButton* button in self.deviceStatusBtns) {
//            button.selected = YES;
//        }
    }
}

#pragma mark - 按钮响应事件

- (IBAction)TurnBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)TurnEdit:(id)sender
{
    DeviceEditController *edit = [self.storyboard instantiateViewControllerWithIdentifier:@"DeviceEditController"];
    
    edit.currentOven = self.currentOven;
    edit.myOven = self.myOven;
    
    [self.navigationController pushViewController:edit animated:YES];
}

- (IBAction)TurnMessage:(id)sender
{
    DeviceMessageController *message = [self.storyboard instantiateViewControllerWithIdentifier:@"DeviceMessageController"];
    [self.navigationController pushViewController:message animated:YES];
}

/**
 *  同步时钟
 *
 *  @param sender 同步时钟按钮
 */
- (IBAction)syncronizeTime:(UIButton *)sender
{
    
    if (self.myOven == nil && !DebugOvenFlag) {
        [super showProgressErrorWithLabelText:@"烤箱连接失败" afterDelay:1];
        return;
    }
    
    if (self.deviceBoardStatus == DeviceBoardStatusWorking || self.deviceBoardStatus == DeviceBoardStatusOrdering || self.deviceBoardStatus == DeviceBoardStatusPreheating) {
        [super showProgressCompleteWithLabelText:@"运行状态不可同步时间" afterDelay:1];
        return;
    }
    
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

#pragma mark - 辅助功能按钮事件

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

#pragma mark - 开机关机事件

- (IBAction)onoff:(UIButton*)sender {
    if (self.myOven == nil && !DebugOvenFlag) {
        [super showProgressErrorWithLabelText:@"烤箱连接失败" afterDelay:1];
        return;
    }
    
    for (UIButton *btn in self.deviceStatusBtns) {
        btn.selected = !btn.selected;
    }
    
    UIButton *btn = [self.deviceStatusBtns firstObject];
    self.deviceBoardStatus = btn.selected == NO ? DeviceBoardStatusClosed : DeviceBoardStatusOpened;
    
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

#pragma mark - 设置控制面板状态

-(void)setDeviceBoardStatus:(DeviceBoardStatus)deviceBoardStatus{
    
    _deviceBoardStatus = deviceBoardStatus;
    switch (_deviceBoardStatus) {
        case DeviceBoardStatusClosed:
            
            self.ovenOperator.deviceStatus = CurrentDeviceStatusClosed;
            
            self.toolbarItems = @[fixbtn,ksyrTab,fixbtn,startTab,fixbtn];
            
            [self.howlong setTitle:@"--" forState:UIControlStateNormal];
            [self.temputure setTitle:@"--" forState:UIControlStateNormal];
            
            for (UIButton* btn in self.deviceStatusBtns) {
                btn.selected = NO;
            }
            
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
            
            [self.deviceNameButton setTitle:[NSString stringWithFormat:@"%@已连接，待机中", self.currentOven.name] forState:UIControlStateNormal];
            [self.deviceNameButton setTitle:[NSString stringWithFormat:@"%@已连接，待机中", self.currentOven.name] forState:UIControlStateSelected];
            
            [self.tableView reloadData];
            
            
            break;
            
        case DeviceBoardStatusOpened:
            
            //self.ovenOperator.deviceStatus = CurrentDeviceStatusOpened;
            
            self.toolbarItems = @[fixbtn,ksyrTab,fixbtn,startTab,fixbtn];
            
            [self.howlong setTitle:@"--" forState:UIControlStateNormal];
            [self.temputure setTitle:@"--" forState:UIControlStateNormal];
            
            for (UIButton* button in self.deviceStatusBtns) {
                button.selected = YES;
            }
            
            for (UIButton* btn in self.allbtns) {
                btn.enabled = YES;
                btn.selected = NO;
            }
            
            for (UIButton *btn in self.controlBtns) {
                if (btn.tag == 3 || btn.tag == 4) { //照明和锁定可点击
                    btn.enabled = YES;
                }
                btn.selected = NO;
            }
            
            for (UIButton *btn in self.workModelBtns) {
                btn.enabled =YES;
                btn.selected = NO;
            }
            
            for (UIBarButtonItem *btn in self.toolbarItems) {
                btn.enabled = NO;
            }
            
            //初始状态下闹钟按钮、快速预热可点击
            self.clockIcon.enabled = YES;
            
            self.ksyrTab.enabled = YES;
            
            self.actionCell.hidden = YES;
            
            [self.deviceNameButton setTitle:[NSString stringWithFormat:@"%@已连接，待机中", self.currentOven.name] forState:UIControlStateSelected];
            
            [self.tableView reloadData];
            
            break;

        case DeviceBoardStatusWorking:
            self.toolbarItems = @[ fixbtn,tzyxTab,fixbtn];
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
            
            [self.deviceNameButton setTitle:[NSString stringWithFormat:@"%@已连接，运行中", self.currentOven.name] forState:UIControlStateSelected];
            [self.deviceNameButton setTitle:[NSString stringWithFormat:@"%@已连接，关机中", self.currentOven.name] forState:UIControlStateNormal];
            
            [self.tableView reloadData];
            
            break;
            
        case DeviceBoardStatusOrdering:
            
            self.toolbarItems = @[ fixbtn,tzyxTab,fixbtn];
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
            
            [self.deviceNameButton setTitle:[NSString stringWithFormat:@"%@预约中...", self.currentOven.name] forState:UIControlStateSelected];
            [self.deviceNameButton setTitle:[NSString stringWithFormat:@"%@预约中...", self.currentOven.name] forState:UIControlStateNormal];
            
            [self.tableView reloadData];
            
            break;
        
        case DeviceBoardStatusPreheating:
            
            self.toolbarItems = @[ fixbtn,tzyxTab,fixbtn];
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
            
            [self.deviceNameButton setTitle:[NSString stringWithFormat:@"%@预热中...", self.currentOven.name] forState:UIControlStateSelected];
            [self.deviceNameButton setTitle:[NSString stringWithFormat:@"%@预热中...", self.currentOven.name] forState:UIControlStateNormal];
            
            [self.tableView reloadData];
            
            break;
            
        case DeviceBoardStatusSelectMode:
            
            self.toolbarItems = @[fixbtn,ksyrTab,fixbtn,startTab,fixbtn];
            
            for (UIButton* btn in self.allbtns) {
                btn.enabled = YES;
            }
            
            for (UIButton *btn in self.controlBtns) {
                if (btn.tag == 3 || btn.tag == 4) { //照明和锁定可点击
                    btn.enabled = YES;
                }
                btn.selected = NO;
            }
            
            for (UIButton *btn in self.workModelBtns) {
                btn.enabled =YES;
            }
            
            for (UIBarButtonItem *btn in self.toolbarItems) {
                btn.enabled = YES;
            }
            
            self.actionCell.hidden = YES;
            
            [self.startStatusView resetAnimate];
            
            [self.deviceNameButton setTitle:[NSString stringWithFormat:@"%@已连接，待机中", self.currentOven.name] forState:UIControlStateSelected];
            
            [self.tableView reloadData];
            
            
            
            break;
            
        case DeviceBoardStatusStop:
        {
            self.toolbarItems = @[fixbtn,ksyrTab,fixbtn,startTab,fixbtn];
            
            NSInteger leftValue = self.ovenOperator.bakeLeftSeconds / 60;
            
            NSString* leftTime = [NSString stringWithFormat:@"%d", leftValue];
            
            leftTime = [leftTime stringByAppendingString:@" 分钟"];
            
            self.selectedNeedleTemperature = nil;
            
            [self.howlong setTitle:leftTime forState:UIControlStateNormal];
            //[self.temputure setTitle:@"--" forState:UIControlStateNormal];
            
            for (UIButton* button in self.deviceStatusBtns) {
                button.selected = YES;
            }
            
            for (UIButton* btn in self.allbtns) {
                if (btn.tag != 3) {  // 闹钟不可消失
                    btn.selected = NO;
                }
                btn.enabled = YES;
                
            }
            
            for (UIButton *btn in self.controlBtns) {
                if (btn.tag == 3 || btn.tag == 4) { //照明和锁定可点击
                    btn.enabled = YES;
                }
                btn.selected = NO;
            }
            
            // 停止运行状态，保留烘焙模式
//            for (UIButton *btn in self.workModelBtns) {
//                btn.enabled =YES;
//                btn.selected = NO;
//            }
            
            for (UIBarButtonItem *btn in self.toolbarItems) {
                btn.enabled = YES;
            }
            
            //初始状态下闹钟按钮、快速预热可点击
            self.clockIcon.enabled = YES;
            
            self.ksyrTab.enabled = YES;
            
            self.actionCell.hidden = YES;
            
            
            [self.deviceNameButton setTitle:[NSString stringWithFormat:@"%@已连接，待机中", self.currentOven.name] forState:UIControlStateSelected];
            
            [self.tableView reloadData];
            
            break;
        }
        default:
            break;
    }
    
}

#pragma mark - 设置闹钟

// 闹钟
- (void)setClockTime:(NSString*)clockString
{
    
    if (self.deviceBoardStatus == DeviceBoardStatusWorking || self.deviceBoardStatus == DeviceBoardStatusOrdering || self.deviceBoardStatus == DeviceBoardStatusPreheating) {
        [super showProgressErrorWithLabelText:@"运行状态下辅助功能不可操作" afterDelay:1];
        return;
    }
    
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
    
    self.clockStopFlag = NO;
    
    NSString* notificationBody = [NSString stringWithFormat:@"设定闹钟：%@", clockString];
    NSDictionary* info = @{@"time" : [MyTool getCurrentTime],
                           @"desc" : notificationBody};
    
    [[DataCenter sharedInstance] addOvenNotification:info];
    
    [[DataCenter sharedInstance] sendLocalNotification:LocalNotificationTypeClockTimeUp fireTime:seconds alertBody:@"您设定的闹钟时间到了。"];
    
}

#pragma mark - 设置温度探针

// 温度探针
- (void)setNeedleTemperature:(NSString*)temperatureString sender:(UIButton*)sender
{
    
    if (self.deviceBoardStatus == DeviceBoardStatusWorking || self.deviceBoardStatus == DeviceBoardStatusOrdering || self.deviceBoardStatus == DeviceBoardStatusPreheating) {
        if (sender.selected && self.selectedNeedleTemperature == nil) {
            // 没有设置温度探针确保温度探针按钮没被选中
            sender.selected = NO;
        }
        [super showProgressErrorWithLabelText:@"运行状态下辅助功能不可操作" afterDelay:1];
        return;
    }
    
    self.selectedNeedleTemperature = temperatureString;
    
    NSRange range = [temperatureString rangeOfString:@"°"];
    NSString* temperatureValue = [temperatureString substringToIndex:range.location];
    uSDKDeviceAttribute* command = [[OvenManager sharedManager] structureWithCommandName:kSetNeedleTemerature
                                                                        commandAttrValue:temperatureValue];
    [[OvenManager sharedManager] executeCommands:[@[command] mutableCopy]
                                        toDevice:self.myOven
                                    andCommandSN:0
                             andGroupCommandName:@""
                                        callback:^(BOOL success, uSDKErrorConst errorCode) {
                                            
                                        }];
    
}

#pragma mark - 快速预热

// 快速预热 选择温度后：80°
- (void)setWarmUpTemperature:(NSString*)temperatureString
{
    self.selectedWarmUpTempearature = temperatureString;
    //判断有没有设定时间
    NSString* timeStr;
    if ([self.howlong.currentTitle isEqualToString:@"--"]) {
        timeStr = @"5 分钟";
        [self.howlong setTitle:@"5 分钟" forState:UIControlStateNormal];
    } else {
        timeStr = self.howlong.currentTitle;
    }
    
    [self.temputure setTitle:temperatureString forState:UIControlStateNormal];
    
    self.bakeModeLabel.text = [NSString stringWithFormat:@"工作模式：%@", @"快速预热"];
    self.bakeTimeLabel.text = [NSString stringWithFormat:@"时间：%@", timeStr];
    self.bakeTemperatureLabel.text = [NSString stringWithFormat:@"目标温度：%@", temperatureString];
    
    NSRange range = [temperatureString rangeOfString:@"°"];
    NSString* temperatureValue = [temperatureString substringToIndex:range.location];
    
    range = [timeStr rangeOfString:@" 分钟"];
    NSString* timeValue = [timeStr substringToIndex:range.location];
    NSInteger minutes = [timeStr integerValue];
    timeValue = [NSString stringWithFormat:@"%02d:%02d", minutes/60, minutes%60];
    
    
    self.bakeMode = @{@"bakeMode"                : @{@"30v0M1" :@"快速预热"},
                      @"defaultTemperature"      : @100,
                      @"defaultTime"             : @120,
                      @"defaultSelectTime"       : @30,
                      @"temperatureChangeble"    : @YES};
    
    NSString* modeStr = [[self.bakeMode[@"bakeMode"] allValues] firstObject];
    
    //调用顺序：检测是否已开机 - 设置模式 - 设置温度 - 设置时间 - 启动
    
    [super showProgressHUDWithLabelText:@"请稍候..." dimBackground:NO];
    
    [[OvenOperator sharedOperator] startBakeWithTime:timeValue
                                         temperature:temperatureValue
                                                mode:self.bakeMode
                                       operateResult:^(BOOL success, id obj, NSError *error) {
                                           [super hiddenProgressHUD];
                                           if (success) {
                                               
                                               self.ovenOperator.deviceStatus = CurrentDeviceStatusWorking;
                                               
                                               NSString* notificationBody = [NSString stringWithFormat:@"设备\"%@\"开始烘焙，模式：%@，时间：%ld，温度：%@°",self.currentOven.name, modeStr, minutes,  temperatureValue];
                                               NSDictionary* info = @{@"time" : [MyTool getCurrentTime],
                                                                      @"desc" : notificationBody};
                                               [[DataCenter sharedInstance] addOvenNotification:info];
                                               
                                               [[DataCenter sharedInstance] sendLocalNotification:LocalNotificationTypeBakeComplete fireTime:self.ovenOperator.bakeLeftSeconds alertBody:notificationBody];
                                               
                                               [MobClick event:@"quick_warmup"];
                                               
                                           } else {
                                               [super showProgressErrorWithLabelText:error.userInfo[NSLocalizedDescriptionKey] afterDelay:1];
                                           }
                                       }];
    
}


#pragma mark- 各种设置窗口取消和确认

-(void)cancel
{
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

        case alertNeedle:   //温度探针
            self.neddleString = string;
            [self setNeedleTemperature:string sender:btn];
            break;
        case alertWormUp:
            self.warmUpString = string;
            //ksyr.selected = !ksyr.selected;
            [self setWarmUpTemperature:string];
            
            break;
            
        default:
            break;
    }
    
    self.myWindow.hidden = YES;
    self.deviceAlertView.frame = alertRectHidden;
}

#pragma mark - 弹出各种设置窗口

- (IBAction)alertView:(UIButton *)sender {
    
    NSLog(@"%d",sender.tag);
    
    if (sender.tag == 5) {   // 预约按钮按下
        
        if ([self.howlong.currentTitle isEqualToString:@"--"]) {
            [super showProgressErrorWithLabelText:@"请先设定预约的烘焙时长" afterDelay:2];
            return;
        }
        
        
        NSRange range = [self.howlong.currentTitle rangeOfString:@" 分钟"];
        NSString* timeStr = [self.howlong.currentTitle substringToIndex:range.location];

        self.orderAlert.minimumInteval = [timeStr integerValue] * 60.0;
        
        [UIView animateWithDuration:0.2 animations:^{
            self.orderAlert.frame = alertRectShow;
            
            self.myWindow.hidden = NO;
            [self.orderAlert setDefaultDate];
            
            if (self.deviceBoardStatus == DeviceBoardStatusOrdering || self.deviceBoardStatus == DeviceBoardStatusPreheating || self.deviceBoardStatus == DeviceBoardStatusWorking) {
                self.orderAlert.selectedDate = self.selectedOrderTime;
            }

        } completion:^(BOOL finished) {
            
        }];

    } else if (sender.selected == NO ||sender.tag==1 || sender.tag==2 || sender.tag == 4) {
        
        //self.deviceAlertView.defaultSelectTime = [self.bakeMode[@"defaultSelectTime"] integerValue];
        self.deviceAlertView.isChunzheng = [[[self.bakeMode[@"bakeMode"] allValues] firstObject] isEqualToString:@"纯蒸"];   //@"bakeMode" : @{@"30v0Mj" :@"纯蒸"}
        self.deviceAlertView.alertType = sender.tag;
        self.deviceAlertView.btn = sender;
        
        switch (sender.tag) {
                
            case 1: //温度
                self.deviceAlertView.string = @"180°";
                if (self.deviceBoardStatus == DeviceBoardStatusWorking || self.deviceBoardStatus == DeviceBoardStatusOrdering || self.deviceBoardStatus == DeviceBoardStatusPreheating) {
                    [super showProgressErrorWithLabelText:@"停止运行后，参数可调" afterDelay:1];
                    return;
                }
                
                self.deviceAlertView.selectedTemperature = self.temputure.currentTitle;
                break;
                
            case 2: //时间
                self.deviceAlertView.string = @"30 分钟";
                if (self.deviceBoardStatus == DeviceBoardStatusWorking || self.deviceBoardStatus == DeviceBoardStatusOrdering || self.deviceBoardStatus == DeviceBoardStatusPreheating) {
                    [super showProgressErrorWithLabelText:@"停止运行后，参数可调" afterDelay:1];
                    return;
                } else if (self.deviceBoardStatus == DeviceBoardStatusStop) {
                    NSRange range = [self.howlong.currentTitle rangeOfString:@" 分钟"];
                    NSString* timeStr = [self.howlong.currentTitle substringToIndex:range.location];
                    self.deviceAlertView.defaultSelectTime = [timeStr integerValue];
                } else {
                    self.deviceAlertView.defaultSelectTime = [self.bakeMode[@"defaultSelectTime"] integerValue];
                }
                
                
                
                
                break;
            
            case 3: // 闹钟
                
                if (self.deviceBoardStatus == DeviceBoardStatusWorking || self.deviceBoardStatus == DeviceBoardStatusOrdering || self.deviceBoardStatus == DeviceBoardStatusPreheating) {
                    [super showProgressErrorWithLabelText:@"运行状态下辅助功能不可操作" afterDelay:1];
                    return;
                }
                
                break;
            
            case 4: //温度探针
                
                self.deviceAlertView.selectedTemperature = self.selectedNeedleTemperature;
                
                
                break;
                
            default:
                break;
        }
        
        self.myWindow.hidden = NO;
        
        
        [UIView animateWithDuration:0.2 animations:^{
            self.deviceAlertView.frame = alertRectShow;
        } completion:^(BOOL finished) {
            
        }];
        
    } else {
        sender.selected = NO;
    }

}

#pragma mark - 选择了预约时间

- (void)SettingOrder:(NSDate *)date sender:(UIButton *)sender
{
    [self OrderAlertViewHidden];
    
    if (self.deviceBoardStatus == DeviceBoardStatusWorking || self.deviceBoardStatus == DeviceBoardStatusOrdering || self.deviceBoardStatus == DeviceBoardStatusPreheating) {
        [super showProgressErrorWithLabelText:@"运行状态下辅助功能不可操作" afterDelay:1];
        return;
    }
    
    self.selectedOrderTime = date;
    
    self.orderButton.selected = YES;
    
//    // 计算开始烘焙时间，已确保在预约时间之前完成烘焙：开始烘焙时间 = 预约完成时间 - 烘焙所需时间间隔
//    
//    // 1. 得到预约完成时间距离现在的秒数
//    NSTimeInterval inteval = [date timeIntervalSinceNow];
//    // 2. 得到开始烘焙的时间距离现在的秒数
//    inteval = inteval - self.orderAlert.minimumInteval;
//    
//    // 3. inteval时间后发送预约指令
    
    
//    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
//    formatter.dateFormat = @"hh:mm";
//    NSString* time = [formatter stringFromDate:date];
//    
//    uSDKDeviceAttribute* command = [[OvenManager sharedManager] structureWithCommandName:kOrderTime
//                                                                        commandAttrValue:time];
//    [[OvenManager sharedManager] executeCommands:[@[command] mutableCopy]
//                                        toDevice:self.myOven
//                                    andCommandSN:0
//                             andGroupCommandName:@""
//                                        callback:^(BOOL success, uSDKErrorConst errorCode) {
//                                            self.orderButton.selected = YES;
//                                        }];
    
}

-(void)OrderAlertViewHidden
{
    self.orderAlert.frame = alertRectHidden;
    self.myWindow.hidden = YES;
}

#pragma mark - 更新显示烘焙温度和时间

-(void)setTempString:(NSString *)tempString
{
    _tempString = tempString;
    [self.temputure setTitle:_tempString forState:UIControlStateNormal];
}

-(void)setTimeString:(NSString *)timeString
{
    _timeString = timeString;
    [self.howlong setTitle:_timeString forState:UIControlStateNormal];
}

#pragma kkprogressTimerDelegate 闹钟倒计时View委托

- (void)didUpdateProgressTimer:(KKProgressTimer *)progressTimer percentage:(CGFloat)percentage
{
    
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


#pragma  mark- TimeAlertDelegate 闹钟倒计时窗口委托

-(void)HiddenClockAlert
{
    self.myWindow.hidden = YES;
    self.clockAlert.frame = alertRectHidden;
}

- (void)userStopClock
{
    [self StopClock];
    [[DataCenter sharedInstance] sendLocalNotification:LocalNotificationTypeClockTimeUp fireTime:1 alertBody:@"闹钟已取消"];
    self.clockStopFlag = YES;
}

-(void)StopClock
{
    self.myWindow.hidden = YES;
    self.clockAlert.frame = alertRectHidden;
    self.clockIcon.selected = NO;
    self.clockAlert.start = NO;
    
}

-(void)timeOutAlertHidden
{
    self.myWindow.hidden = YES;
    self.timeOutAlert.frame = alertRectHidden;
    self.clockIcon.selected = NO;
}

-(void)TimeOutAlertShow
{
    if (self.clockStopFlag) {
        //self.clockStopFlag = NO;
        return;
    }
    self.clockAlert.frame = alertRectHidden;
    self.myWindow.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        //        self.deviceAlertView.frame = alertRectShow;
        //        self.clockAlert.frame = CGRectMake(alertRectShow.origin.x, alertRectShow.origin.y, alertRectShow.size.width, 200);
        self.timeOutAlert.frame = CGRectMake(alertRectShow.origin.x,PageH/2-40, alertRectShow.size.width, 81);
    } completion:^(BOOL finished) {
        
        NSString* notificationBody = [NSString stringWithFormat:@"设定的闹钟时间到"];
        NSDictionary* info = @{@"time" : [MyTool getCurrentTime],
                               @"desc" : notificationBody};
        
        [[DataCenter sharedInstance] addOvenNotification:info];
        
    }];

}

@end
