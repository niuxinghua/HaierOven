//
//  AnimationView.m
//  HaierOven
//
//  Created by dongl on 15/2/2.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "AnimationView.h"

@implementation AnimationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame{
    //    if (self = [ super initWithFrame:frame]) {
    self = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([AnimationView class]) owner:self options:nil] firstObject];
    self.frame = frame;
    //    self.layer.cornerRadius = 15;
    return self;
}

@end
