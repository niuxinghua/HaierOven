//
//  StudyCookView.m
//  HaierOven
//
//  Created by dongl on 15/1/20.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "StudyCookView.h"
@interface StudyCookView()

@property (weak, nonatomic) IBOutlet UIButton *titleBtn;

@end
@implementation StudyCookView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame{
    self = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([StudyCookView class]) owner:self options:nil] firstObject];
    self.frame = frame;

    return self;
}

-(void)setTitle:(NSString *)title{
    _title = title;
    [self.titleBtn setTitle:title forState:UIControlStateHighlighted];
    [self.titleBtn setTitle:title forState:UIControlStateNormal];
}


- (IBAction)TurnStudyCookDetail:(id)sender {
    [self.delegate getSelectedView:self];
}

@end
