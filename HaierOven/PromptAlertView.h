//
//  PromptAlertView.h
//  HaierOven
//
//  Created by 刘康 on 15/3/4.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PromptAlertView;
@protocol PromptAlertViewDelegate <NSObject>

@required

- (void)promptAlertView:(PromptAlertView*)alertView buttonTapped:(UIButton*)sender;

@end

@interface PromptAlertView : UIView

@property (weak, nonatomic) IBOutlet UILabel *alertTitleLabel;

@property (weak, nonatomic) IBOutlet UITextField *alertContentTextField;

- (instancetype)initWithTitle:(NSString*)title message:(NSString *)message frame:(CGRect)frame delegate:(id)delegate;

@end










