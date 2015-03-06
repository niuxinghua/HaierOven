//
//  SecDeviceTableViewCell.h
//  HaierOven
//
//  Created by dongl on 14/12/22.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SecDeviceTableViewCellDelegate <NSObject>

@required
- (void)deviceInfoButtonTapped;

@end

@interface SecDeviceTableViewCell : UITableViewCell

@property (weak, nonatomic) id <SecDeviceTableViewCellDelegate> delegate;

@end
