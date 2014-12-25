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

#import "MyPageView.h"

@interface DeviceBoardViewController () <MyPageViewDelegate, UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet DeviceWorkView *startStatusView;
@property (strong, nonatomic) NSTimer *timeable;
@property int time;
@property (strong, nonatomic) IBOutlet UIScrollView *deviceScrollView;

@property (weak, nonatomic) IBOutlet MyPageView *pageView;

@property (strong, nonatomic) NSMutableArray *workModelBtns;
@property (strong, nonatomic) UIBarButtonItem *startTab;
@property (strong, nonatomic) UIBarButtonItem *ksyrTab;
@property (strong, nonatomic) UIBarButtonItem *tzyxTab;
@property (strong, nonatomic) UIBarButtonItem *fixbtn;
@property (strong, nonatomic) UIWindow *myWindow;
@property (strong, nonatomic) DeviceAlertView *deviceAlertView;

@end

@implementation DeviceBoardViewController

@synthesize startTab;
@synthesize ksyrTab;
@synthesize tzyxTab;
@synthesize fixbtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SetUpSubviews];
    [self SetUPAlertView];
    [self setupToolbarItems];
    
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
    UIButton * ksyr = [[UIButton alloc] init];
    [ksyr setImage:IMAGENAMED(@"ksyr-xz") forState:UIControlStateNormal];
    [ksyr setImage:IMAGENAMED(@"ksyr-wxz") forState:UIControlStateDisabled];
    [ksyr setImage:IMAGENAMED(@"ksyr-cxz") forState:UIControlStateSelected];
    [ksyr addTarget:self action:@selector(StartWarmUp) forControlEvents:UIControlEventTouchUpInside];
    float width = (PageW-50)/2;
    ksyr.frame = CGRectMake(0, 0, width, width *0.272);
    
    
    UIButton * start = [UIButton buttonWithType:UIButtonTypeCustom];
    [start setImage:IMAGENAMED(@"kaishi-xz") forState:UIControlStateNormal];
    [start setImage:IMAGENAMED(@"kaishi") forState:UIControlStateDisabled];
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
    
//    for (UIButton *btn in self.workModelBtns) {
//        [btn setEnabled:NO];
//    }
    
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
    [self.myWindow addSubview:self.deviceAlertView];

}



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
//    self.deviceAlertView.alertDescription = @"我去你妈呀";
//    self.deviceAlertView.alertTitle = @"去你大爷";
    
    if (indexPath.row == 0) {
        self.deviceAlertView.alertType = alertTime;

    }else if (indexPath.row==3){
        self.deviceAlertView.alertType = alertNeedle;

    }

    self.myWindow.hidden = NO;
    
}
#pragma mark -



#pragma mark - toolbarAction
-(void)StartWarmUp{
    self.toolbarItems = @[ fixbtn,tzyxTab,fixbtn];

}
-(void)StartWorking{
    self.toolbarItems = @[ fixbtn,tzyxTab,fixbtn];

}
-(void)StopWorking{
    self.toolbarItems = @[ fixbtn,ksyrTab,fixbtn,startTab,fixbtn];

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


@end
