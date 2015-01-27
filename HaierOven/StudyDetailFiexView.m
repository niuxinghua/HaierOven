//
//  StudyDetailFiexView.m
//  HaierOven
//
//  Created by dongl on 15/1/21.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "StudyDetailFiexView.h"
#import "StudyCookPartOne.h"
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

-(void)setTools:(NSArray *)tools{
    _tools = tools;
    for (int i = 0; i<tools.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        StudyCookPartOne *study = tools[i];
        [btn setTitle:study.title forState:UIControlStateNormal];
        [btn setTitle:study.title forState:UIControlStateHighlighted];
        [btn setTitleColor:GlobalOrangeColor forState:UIControlStateNormal];
        [btn setTitleColor:GlobalOrangeColor forState:UIControlStateHighlighted];
        btn.titleLabel.font = [UIFont fontWithName:GlobalTextFontName size:15];
        btn.frame = CGRectMake(0, 44*i+8, self.width, 44);
        btn.tag = i;
        [btn addTarget:self action:@selector(tapTag:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
}

-(void)tapTag:(UIButton *)btn{
    [self.delegate reloadViewWithToolsIndex:btn.tag];
}
@end
