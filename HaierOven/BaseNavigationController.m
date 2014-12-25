//
//  BaseNavigationController.m
//  众筹
//
//  Created by 刘康 on 14/11/13.
//  Copyright (c) 2014年 origheart. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];

//    self.navigationBar.barTintColor = GlobalRedColor;
    
//    [self.navigationBar setBackgroundImage:[MyTool createImageWithColor:GlobalOrangeColor] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:IMAGENAMED(@"clear.png")];
    
    self.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationBar.translucent = NO;
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

@end
