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
@property (strong, nonatomic) IBOutlet DeviceWorkView *startStatusView;
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

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *deviceStatusBtns;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *allbtns;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *controlBtns;
@property (strong, nonatomic) IBOutlet UITableViewCell *actionCell;
@property (strong, nonatomic) UIButton *tempBtn;//记录模版上一个点击按钮
@property (strong, nonatomic) IBOutlet UIButton *temputure;
@property (strong, nonatomic) IBOutlet UIButton *howlong;
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

    NSArray *cxz = @[@"cthp-cxz",@"dlfp-cxz",@"rfpk-cxz",@"pk-cxz",@"sk-cxz"];
    NSArray *xz = @[@"cthp-xz",@"dlfp-xz",@"rfpk-xz",@"pk-xz",@"sk-xz"];
    NSArray *wxz = @[@"cthp-wxz",@"dlfp-wxz",@"rfpk-wxz",@"pk-wxz",@"sk-wxz"];
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
    
    
#warning 调试PageView
    self.pageView.numberOfPages = 4;
    self.deviceScrollView.contentSize = CGSizeMake(_deviceScrollView.frame.size.width * 4, _deviceScrollView.frame.size.height);
    self.deviceScrollView.pagingEnabled = YES;
    self.deviceScrollView.delegate = self;
}
-(void)SetUPAlertView{
    self.myWindow = [UIWindow new];
    self.myWindow.frame = CGRectMake(0, 0, PageW, PageH);
    self.myWindow.backgroundColor = [UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:0.3];
    self.myWindow.windowLevel = UIWindowLevelAlert;
    [self.myWindow makeKeyAndVisible];
    self.myWindow.userInteractionEnabled = YES;
    self.myWindow.hidden = YES;

    self.deviceAlertView = [[DeviceAlertView alloc]initWithFrame:CGRectMake(0, 0, PageW-40, (PageW-40)*1.167)];
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
}
#pragma mark - 

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

- (void)loadMyOvenInstance
{
    [[OvenManager sharedManager] getDevicesCompletion:^(BOOL success, id obj, NSError *error) {
        if (success) {
            self.myOven = [obj firstObject];
            if (![self.myOven.mac isEqualToString:self.currentOven.mac]) {
                NSLog(@"搜索到的设备和本地设备不一致！！！");
                
            }
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


#pragma mark - tableviewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    if (indexPath.row == 0) {
//        self.deviceAlertView.alertType = alertTime;
//
//    }else if (indexPath.row==3){
//        self.deviceAlertView.alertType = alertNeedle;
//
//    }
//
//    self.myWindow.hidden = NO;
    
}

#pragma mark - 设备指令

- (void)bootup //开机
{
    [[OvenManager sharedManager] bootupToDevice:self.myOven];
}

- (void)shutdown
{
    [[OvenManager sharedManager] shutdownToDevice:self.myOven];
}



#pragma mark - toolbarAction
-(void)StartWarmUp:(UIButton*)sender{
    self.myWindow.hidden = NO;
    if (sender.selected==NO) {
        self.deviceAlertView.alertType = alertWormUp;
    }
//    self.toolbarItems = @[ fixbtn,tzyxTab,fixbtn];
    

}
-(void)StartWorking{
    
    self.deviceBoardStatus = DeviceBoardStatusStart;
    
    //点击运行后显示
    self.timeable =  [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    self.time = 30;
    float animateDueation = 30;
    self.startStatusView.animationDuration = animateDueation;
    [self.startStatusView.lineProgressView setCompleted:1.0*80 animated:YES];
    
    self.toolbarItems = @[ fixbtn,tzyxTab,fixbtn];

}
-(void)StopWorking{
    self.toolbarItems = @[ fixbtn,ksyrTab,fixbtn,startTab,fixbtn];
    [self.timeable invalidate];
    self.timeable = nil;
    self.deviceBoardStatus = DeviceBoardStatusOpen;

}
#pragma mark-

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


#pragma mark - 开机关机
- (IBAction)onoff:(id)sender {
    for (UIButton *btn in self.deviceStatusBtns) {
        btn.selected = btn.selected ==YES?NO:YES;
    }
    UIButton *btn = [self.deviceStatusBtns firstObject];
    self.deviceBoardStatus = btn.selected ==NO?DeviceBoardStatusClose:DeviceBoardStatusOpen;
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

#pragma mark- 提示框显示deviceAlertView
-(void)cancel{
    self.myWindow.hidden = YES;
}

-(void)confirm:(NSString *)string andAlertTye:(NSInteger)type andbtn:(UIButton *)btn{
    self.alertType = type;
    btn.selected = YES;
    switch (self.alertType) {
        case alertTime:
            self.timeString = string;
            break;
        case alertTempture:
            self.tempString = string;
            break;
        case alertClock:
            self.clockString = string;
            break;
        case alertOrder:
            self.orderString = string;
            break;
        case alertNeedle:
            self.neddleString = string;
            break;
        case alertWormUp:
            self.warmUpString = string;
            ksyr.selected = ksyr.selected==YES?NO:YES;
            break;
            
        default:
            break;
    }
    self.myWindow.hidden = YES;

}
- (IBAction)alertView:(UIButton *)sender {
    if (sender.selected ==NO ||sender.tag==1||sender.tag==2) {
        self.deviceAlertView.alertType = sender.tag;
        self.deviceAlertView.btn = sender;
        self.myWindow.hidden = NO;
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
