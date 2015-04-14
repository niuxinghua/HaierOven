//
//  DeviceViewController.m
//  HaierOven
//
//  Created by dongl on 14/12/16.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "DeviceViewController.h"
#import "MyDeviceView.h"
#import "MyDeviceAddView.h"
#import "AddDeviceStepOneController.h"
#import "DeviceBoardViewController.h"

#define TopPadding   10
#define WidthPadding   10
@interface DeviceViewController () <MyDeviceAddViewDelegate, MyDeviceViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollView;

@property (strong, nonatomic) NSMutableArray* devices;

@property (strong, nonatomic) NSTimer* timer;

@end

@implementation DeviceViewController


#pragma mark - 新消息标记及移除标记

- (void)updateMarkStatus:(NSNotification*)notification
{
    NSDictionary* countDict = notification.userInfo;
    NSInteger count = [countDict[@"count"] integerValue];
    if (count > 0) {
        [self markNewMessage];
    } else {
        [self deleteMarkLabel];
    }
    
}

- (void)markNewMessage
{
    //拿到左侧栏按钮
    UIBarButtonItem* liebiao = self.navigationItem.leftBarButtonItem;
    UIButton* liebiaoBtn = (UIButton*)liebiao.customView;
    liebiaoBtn.clipsToBounds = NO;
    
    //小圆点
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(-8, -5, 10, 10)];
    label.layer.masksToBounds = YES;
    label.layer.cornerRadius = label.height / 2;
    label.backgroundColor = [UIColor redColor];
    
    //添加到button
    [liebiaoBtn addSubview:label];
    self.navigationItem.leftBarButtonItem = liebiao;
    
}

- (void)deleteMarkLabel
{
    //拿到左侧栏按钮
    UIBarButtonItem* liebiao = self.navigationItem.leftBarButtonItem;
    UIButton* liebiaoBtn = (UIButton*)liebiao.customView;
    liebiaoBtn.clipsToBounds = NO;
    
    //移除小圆点Label
    for (UIView* view in liebiaoBtn.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            [view removeFromSuperview];
        }
    }
    
    //重新赋值leftBarButtonItem
    self.navigationItem.leftBarButtonItem = liebiao;
}

#pragma mark - 加载系列

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.navigationController.viewControllers.count > 1) {
        UIButton* leftButton = [[UIButton alloc] init];
        
        [leftButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [super setLeftBarButtonItemWithImageName:@"back.png" andTitle:nil andCustomView:leftButton];
        
    } else {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMarkStatus:) name:MessageCountUpdateNotification object:nil];
        if ([DataCenter sharedInstance].messagesCount > 0 && IsLogin) {
            [self markNewMessage];
        } else {
            [self deleteMarkLabel];
        }
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadLocalOvens) name:MyOvensInfoHadChangedNotificatin object:nil];
    
    self.myDevices = [DataCenter sharedInstance].myOvens;
    
    [self updateOvenLinkStatus];
    
    UIButton* addButton = [[UIButton alloc] init];
    [addButton addTarget:self action:@selector(AddDevice) forControlEvents:UIControlEventTouchUpInside];
    [super setRightBarButtonItemWithImageName:@"xinzeng.png" andTitle:nil andCustomView:addButton];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //[self removeObserver:self forKeyPath:@"self.ovenManager.currentStatus.isReady" context:NULL];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.addDeviceFlag) { //侧边栏跳转过来直接添加烤箱
        self.addDeviceFlag = NO;
        [self AddDevice];
    }
    
    
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(updateOvenLinkStatus) userInfo:nil repeats:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 离开页面取消订阅这些设备
    NSMutableArray* macs = [NSMutableArray array];
    for (LocalOven* localOven in self.myDevices) {
        [macs addObject:localOven.mac];
    }
    [[OvenManager sharedManager] unSubscribeAllNotifications:macs];
    
    [self.timer invalidate];
    self.timer = nil;
}

- (void)updateOvenLinkStatus
{
    // 订阅这些设备以获取连线状态
    NSMutableArray* macs = [NSMutableArray array];
    for (LocalOven* localOven in self.myDevices) {
        [macs addObject:localOven.mac];
    }
    [[OvenManager sharedManager] subscribeAllNotificationsWithDevice:macs];
    
    if (self.myDevices.count == 0) {
        [self SetUpSubviews];
    } else {
        for (LocalOven* localOven in self.myDevices) {
            [[OvenManager sharedManager] getOvenStatus:localOven.mac status:^(BOOL success, id obj, NSError *error) {
                if (success) {
                    OvenStatus* status = obj;
                    localOven.isReady = status.isReady;
                }
                [self SetUpSubviews];
            }];
        }
    }
}

- (void)loadLocalOvens
{
    self.myDevices = [DataCenter sharedInstance].myOvens;
    [self SetUpSubviews];
}

- (void)loadOvenDevices
{
    // 监控在线状态
    //[self addObserver:self forKeyPath:@"self.ovenManager.currentStatus.isReady" options:NSKeyValueObservingOptionNew context:NULL];
    [[OvenManager sharedManager] getDevicesCompletion:^(BOOL success, id obj, NSError *error) {
        if (success) {
            self.devices = obj;
        }
        [self loadLocalOvens];
    }];
}



