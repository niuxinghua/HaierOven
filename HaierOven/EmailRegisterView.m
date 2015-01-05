//
//  EmailRegisterView.m
//  HaierOven
//
//  Created by dongl on 15/1/4.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "EmailRegisterView.h"
@interface EmailRegisterView ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *textbgview;
@property (strong, nonatomic) IBOutlet UIButton *sendCodeBtn;
@property (strong, nonatomic) IBOutlet UITextField *phoneTextfailed;
@property (strong, nonatomic) IBOutlet UITextField *passCodeTextfailed;
@property (strong, nonatomic) IBOutlet UITextField *psdTextFailed;
@property (strong, nonatomic) IBOutlet UIButton *registBtn;
@property (strong, nonatomic) IBOutlet UIButton *readDealBtn;

@end
@implementation EmailRegisterView
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame{
//        if (self = [ super initWithFrame:frame]) {
    self = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([EmailRegisterView class]) owner:self options:nil] firstObject];
    self.frame = frame;
    self.phoneTextfailed.delegate = self;
    self.passCodeTextfailed.delegate = self;
    self.psdTextFailed.delegate = self;
//        }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    for (UIView *view in _textbgview) {
        view.layer.borderColor = GlobalOrangeColor.CGColor;
        view.layer.borderWidth = 1.0f;
    }
    _sendCodeBtn.layer.cornerRadius = 10;
    _sendCodeBtn.layer.masksToBounds = YES;
    
    _registBtn.layer.cornerRadius = 15;
    _registBtn.layer.masksToBounds = YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}

- (IBAction)getPassCode:(id)sender {
    NSLog(@"获取验证码");
}
- (IBAction)readDeal:(UIButton*)sender {
    sender.selected =sender.selected == NO?YES:NO;
}
- (IBAction)turnDeal:(id)sender {
    [self.delegate turnDeal];
}
- (IBAction)regist:(id)sender {
    
    if (!self.phoneTextfailed.text.length)
        [self.delegate alertError:@"输入手机号不能为空"];
    else if(![MyTool validateTelephone:self.phoneTextfailed.text])
        [self.delegate alertError:@"输入手机号有误"];
    else if (!self.passCodeTextfailed.text.length)
        [self.delegate alertError:@"输入验证码不能为空"];
    else if(self.psdTextFailed.text.length<6)
        [self.delegate alertError:@"请输入6～16位数字和字母"];
    else if(self.psdTextFailed.text.length>16)
        [self.delegate alertError:@"请输入6～16位数字和字母"];
    else if(![self invalidInputWithUserName:self.phoneTextfailed.text andPassword:self.psdTextFailed.text])
        [self.delegate alertError:@"密码请输入6～16位数字和字母"];
    else if(!self.readDealBtn.selected)
        [self.delegate alertError:@"请确认海尔烤箱隐私协议"];
    else{
        //开始注册吧
        [self.delegate RegisterWithPhone:YES];
        }
}
- (IBAction)turnBack:(id)sender {
    [self.delegate turnBack];
}


- (BOOL)invalidInputWithUserName:(NSString*)username
                     andPassword:(NSString*)password
{
    BOOL invalid = NO;
    NSString *strRegex = @"^[0-9a-zA-Z._!]{1}([a-zA-Z0-9]|[._!]){4,19}$";
    if ([self isValidateRegularExpression:username byExpression:strRegex] && [self isValidateRegularExpression:password byExpression:strRegex]) {
        invalid = YES;
    }
    return invalid;
}
- (BOOL)isValidateRegularExpression:(NSString *)strDestination byExpression:(NSString *)strExpression
{
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strExpression];
    
    return [predicate evaluateWithObject:strDestination];
    
}

@end
