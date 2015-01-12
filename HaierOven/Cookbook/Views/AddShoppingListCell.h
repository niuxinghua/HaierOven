//
//  AddShoppingListCell.h
//  HaierOven
//
//  Created by 刘康 on 14/12/30.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddShoppingListCell;
@protocol AddShoppingListCellDelegate <NSObject>

@required
- (void)AddShoppingListWithCell:(AddShoppingListCell*)cell;

@end

@interface AddShoppingListCell : UITableViewCell

@property (weak, nonatomic) id<AddShoppingListCellDelegate> delegate;

@end
