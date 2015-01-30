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

@end

@implementation DeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.navigationController.viewControllers.count > 1) {
        UIButton* leftButton = [[UIButton alloc] init];
        //        [leftButton addTarget:self action:@selector(turnLeftMenu) forControlEvents:UIControlEventTouchUpInside];
        //        [super setLeftBarButtonItemWithImageName:@"liebieo.png" andTitle:nil andCustomView:leftButton];
        
        [leftButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [super setLeftBarButtonItemWithImageName:@"back.png" andTitle:nil andCustomView:leftButton];
        
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadLocalOvens) name:MyOvensInfoHadChangedNotificatin object:nil];
    
    [self loadOvenDevices];
    // Do any additional setup after loading the view.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //[self removeObserver:self forKeyPath:@"self.ovenManager.currentStatus.isReady" context:NULL];
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
            for (uSDKDevice* oven in self.devices) {
                [[OvenManager sharedManager] subscribeAllNotificationsWithDevice:oven];
            }
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
            if ([oven.ssid isEqualToString:[[OvenManager sharedManager] fetchSSID]] && self.devices.count > 0) {
                deviceView.connectStatusImage.image = IMAGENAMED(@"lianjie.png");
                deviceView.deviceStatusLabel.text = @"已连接";
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

-(void)AddDevice{
    AddDeviceStepOneController *stepone = [self.storyboard instantiateViewControllerWithIdentifier:@"AddDeviceStepOneController"];
    [self.navigationController pushViewController:stepone animated:YES];
    NSLog(@"添加设备");
}

-(void)SelectDeviceWithDeviceView:(MyDeviceView *)deviceView
{
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

- (void)bindOvenAgain
{
    [self AddDevice];
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
