
//
//  SectionFiexibleView.m
//  HaierOven
//
//  Created by dongl on 15/1/12.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "SectionFiexibleView.h"
@interface SectionFiexibleView ()

@end
@implementation SectionFiexibleView


-(instancetype)initWithFrame:(CGRect)frame{
    //    if (self = [ super initWithFrame:frame]) {
    self = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([SectionFiexibleView class]) owner:self options:nil]firstObject];
    self.frame = frame;
    //    }
    return self;
}
- (IBAction)fiexViewShow:(UIButton*)sender {
    [self.delegate GetfiexibleBtnSelected:sender andUIView:self];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


@end
