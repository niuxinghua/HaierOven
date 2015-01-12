//
//  FoodsViewController.m
//  HaierOven
//
//  Created by 刘康 on 14/12/30.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "FoodsViewController.h"
#import "FoodCell.h"

@interface FoodsViewController () 

@property (strong, nonatomic) NSArray* foods;
@property (weak, nonatomic) id<AddShoppingListCellDelegate> delegate;

@end

@implementation FoodsViewController

- (instancetype)initWithFoods:(NSArray*)foods delegate:(id<AddShoppingListCellDelegate>)delegate
{
    if (self = [super init]) {
        self.foods = foods;
        self.delegate = delegate;
    }
    return self;
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.foods.count + 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        return 50;
    }
    return 44;
    
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.row == 0) {
        AddShoppingListCell* addCell = [tableView dequeueReusableCellWithIdentifier:@"Add shopping list cell" forIndexPath:indexPath];
        addCell.delegate = self.delegate;
        return addCell;
    } else {
        FoodCell* foodCell = [tableView dequeueReusableCellWithIdentifier:@"Food cell" forIndexPath:indexPath];
        foodCell.food = self.foods[indexPath.row - 1];
        return foodCell;
    }
    
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
