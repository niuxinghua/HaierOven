//
//  CookStarCell.h
//  HaierOven
//
//  Created by dongl on 15/1/5.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CookStarCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *avaterImageView;
@property (strong, nonatomic) IBOutlet UIImageView *vipType;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *descLabel;
@property (strong, nonatomic) IBOutlet UILabel *foodCountLabel;

@end
