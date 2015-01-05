//
//  CellOfAddFoodTable.h
//  HaierOven
//
//  Created by dongl on 14/12/29.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CellOfAddFoodTableDelegate <NSObject>

-(void)reloadMainTableView:(NSMutableArray *)arr;
-(void)ImportAlertView:(UILabel*)label withFoodIndex:(NSInteger)foodIndex;
@end

@interface CellOfAddFoodTable : UITableViewCell <UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *addfoodTableView;
@property (strong, nonatomic) NSMutableArray *foods;
@property (weak, nonatomic)id<CellOfAddFoodTableDelegate>delegate;
@end
