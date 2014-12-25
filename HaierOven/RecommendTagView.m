//
//  RecommendTagView.m
//  HaierOven
//
//  Created by dongl on 14/12/18.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "RecommendTagView.h"

@implementation RecommendTagView

-(instancetype)initWithFrame:(CGRect)frame{
    //    if (self = [ super initWithFrame:frame]) {
    self = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([RecommendTagView class]) owner:self options:nil] firstObject];
    self.frame = frame;
    
    //    }
    return self;
}
- (IBAction)TouUpTagbtn:(UIButton *)sender {
    [self.delegate TouchUpTag:sender];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
