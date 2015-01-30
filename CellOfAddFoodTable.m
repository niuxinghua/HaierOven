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
#import "AddFoodAlertView.h"
@interface CellOfAddFoodTable ()<AddFoodLastCellDelegate,AddFoodCellDelegate>
@property (strong, nonatomic) IBOutlet UIButton *deleteBtn;

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
    self.deleteBtn.selected = NO;
}

- (void)setFoods:(NSMutableArray *)foods
{
    _foods = foods;
    [self.addfoodTableView reloadData];
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

    return self.foods.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==self.foods.count) {
        AddFoodLastCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddFoodLastCell" forIndexPath:indexPath];
        cell.delegate = self;
        return cell;
    }else{
        AddFoodCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddFoodCell" forIndexPath:indexPath];
        if (indexPath.row!=self.foods.count) {
           cell.food = self.foods[indexPath.row];

        }
//        cell.food = self.foods[indexPath.row];
        cell.chickDeleteBtn = self.deleteBtn.selected;
        cell.delegate = self;
        return cell;
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return self.width*0.12;
    return 40;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)addFoodCell{
    Food* food = [[Food alloc] init];
    [self.foods addObject:food];
    food.index = [NSString stringWithFormat:@"%d", self.foods.count];
    
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:self.foods.count-1 inSection:0];
    [self.addfoodTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    [self.delegate reloadMainTableView:self.foods];
}

-(void)addFoodCell:(AddFoodCell *)cell setLabelText:(UILabel *)label
{
    NSIndexPath* indexPath = [self.addfoodTableView indexPathForCell:cell];
//    self.myWindow.hidden = NO;
//    self.addFoodAlertView.addFoodAlertType = label.tag;
//    self.addFoodAlertView.label = label;
    [self.delegate ImportAlertView:label withFoodIndex:indexPath.row];
    
}

- (IBAction)deleteAddFood:(UIButton *)sender {
    sender.selected = sender.selected ==NO?YES:NO;
    [self.addfoodTableView reloadData];
}

-(void)deleteFoodCell:(AddFoodCell *)cell{
    
    NSIndexPath* indexPath= [self.addfoodTableView indexPathForCell:cell];
    
    [self.foods removeObjectAtIndex:indexPath.row];
    
    //    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    
    [self.addfoodTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    
    for (int i = 0; i<self.foods.count; i++) {
        //        [self.steps replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%d",i+1]];
        Food* food = self.foods[i];
        food.index = [NSString stringWithFormat:@"%d",i+1];
    }
    
    [self.addfoodTableView reloadData];
    [self.delegate reloadMainTableView:self.foods];

}
@end
