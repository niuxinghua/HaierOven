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
#import "DeviceUnconnectController.h"
#define TopPadding   10
#define WidthPadding   10
@interface DeviceViewController () <MyDeviceAddViewDelegate, MyDeviceViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollView;

@end

@implementation DeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadLocalOvens) name:MyOvensInfoHadChangedNotificatin object:nil];
    [self loadLocalOvens];
    // Do any additional setup after loading the view.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadLocalOvens
{
    self.myDevices = [DataCenter sharedInstance].myOvens;
    [self SetUpSubviews];
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
            deviceView.delegate = self;
            LocalOven* oven = self.myDevices[i];
            deviceView.deviceName.text = oven.name;
            deviceView.deviceStatusLabel.text = @"已连接";
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

-(void)SelectDevice{
    DeviceBoardViewController *deviceboard = [self.storyboard instantiateViewControllerWithIdentifier:@"DeviceBoardViewController"];
    [self.navigationController pushViewController:deviceboard animated:YES];
    NSLog(@"选中设备");
    
//    DeviceUnconnectController *unconnect = [self.storyboard instantiateViewControllerWithIdentifier:@"DeviceUnconnectController"];
//    [self.navigationController pushViewController:unconnect animated:YES];

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
