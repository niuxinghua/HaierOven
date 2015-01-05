//
//  AddFoodCell.h
//  HaierOven
//
//  Created by dongl on 14/12/29.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AddFoodCell;
@protocol AddFoodCellDelegate <NSObject>

-(void)addFoodCell:(AddFoodCell*)cell setLabelText:(UILabel *)label;

@end
@interface AddFoodCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *foodLabel;
@property (strong, nonatomic) IBOutlet UILabel *foodCountLabel;

@property (weak, nonatomic)id<AddFoodCellDelegate> delegate;

@property (strong, nonatomic) Food* food;

@end
