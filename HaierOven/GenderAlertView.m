//
//  GenderAlertView.m
//  HaierOven
//
//  Created by dongl on 15/1/14.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "GenderAlertView.h"

@implementation GenderAlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
//-(instancetype)initWithFrame:(CGRect)frame{
////    if (self = [ super initWithFrame:frame]) {
//    self = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([GenderAlertView class]) owner:self options:nil] firstObject];
//    self.center = CGPointMake(PageW/2, PageH/3.2);
////    }
//    return self;
//}


-(instancetype)initWithFrame:(CGRect)frame{
//        if (self = [ super initWithFrame:frame]) {
    self = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([GenderAlertView class]) owner:self options:nil] firstObject];
    self.frame = frame;
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
//        }
    //    self.layer.cornerRadius = 15;
    return self;
}


- (IBAction)ChooseGender:(UIButton *)sender {
    [self.delegate chooseGender:sender.tag];
}

@end
