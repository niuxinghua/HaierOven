//
//  OvenTypeAlert.m
//  HaierOven
//
//  Created by 刘康 on 15/2/3.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "OvenTypeAlert.h"

@implementation OvenTypeAlert

-(instancetype)initWithFrame:(CGRect)frame{
    self = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([OvenTypeAlert class]) owner:self options:nil] firstObject];
    self.frame = frame;
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    return self;
}


- (IBAction)ovenTypeTapped:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(selectedOvenType:)]) {
        [self.delegate selectedOvenType:sender.currentTitle];
        
    }

}



@end












