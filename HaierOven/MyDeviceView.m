//
//  MyDeviceView.m
//  HaierOven
//
//  Created by dongl on 14/12/22.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "MyDeviceView.h"

@implementation MyDeviceView

-(instancetype)initWithFrame:(CGRect)frame{
    //    if (self = [ super initWithFrame:frame]) {
    self = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([MyDeviceView class]) owner:self options:nil] firstObject];
    self.frame = frame;
    return self;
}

-(void)TouchUpDevice{
    [self.delegate SelectDevice];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TouchUpDevice)];
    [self.deviceImage addGestureRecognizer:tap];
    self.deviceImage.frame = CGRectMake(5, 5, self.width-10 , self.height-25);
    self.deviceStatusLabel.frame = CGRectMake(self.width-39-5, self.deviceImage.bottom, 39, 20);
    self.deviceName.frame = CGRectMake(5, self.deviceImage.bottom, self.deviceStatusLabel.left, 20);
    self.connectStatusImage.frame = CGRectMake(self.deviceImage.width-32, self.deviceImage.bottom-32, 32, 32);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
