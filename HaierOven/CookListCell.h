//
//  CookListCell.h
//  HaierOven
//
//  Created by dongl on 15/1/5.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CookListFoodView.h"
@class CookListCell;
@protocol CookListCellDelegate <NSObject>

-(void)turnCookDetailView:(UITableViewCell*)cell;

@end
@interface CookListCell : UITableViewCell
@property (strong, nonatomic) NSArray *foods;
@property (weak, nonatomic) id<CookListCellDelegate>delegate;
@end
