//
//  StudyDetailFiexView.m
//  HaierOven
//
//  Created by dongl on 15/1/21.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "StudyDetailFiexView.h"

@implementation StudyDetailFiexView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)init{
    if (self = [super init]) {
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
    }
    return self;
}
@end
