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

@required
-(void)turnCookDetailView:(UITableViewCell*)cell;

- (void)purchaseFood:(PurchaseFood*)food inCell:(CookListCell*)cell isPurchased:(BOOL)isPurchased;

@end
@interface CookListCell : UITableViewCell <CookListFoodViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *cookbookNameBtn;
@property (strong, nonatomic) NSArray *foods;
@property (weak, nonatomic) id<CookListCellDelegate>delegate;
@end
