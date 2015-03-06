//
//  PromptAlertView.m
//  HaierOven
//
//  Created by 刘康 on 15/3/4.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "PromptAlertView.h"

@interface PromptAlertView ()

@property (weak, nonatomic) id <PromptAlertViewDelegate> delegate;

@end


@implementation PromptAlertView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message frame:(CGRect)frame delegate:(id)delegate
{
    self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([PromptAlertView class]) owner:self options:nil] firstObject];
    self.frame = frame;
    self.delegate = delegate;
    self.alertTitleLabel.text = title;
    self.alertContentTextField.text = message;
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    return self;
}


- (IBAction)buttonsTapped:(UIButton *)sender
{
    
    if ([self.delegate respondsToSelector:@selector(promptAlertView:buttonTapped:)]) {
        [self.delegate promptAlertView:self buttonTapped:sender];
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
