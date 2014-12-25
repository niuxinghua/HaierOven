//
//  SecTableViewCell.h
//  HaierOven
//
//  Created by dongl on 14/12/16.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *laftIconButton;
@property (strong, nonatomic) IBOutlet UILabel *centerLabel;
@property (strong, nonatomic) IBOutlet UIButton *rightButton;
@property (strong, nonatomic) IBOutlet UIView *bottomLineView;

@end
