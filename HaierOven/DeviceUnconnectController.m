//
//  DeviceUnconnectController.m
//  HaierOven
//
//  Created by dongl on 14/12/23.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "DeviceUnconnectController.h"
#import "DeviceEditController.h"
#import "DeviceMessageController.h"
@interface DeviceUnconnectController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *bottomBtns;

@end

@implementation DeviceUnconnectController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SetUpSubView];

    // Do any additional setup after loading the view.
}

-(void)SetUpSubView{
    for (UIButton *btn in self.bottomBtns) {
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 15;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)DeleteDevice:(id)sender {
    [[DataCenter sharedInstance] removeOvenInLocal:self.currentOven];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)ConnectDevice:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
    [self.delegate bindOvenAgain];
    
}
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
