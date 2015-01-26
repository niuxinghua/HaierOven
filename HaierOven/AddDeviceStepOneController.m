//
//  AddDeviceStepOneController.m
//  HaierOven
//
//  Created by dongl on 14/12/22.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "AddDeviceStepOneController.h"
#import "RESideMenu.h"
#import "AddDeviceStepTwoController.h"
@interface AddDeviceStepOneController ()
@property (strong, nonatomic) IBOutlet UIButton *backIcon;
@property BOOL hadDevice;
@property (strong, nonatomic) IBOutlet UIButton *bottomBtn;
@end
@implementation AddDeviceStepOneController
@synthesize hadDevice;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self SetUpSubviews];
    // Do any additional setup after loading the view.
    
    if (self.navigationController.viewControllers.count == 1) {
        UIButton* leftButton = [[UIButton alloc] init];
        [leftButton addTarget:self action:@selector(turnLeftMenu) forControlEvents:UIControlEventTouchUpInside];
        [super setLeftBarButtonItemWithImageName:@"liebieo.png" andTitle:nil andCustomView:leftButton];
        
//        [leftButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
//        [super setLeftBarButtonItemWithImageName:@"back.png" andTitle:nil andCustomView:leftButton];
        
    }
    
}

- (void)turnLeftMenu
{
    [self.sideMenuViewController presentLeftMenuViewController];
}

-(void)SetUpSubviews{
    

    
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    hadDevice = [accountDefaults boolForKey:@"hadDevice"];
    
//    if (hadDevice)
//        [self.backIcon setImage:IMAGENAMED(@"back") forState:UIControlStateNormal];
//    else
//        [self.backIcon setImage:IMAGENAMED(@"liebieo") forState:UIControlStateNormal];
    
    self.bottomBtn.layer.cornerRadius = 12;
    self.bottomBtn.layer.masksToBounds = YES;

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)TurnBack:(id)sender {
//    if (hadDevice)
        [self.navigationController popViewControllerAnimated:YES];
//    else
//        [self presentLeftMenuViewController:sender];
    

}
- (IBAction)TurnStepTwo:(id)sender {
    AddDeviceStepTwoController *stepTwo = [self.storyboard instantiateViewControllerWithIdentifier:@"AddDeviceStepTwoController"];
    [self.navigationController pushViewController:stepTwo animated:YES];
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
