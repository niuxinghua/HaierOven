//
//  AddFoodCell.h
//  HaierOven
//
//  Created by dongl on 14/12/29.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddFoodCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *foodLabel;
@property (strong, nonatomic) IBOutlet UILabel *foodCountLabel;

@property (strong, nonatomic) NSString *foodName;
@property (strong, nonatomic) NSString *foodCount;
@end
