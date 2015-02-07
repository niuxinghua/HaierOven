//
//  AddDeviceSucceedController.m
//  HaierOven
//
//  Created by dongl on 14/12/23.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "AddDeviceSucceedController.h"

@interface AddDeviceSucceedController ()
@property (strong, nonatomic) IBOutlet UITextField *deviceTextFailed;
@property (strong, nonatomic) IBOutlet UIButton *chickBtn;

@end

@implementation AddDeviceSucceedController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self SetUpSubViews];
    // Do any additional setup after loading the view.
}
-(void)SetUpSubViews{
    
    @try {
        [[NSNotificationCenter defaultCenter] addObserver:self
         
                                                 selector:@selector(keyboardWillShow:)
         
                                                     name:UIKeyboardWillShowNotification
         
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
         
                                                 selector:@selector(keyboardWillHide:)
         
                                                     name:UIKeyboardWillHideNotification
         
                                                   object:nil];
    }
    @catch (NSException *exception) {
        NSLog(@"收听键盘通知异常");
    }
    @finally {
        NSLog(@"");
    }
    
    
    self.deviceTextFailed.delegate = self;
    self.chickBtn.layer.masksToBounds = YES;
    self.chickBtn.layer.cornerRadius = 15;
}

//当键盘出现或改变时调用

- (void)keyboardWillShow:(NSNotification *)aNotification

{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    int y = PageH - self.chickBtn.bottom;
    if (y<height) {
        self.view.frame = CGRectMake(0,-(height - y), PageW, PageH);
    }
}


//当键退出时调用

- (void)keyboardWillHide:(NSNotification *)aNotification

{
    self.view.frame = CGRectMake(0,64, PageW, PageH);
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)TurnBack:(UIButton*)sender {
    switch (sender.tag) {
        case 1:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case 2:
            [self saveDeviceInfo];
            [self.navigationController popToRootViewControllerAnimated:YES];
            break;
        default:
            break;
    }
}

/**
 *  绑定成功后保存烤箱到本地
 */
- (void)saveDeviceInfo
{
    if (self.deviceTextFailed.text.length == 0) {
        [super showProgressErrorWithLabelText:@"请输入烤箱名" afterDelay:1];
        return;
    }
    
    if (self.deviceTextFailed.text.length > 10) {
        [super showProgressErrorWithLabelText:@"烤箱名不能超过10个字符" afterDelay:1];
        return;
    }
    
    // 保存到本地
    LocalOven* oven = [[LocalOven alloc] init];
    uSDKDevice* device = self.bindedDevice;
    oven.name = self.deviceTextFailed.text;
    oven.ip = device.ip;
    oven.mac = device.mac;
    oven.ssid = [[OvenManager sharedManager] fetchSSID];
    oven.typeIdentifier = device.typeIdentifier;
    //            oven.attribute = device.attributeDict;
    [[DataCenter sharedInstance] addOvenInfoToLocal:oven];
    
    //登录用户发送网络请求，增加积分
    if (IsLogin) {
        [[InternetManager sharedManager] bindOvenWithUserBaseId:CurrentUserBaseId deviceMac:oven.mac callBack:^(BOOL success, id obj, NSError *error) {
            //                    if (success) {
            //                        [super showProgressCompleteWithLabelText:@"绑定成功 +500点心" afterDelay:1];
            //                    }
            [[NSNotificationCenter defaultCenter] postNotificationName:BindDeviceSuccussNotification object:nil];
        }];
    }
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
