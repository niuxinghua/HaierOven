//
//  FoodListViewController.m
//  HaierOven
//
//  Created by dongl on 14/12/18.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "FoodListViewController.h"
#import "FoodListCell.h"
@interface FoodListViewController ()

@end

@implementation FoodListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)TurnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark TableDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

        NSString *cellIdentifier =@"FoodListCell";
        FoodListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        return 95;
}

#pragma mark-

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
