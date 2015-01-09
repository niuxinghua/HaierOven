//
//  BakeHouseHeaderView.m
//  HaierOven
//
//  Created by dongl on 15/1/9.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "BakeHouseHeaderView.h"
#import "PersonalCenterSectionView.h"
@implementation BakeHouseHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([BakeHouseHeaderView class]) owner:self options:nil] firstObject];
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

@end