#pragma mark - 监听烤箱状态并作出反应

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
//    NSLog(@"******设备状态变化啦**********");
//    NSLog(@"在线：%d, 开机：%d, 工作：%d, 温度：%d, 时间：%@", self.ovenManager.currentStatus.isReady, _ovenManager.currentStatus.opened, self.ovenManager.currentStatus.isWorking, _ovenManager.currentStatus.temperature, _ovenManager.currentStatus.bakeTime);
//    
//    if ([keyPath isEqualToString:@"self.ovenManager.currentStatus.isReady"]) {
//        if (_ovenManager.currentStatus.isReady) {
//            [self.deviceNameButton setTitle:[NSString stringWithFormat:@"%@已连接，待机中", self.currentOven.name] forState:UIControlStateNormal];
//        } else {
//            [self.deviceNameButton setTitle:[NSString stringWithFormat:@"%@已连接", self.currentOven.name] forState:UIControlStateNormal];
//        }
//        
//    } else if ([keyPath isEqualToString:@"self.ovenManager.currentStatus.temperature"]) {
//        // 温度变化，如果设有温度探针，则当烤箱到达指定温度后弹窗通知
//        
//        
//    } else if ([keyPath isEqualToString:@"self.ovenManager.currentStatus.opened"]) {
//        
//        if (self.deviceBoardStatus == DeviceBoardStatusOpened && !_ovenManager.currentStatus.opened) {
//            [self bootup];
//        }
//        
//        
//    } else if ([keyPath isEqualToString:@"self.clockIcon.selected"]) {
//        self.cookTimeView.hidden = !self.clockIcon.selected;
//        self.clockIcon.hidden = self.clockIcon.selected;
//        
//    }
//    
    
}


-(void)SetUpSubviews{
    
    for (UIView* view in self.mainScrollView.subviews) {
        [view removeFromSuperview];
    }
    
    for (int i  = 0; i<self.myDevices.count+1; i++) {
        float x = i % 2 * ((PageW-2*self.mainScrollView.left)/2);
        float y = i / 2 * ((PageW-2*self.mainScrollView.left)/2);
        
        if (i ==self.myDevices.count) {
            MyDeviceAddView *deviceAddView = [MyDeviceAddView new];
            deviceAddView.frame = CGRectMake(x+5, y+5,  (PageW-2*self.mainScrollView.left)/2-10, (PageW-2*self.mainScrollView.left)/2-25);
            
            deviceAddView.delegate = self;
            [self.mainScrollView addSubview:deviceAddView];

        }else{
            MyDeviceView *deviceView = [MyDeviceView new];
            deviceView.tag = i;
            deviceView.delegate = self;
            LocalOven* oven = self.myDevices[i];
            deviceView.deviceName.text = oven.name;
            //if ([oven.ssid isEqualToString:[[OvenManager sharedManager] fetchSSID]] && self.devices.count > 0) {
            if (oven.isReady) {
                deviceView.connectStatusImage.image = IMAGENAMED(@"lianjie.png");
                deviceView.deviceStatusLabel.text = @"已链接";
            } else {
                deviceView.connectStatusImage.image = IMAGENAMED(@"tuolian.png");
//#warning 这里是在调试！！！！！！！一定要改回来！！！！！！！！！！！！！！！！！！
                deviceView.deviceStatusLabel.text = @"脱机中";
//                deviceView.deviceStatusLabel.text = @"已连接";
            }
            
            deviceView.frame = CGRectMake(x, y, (PageW-2*self.mainScrollView.left)/2, (PageW-2*self.mainScrollView.left)/2);
            [self.mainScrollView addSubview:deviceView];
        }


    }

}

-(void)AddDevice
{
    AddDeviceStepOneController *stepone = [self.storyboard instantiateViewControllerWithIdentifier:@"AddDeviceStepOneController"];
    [self.navigationController pushViewController:stepone animated:YES];
    NSLog(@"添加设备");
}

-(void)SelectDeviceWithDeviceView:(MyDeviceView *)deviceView
{
    
    if (DebugOvenFlag) {
        DeviceBoardViewController *deviceboard = [self.storyboard instantiateViewControllerWithIdentifier:@"DeviceBoardViewController"];
        
        deviceboard.currentOven = self.myDevices[deviceView.tag];
        
        [self.navigationController pushViewController:deviceboard animated:YES];
        
        return;
    }
    
    
    if([deviceView.deviceStatusLabel.text isEqualToString:@"脱机中"])
    {
        DeviceUnconnectController* uncollectController = [self.storyboard instantiateViewControllerWithIdentifier:@"DeviceUnconnectController"];
        uncollectController.delegate = self;
        uncollectController.currentOven = self.myDevices[deviceView.tag];
        [self.navigationController pushViewController:uncollectController animated:YES];
    } else {
        DeviceBoardViewController *deviceboard = [self.storyboard instantiateViewControllerWithIdentifier:@"DeviceBoardViewController"];
        
        deviceboard.currentOven = self.myDevices[deviceView.tag];
        
        [self.navigationController pushViewController:deviceboard animated:YES];
        NSLog(@"选中设备");
        
    }

}

- (void)close
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - DeviceUnconnectControllerDelegate

- (void)bindOvenAgainWithMac:(NSString *)mac
{
    AddDeviceStepOneController *stepone = [self.storyboard instantiateViewControllerWithIdentifier:@"AddDeviceStepOneController"];
    stepone.currentMac = mac;
    [self.navigationController pushViewController:stepone animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
