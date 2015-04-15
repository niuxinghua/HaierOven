//
//  AddDeviceStepTwoController.m
//  HaierOven
//
//  Created by dongl on 14/12/22.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "AddDeviceStepTwoController.h"
#import "DeviceConnectProgressView.h"
#import "AddDeviceFailedController.h"
#import "AddDeviceSucceedController.h"
@interface AddDeviceStepTwoController ()
@property (strong, nonatomic) IBOutlet UITextField *psdTextField;
@property (strong, nonatomic) IBOutlet UIButton *chickBtn;
@property (strong, nonatomic) UIWindow *myWindow;
@property (strong, nonatomic) DeviceConnectProgressView *deviceConnectProgressView;
@property (weak, nonatomic) IBOutlet UILabel *wifiNameLabel;

/**
 *  绑定成功的设备
 */
@property (strong, nonatomic) uSDKDevice* bindedDevice;

@property (strong, nonatomic) NSTimer* countDownTimer;
@property (nonatomic) NSInteger currentCount;

@end

@implementation AddDeviceStepTwoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpSubviews];
    // Do any additional setup after loading the view.
    
    [[OvenManager sharedManager] getDevicesCompletion:^(BOOL success, id obj, NSError *error) {
        
    }];
    
    
}
-(void)setUpSubviews{
    
    self.psdTextField.delegate = self;
    self.chickBtn.layer.cornerRadius = 12;
    self.chickBtn.layer.masksToBounds = YES;
    
    self.myWindow = [UIWindow new];
    self.myWindow.frame = CGRectMake(0, 0, PageW, PageH);
    self.myWindow.backgroundColor = [UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:0.3];
    self.myWindow.windowLevel = UIWindowLevelAlert;
    [self.myWindow makeKeyAndVisible];
    self.myWindow.userInteractionEnabled = YES;
    self.myWindow.hidden = YES;
    
    self.deviceConnectProgressView = [[DeviceConnectProgressView alloc]initWithFrame:CGRectMake(0, 0, 220, 220)];
    [self.myWindow addSubview:self.deviceConnectProgressView];
    
    self.wifiNameLabel.text = [[OvenManager sharedManager] fetchSSID];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillShow:)
     
                                                 name:UIKeyboardWillShowNotification
     
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillHide:)
     
                                                 name:UIKeyboardWillHideNotification
     
                                               object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    int y = PageH - self.chickBtn.bottom;
    NSLog(@"%f",self.chickBtn.bottom);
    if (y<height) {
        self.view.frame = CGRectMake(0,-(height - y), PageW, PageH);
    }
}



- (void)keyboardWillHide:(NSNotification *)aNotification
{
    self.view.frame = CGRectMake(0,0, PageW, PageH);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.psdTextField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}
- (IBAction)TurnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)chickWIFI:(id)sender {
    if (![InternetManager sharedManager].isWiFiConnected) {
        [super showProgressErrorWithLabelText:@"请用WiFi连接喔" afterDelay:1];
        return;
    }
    
    if (self.psdTextField.text.length == 0) {
        [super showProgressErrorWithLabelText:@"请填写您的WiFi密码" afterDelay:1];
        return;
    }
    
    [self.psdTextField resignFirstResponder];
    
    self.myWindow.hidden = NO;
    
    self.currentCount = 60;
    self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    
    [self.deviceConnectProgressView.progressView setProgress:0.8 andTimeInterval:0.03];
    
    [[OvenManager sharedManager] bindDeviceWithSsid:nil andApPassword:self.psdTextField.text rebindOvenMac:self.currentMac bindResult:^(BOOL success, id obj, NSError *error) {
        
        [self.countDownTimer invalidate];
        self.countDownTimer = nil;
        
        if (success) {
            NSLog(@"绑定成功");
            
            self.bindedDevice = obj;
            
            [self.deviceConnectProgressView.progressView setProgress:1 andTimeInterval:0.03];
            [self performSelector:@selector(jumpPageTwo) withObject:nil afterDelay:1];
            
            
        } else {
            
            NSLog(@"绑定失败");
            [self.deviceConnectProgressView.progressView setProgress:1 andTimeInterval:0.03];
            AddDeviceFailedController *failed = [self.storyboard instantiateViewControllerWithIdentifier:@"AddDeviceFailedController"];
            [self.navigationController pushViewController:failed animated:YES];
            
        }
        
    }];
    
}



- (void)jumpPageTwo
{
//    AddDeviceFailedController *failed = [self.storyboard instantiateViewControllerWithIdentifier:@"AddDeviceFailedController"];
//    [self.navigationController pushViewController:failed animated:YES];
    AddDeviceSucceedController *succeed = [self.storyboard instantiateViewControllerWithIdentifier:@"AddDeviceSucceedController"];
    succeed.bindedDevice = self.bindedDevice;
    [self.navigationController pushViewController:succeed animated:YES];
}

-(void)viewDidDisappear:(BOOL)animated{
    self.myWindow.hidden = YES;
    [self.deviceConnectProgressView.progressView setProgress:0 andTimeInterval:0.03];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 倒计时

- (void)countDown
{
    self.currentCount --;
    self.deviceConnectProgressView.countDownLabel.text = [NSString stringWithFormat:@"%d", self.currentCount];
    if (self.currentCount == 0) {
        [self.countDownTimer invalidate];
        self.countDownTimer = nil;
        [self.deviceConnectProgressView.progressView setProgress:1 andTimeInterval:0.03];
        self.myWindow.hidden = YES;
        NSLog(@"绑定超时");
        
//        AddDeviceFailedController *failed = [self.storyboard instantiateViewControllerWithIdentifier:@"AddDeviceFailedController"];
//        [self.navigationController pushViewController:failed animated:YES];
        
    }
}

@end





