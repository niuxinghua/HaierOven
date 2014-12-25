//
//  DeviceMessageCell.h
//  HaierOven
//
//  Created by dongl on 14/12/23.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeviceMessageCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *messageTime;
@property (strong, nonatomic) UILabel *messageLabel;

-(void)setContentLabel:(NSString *)string;
@end
