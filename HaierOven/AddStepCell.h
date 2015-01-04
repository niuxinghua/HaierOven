//
//  AddStepCell.h
//  HaierOven
//
//  Created by dongl on 14/12/30.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AddStepCell;
@protocol AddStepCellDelegate <NSObject>

-(void)AddStepOfMainTableView:(NSMutableArray *)arr;
-(void)DeleteStepOfMainTableView:(NSMutableArray *)arr;

-(void)ImportStepDescription:(UILabel*)label withStepIndex:(NSInteger)index;
-(void)AddStepImage:(UIImageView*)imageView withStepIndex:(NSInteger)index;
@end

@interface AddStepCell : UITableViewCell<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *addStepTableView;
@property (strong, nonatomic) NSMutableArray *steps;
@property (weak, nonatomic)id<AddStepCellDelegate>delegate;
@end
