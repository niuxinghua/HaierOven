//
//  LeftMenuAlert.m
//  HaierOven
//
//  Created by dongl on 15/1/22.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "LeftMenuAlert.h"

@implementation LeftMenuAlert

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame{
    //    if (self = [ super initWithFrame:frame]) {
    self = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([LeftMenuAlert class]) owner:self options:nil] firstObject];
    self.frame = frame;
    //    self.layer.cornerRadius = 15;
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    
    [self initCloseButton];
    
    return self;
}

- (void)initCloseButton
{
    UIButton* closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.closeButton = closeButton;
    [closeButton setTitle:@"x" forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closeButton setBackgroundColor:GlobalOrangeColor];
    [closeButton addTarget:self action:@selector(closeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeButton];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.closeButton.frame = CGRectMake(self.width - 25, 0, 25, 25);
    self.closeButton.layer.cornerRadius = 5;
    self.closeButton.layer.masksToBounds = YES;
    
}

- (void)closeButtonTapped:(UIButton*)sender
{
    
    [self.delegate cancelOperate];
    
}

- (IBAction)isGoingToLogin:(UIButton *)sender {
    [self.delegate isGoingToLogin:sender.tag];
}
@end
