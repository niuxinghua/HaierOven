//
//  NotificationSectionHeadView.m
//  HaierOven
//
//  Created by dongl on 15/1/15.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "NotificationSectionHeadView.h"

@implementation NotificationSectionHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
//    self = [super initWithFrame:frame];
    self = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([NotificationSectionHeadView class]) owner:self options:nil] firstObject];
    self.frame = frame;
    
//    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
