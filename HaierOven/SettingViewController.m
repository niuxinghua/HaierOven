//
//  SettingViewController.m
//  HaierOven
//
//  Created by dongl on 15/1/14.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController



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
- (IBAction)AboutHaier:(id)sender {
    NSLog(@"关于版本");
}

- (IBAction)SuggestPost:(id)sender {
    NSLog(@"意见反馈");
}
- (IBAction)VersionChick:(id)sender {
    NSLog(@"版本确认");
}
- (IBAction)PostMark:(id)sender {
    NSLog(@"app打分");
}
@end
