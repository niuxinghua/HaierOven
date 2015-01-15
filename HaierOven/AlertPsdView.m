//
//  AlertPsdView.m
//  HaierOven
//
//  Created by dongl on 15/1/15.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "AlertPsdView.h"
@interface AlertPsdView()<UITextFieldDelegate>{
    CGFloat tempFloat;
}
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *textfields;
@property (strong, nonatomic) IBOutlet UITextField *oldPsd;
@property (strong, nonatomic) IBOutlet UITextField *editPsd;
@property (strong, nonatomic) IBOutlet UITextField *chickpsd;

@end
@implementation AlertPsdView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame{
    //    if (self = [super initWithFrame:frame]) {
    self =[[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([AlertPsdView class]) owner:self options:nil]firstObject];
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    self.frame = frame;
    self.center = CGPointMake(PageW/2, 100);

    //    }
    for (UITextField *textfield in self.textfields) {
        textfield.delegate = self;
        textfield.layer.cornerRadius = 5;
        textfield.layer.borderColor = GlobalOrangeColor.CGColor;
        textfield.layer.borderWidth = 1;
    }
    
    @try {
        [[NSNotificationCenter defaultCenter] addObserver:self
         
                                                 selector:@selector(keyboardWillShow:)
         
                                                     name:UIKeyboardWillShowNotification
         
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
         
                                                 selector:@selector(keyboardWillHide:)
         
                                                     name:UIKeyboardWillHideNotification
         
                                                   object:nil];
    }
    @catch (NSException *exception) {
        NSLog(@"收听键盘通知异常");
    }
    @finally {
        NSLog(@"");
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)chickPsd:(UIButton*)sender {
    if (sender.tag ==1) {
        if(self.editPsd.text.length==0){
            [self.delegate ChangePsdError:@"请输入新密码"];
        }else if(self.oldPsd.text.length==0){
            [self.delegate ChangePsdError:@"请输入旧密码"];
        }else if(self.chickpsd.text.length==0){
            [self.delegate ChangePsdError:@"请输入确认密码"];
        }else if (![self.editPsd.text isEqualToString:self.chickpsd.text]) {
            [self.delegate ChangePsdError:@"两次密码输入不一致"];
        } else{
            [self.delegate ChangeWithOldPsd:self.oldPsd.text andNewPsd:self.editPsd.text];
        }
    }else{
        [self.delegate CancelChangePsd];
    }
    
    for (UITextField *textfield in self.textfields) {
        [textfield resignFirstResponder];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    //    textField.text = self.titleString;
    return [textField resignFirstResponder];
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    tempFloat = textField.bottom+100;
    return YES;
}



- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    int k = PageH - tempFloat;
    if (k<height) {
        self.frame = CGRectMake(self.left,-(height - k), self.width, self.height);
    }
}


//当键退出时调用

- (void)keyboardWillHide:(NSNotification *)aNotification

{
    self.frame = CGRectMake(self.left,100, self.width, self.height);
    
}

@end
