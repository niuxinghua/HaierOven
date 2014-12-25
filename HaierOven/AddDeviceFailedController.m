//
//  AddDeviceFailedController.m
//  HaierOven
//
//  Created by dongl on 14/12/23.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "AddDeviceFailedController.h"

@interface AddDeviceFailedController ()
@property (strong, nonatomic) IBOutlet UIButton *chickBtn;

@end

@implementation AddDeviceFailedController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SetUpSubViews];
    
    // Do any additional setup after loading the view.
}

-(void)SetUpSubViews{
    self.chickBtn.layer.masksToBounds = YES;
    self.chickBtn.layer.cornerRadius = 15;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            [self.navigationController popToRootViewControllerAnimated:YES];
            break;
        default:
            break;
    }
}

@end
