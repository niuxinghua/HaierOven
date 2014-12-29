//
//  CellOfAddFoodTable.m
//  HaierOven
//
//  Created by dongl on 14/12/29.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "CellOfAddFoodTable.h"
#import "AddfoodCell.h"
#import "Food.h"
#import "AddFoodLastCell.h"
@interface CellOfAddFoodTable ()<AddFoodLastCellDelegate>

@end
@implementation CellOfAddFoodTable

- (void)awakeFromNib {

    // Initialization code

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



-(void)layoutSubviews{
    [super layoutSubviews];

}


-(void)setAddfoodTableView:(UITableView *)addfoodTableView{
    _addfoodTableView = addfoodTableView;
    _addfoodTableView.delegate = self;
    _addfoodTableView.dataSource = self;
    [_addfoodTableView registerNib:[UINib nibWithNibName:NSStringFromClass([AddFoodCell class]) bundle:nil] forCellReuseIdentifier:@"AddFoodCell"];
    [_addfoodTableView registerNib:[UINib nibWithNibName:NSStringFromClass([AddFoodLastCell class]) bundle:nil] forCellReuseIdentifier:@"AddFoodLastCell"];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.food.count+2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==self.food.count+1) {
        AddFoodLastCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddFoodLastCell" forIndexPath:indexPath];
        cell.delegate = self;
        return cell;
    }else{
        AddFoodCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddFoodCell" forIndexPath:indexPath];
        if (self.food.count>0&&indexPath.row!=self.food.count) {
//            Food *data = self.food[indexPath.row];
//            cell.foodName = data.name;
//            cell.foodCount = data.desc;
            cell.foodName = self.food[indexPath.row];

        }
        return cell;
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.width*0.12;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//        // 2.更新UI界面
//        //[tableView reloadData];
//        NSIndexPath *path = [NSIndexPath indexPathForRow:1 inSection:0];
//        [self.food addObject:@"鸡肉"];
//        [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)addFoodCell{
//    AddFoodCell *addfood = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([AddFoodCell class]) owner:self options:nil] firstObject];
    
//    self.addfoodTableView.editing = YES;
    [self.food addObject:@"鸡肉"];

    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:self.food.count inSection:0];
    [self.addfoodTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    [self.delegate reloadMainTableView:self.food];
}

@end
