//
//  MyDeviceAddView.m
//  HaierOven
//
//  Created by dongl on 14/12/22.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "MyDeviceAddView.h"

@implementation MyDeviceAddView
-(instancetype)initWithFrame:(CGRect)frame{
    //    if (self = [ super initWithFrame:frame]) {
    self = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([MyDeviceAddView class]) owner:self options:nil] firstObject];
    self.frame = frame;
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)layoutSubviews{
    [super layoutSubviews];
    
}

- (IBAction)addDevice:(id)sender {
    [self.delegate AddDevice];
}
@end
