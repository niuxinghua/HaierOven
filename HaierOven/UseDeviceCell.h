//
//  UseDeviceCell.h
//  HaierOven
//
//  Created by dongl on 14/12/30.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UseBakeView.h"

@interface UseDeviceCell : UITableViewCell<UseBakeViewDelegate>

@property(weak, nonatomic)id <UseBakeViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *usedOvenButton;

@end
