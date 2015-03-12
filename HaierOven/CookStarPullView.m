//
//  CookStarPullView.m
//  HaierOven
//
//  Created by 刘康 on 15/1/31.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "CookStarPullView.h"

@implementation CookStarPullView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([CookStarPullView class]) owner:self options:nil] firstObject];
    }
    return self;
}
- (IBAction)showMoreTags:(UIButton*)sender {
    sender.selected = !sender.selected;
    self.arrowButton.selected = !self.arrowButton.selected;
    [self.delegate showMoreTags];
}

@end
