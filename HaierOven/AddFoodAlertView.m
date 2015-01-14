//
//  AddFoodAlertView.m
//  HaierOven
//
//  Created by dongl on 14/12/29.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "AddFoodAlertView.h"

@implementation AddFoodAlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame{
    //    if (self = [ super initWithFrame:frame]) {
    self = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([AddFoodAlertView class]) owner:self options:nil] firstObject];
    self.frame = frame;
    self.center = CGPointMake(PageW/2, PageH/3.2);
//    self.layer.cornerRadius = 15;
    return self;
}


-(void)setAlertTextFailed:(UITextField *)alertTextFailed{
    _alertTextFailed = alertTextFailed;
    alertTextFailed.layer.borderColor = GlobalOrangeColor.CGColor;
    alertTextFailed.layer.borderWidth = 1;
    alertTextFailed.delegate = self;
}

-(void)setAddFoodAlertType:(AddFoodAlertType)addFoodAlertType{
    _addFoodAlertType = addFoodAlertType;
    self.alertTextFailed.text = @"";
    if (addFoodAlertType == AddFoodAlertTypeAddFood) {
        self.alertTitle.text = @"填写添加食材";
    }else{
        self.alertTitle.text = @"填写添加食材分量";
    }
}


-(void)setAlertTitleSting:(NSString *)alertTitleSting{
    _alertTitleSting = alertTitleSting;
    self.alertTitle.text = alertTitleSting;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}
- (IBAction)ChickAlert:(UIButton*)sender {
    if (sender.tag == 1) {
        self.label.text = self.alertTextFailed.text;
        self.label.textColor = [UIColor blackColor];
        [self.delegate ChickAlert:self.label andTextFailed:self.alertTextFailed];
    }else
        [self.delegate Cancel];
}

-(void)setLabel:(UILabel *)label{
    _label   = label;
    self.alertTextFailed.text = label.text;
}
@end
