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
-(void)deleteFoodCell:(AddFoodCell *)cell;
@end
@interface AddFoodCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *foodLabel;
@property (strong, nonatomic) IBOutlet UILabel *foodCountLabel;
@property (strong, nonatomic) IBOutlet UIButton *deleteBtn;

@property (weak, nonatomic)id<AddFoodCellDelegate> delegate;

@property (strong, nonatomic) Food* food;

@property (nonatomic) BOOL chickDeleteBtn;
@end
