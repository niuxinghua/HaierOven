//
//  PhoneRegisterView.m
//  HaierOven
//
//  Created by dongl on 15/1/4.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "PhoneRegisterView.h"
@interface PhoneRegisterView ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *textbgview;
@property (strong, nonatomic) IBOutlet UITextField *emailTextfailed;
@property (strong, nonatomic) IBOutlet UITextField *psdTextFailed;
@property (strong, nonatomic) IBOutlet UIButton *registBtn;
@property (strong, nonatomic) IBOutlet UIButton *readDealBtn;
@end
@implementation PhoneRegisterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame{
    //        if (self = [ super initWithFrame:frame]) {
    self = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([PhoneRegisterView class]) owner:self options:nil] firstObject];
    self.frame = frame;
    self.emailTextfailed.delegate = self;
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
    _registBtn.layer.cornerRadius = 15;
    _registBtn.layer.masksToBounds = YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}

- (IBAction)readDeal:(UIButton*)sender {
    sender.selected =sender.selected == NO?YES:NO;
}
- (IBAction)turnDeal:(id)sender {
    [self.delegate turnDealEmail];
}
- (IBAction)regist:(id)sender {
    
    if (!self.emailTextfailed.text.length)
        [self.delegate alertErrorEmail:@"输入邮箱不能为空"];
    else if(![MyTool validateEmail:self.emailTextfailed.text])
        [self.delegate alertErrorEmail:@"输入邮箱号有误"];
    else if(self.psdTextFailed.text.length<6)
        [self.delegate alertErrorEmail:@"请输入6～16位数字和字母"];
    else if(self.psdTextFailed.text.length>16)
        [self.delegate alertErrorEmail:@"请输入6～16位数字和字母"];
    else if(![self invalidInputWithUserName:nil andPassword:self.psdTextFailed.text])
        [self.delegate alertErrorEmail:@"密码请输入6～16位数字和字母"];
    else if(!self.readDealBtn.selected)
        [self.delegate alertErrorEmail:@"请确认海尔烤箱隐私协议"];
    else{
        //开始注册吧
        [self.delegate RegisterWithEmail:YES];
    }
}
- (IBAction)turnBack:(id)sender {
    [self.delegate turnBackEmail];
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
