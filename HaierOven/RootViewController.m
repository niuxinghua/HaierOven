//
//  RootViewController.m
//  HaierOven
//
//  Created by dongl on 14/12/16.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "RootViewController.h"
#import "LeftMenuViewController.h"
@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (void)awakeFromNib
{
    self.menuPreferredStatusBarStyle        = UIStatusBarStyleLightContent;
    self.contentViewShadowColor             = [UIColor blackColor];
    self.contentViewShadowOffset            = CGSizeMake(0, 0);
    self.contentViewShadowOpacity           = 0.6;
    self.contentViewShadowRadius            = 12;
    self.contentViewShadowEnabled           = YES;

    //    self.panGestureEnabled = NO;
    self.scaleContentView                   = NO;
    self.contentViewInPortraitOffsetCenterX = 100;
    self.contentViewController              = [self.storyboard instantiateViewControllerWithIdentifier:@"contentViewController"];
    self.leftMenuViewController             = [self.storyboard instantiateViewControllerWithIdentifier:@"LeftMenuViewController"];

    self.backgroundImage                    = [MyTool createImageWithColor:[UIColor lightGrayColor]];
    self.delegate                           = self;
}


@end
