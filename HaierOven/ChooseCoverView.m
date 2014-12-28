//
//  ChooseCoverView.m
//  HaierOven
//
//  Created by dongl on 14/12/28.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "ChooseCoverView.h"

@implementation ChooseCoverView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame{
    //    if (self = [ super initWithFrame:frame]) {
    self = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([ChooseCoverView class]) owner:self options:nil] firstObject];
    self.frame = frame;
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

- (IBAction)action:(UIButton *)sender {
    [self.delegate TakeCover:sender.tag];
}

-(void)setBtns:(NSArray *)btns{
    _btns = btns;
    for (UIButton *btn in btns) {
        btn.layer.cornerRadius = 15;
        btn.layer.masksToBounds = YES;
    }
}
@end
