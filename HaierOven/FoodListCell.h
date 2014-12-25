//
//  FoodListCell.h
//  HaierOven
//
//  Created by dongl on 14/12/18.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoodListCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *cookerAvater;
@property (strong, nonatomic) IBOutlet UILabel *foodNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (strong, nonatomic) IBOutlet UIImageView *foodImage;

@end
