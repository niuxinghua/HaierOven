//
//  StartAnimationController.m
//  HaierOven
//
//  Created by dongl on 15/2/2.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "StartAnimationController.h"
#import "RootViewController.h"
#import "AnimationView.h"
@interface StartAnimationController ()

@end

@implementation StartAnimationController

- (void)viewDidLoad {
    [super viewDidLoad];

      // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated{
    RootViewController *root = [self.storyboard instantiateViewControllerWithIdentifier:@"RootViewController"];
    AnimationView *animation = [[AnimationView alloc]initWithFrame:CGRectMake((PageW-254)/2, PageH-100, 254, 100)];
    [self.view addSubview:animation];
    animation.alpha = 0;
    [UIView animateWithDuration:3 animations:^{
        animation.frame =CGRectMake((PageW-254)/2, PageH-150, 254, 100);
        animation.alpha = 0.8;
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:3 animations:^{
            animation.alpha = 1;
        } completion:^(BOOL finished) {
            [self presentViewController:root animated:YES completion:nil];
        }];
        
    }];

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
