//
//  AddFoodLastCell.h
//  HaierOven
//
//  Created by dongl on 14/12/29.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AddFoodLastCell;
@protocol AddFoodLastCellDelegate <NSObject>

-(void)addFoodCell;

@end
@interface AddFoodLastCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *addFoodBtn;
- (IBAction)addFood:(id)sender;
@property (nonatomic,weak)id<AddFoodLastCellDelegate>delegate;
@end
