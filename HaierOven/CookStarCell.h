//
//  CookStarCell.h
//  HaierOven
//
//  Created by dongl on 15/1/5.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CookStarCell;
@protocol CookStarCellDelegate <NSObject>

@required
- (void)cookStarCell:(CookStarCell*)cell followButtonTapped:(UIButton*)sender;

@end

@interface CookStarCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *avaterImageView;
@property (strong, nonatomic) IBOutlet UIImageView *vipType;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *descLabel;
@property (strong, nonatomic) IBOutlet UILabel *foodCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *followButton;
@property (weak, nonatomic) id<CookStarCellDelegate> delegate;
@property (strong, nonatomic) CookerStar* cookerStar;

@end
