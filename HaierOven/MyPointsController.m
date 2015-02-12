//
//  MyPointsController.m
//  HaierOven
//
//  Created by 刘康 on 15/2/10.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "MyPointsController.h"

@interface MyPointsController ()

@end

@implementation MyPointsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.backgroundColor = [UIColor colorWithRed:237.0f/255 green:237.0f/255 blue:237.0f/255 alpha:1.0];
    self.isBackButton = YES;
    [self.navigationItem hidesBackButton];
    
    UIButton *backButton = [[UIButton alloc] init];
    [backButton setImage:IMAGENAMED(@"back.png") forState:UIControlStateNormal];
    [backButton setImage:IMAGENAMED(@"back.png") forState:UIControlStateHighlighted];
    backButton.showsTouchWhenHighlighted = YES;
    [backButton setFrame:CGRectMake(0, 0, 26, 26)];
    [backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    
}

- (void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return Main_Screen_Width * 2.38;
    
}

//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 1;
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
