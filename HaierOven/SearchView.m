//
//  SearchView.m
//  HaierOven
//
//  Created by dongl on 14/12/18.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "SearchView.h"

@implementation SearchView
-(instancetype)initWithFrame:(CGRect)frame{
//    if (self = [ super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([SearchView class]) owner:self options:nil] firstObject];
    self.frame = frame;
        
//    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([SearchView class]) owner:self options:nil] firstObject];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self setUpSubView];
}

-(void)setUpSubView{    
    self.searchTextFailed.returnKeyType =UIReturnKeyDone;
    self.searchTextFailed.clearsOnBeginEditing = YES;
    self.searchTextFailed.delegate = self;
    self.cancelbtn.hidden = YES;
}
- (void)keyboardDidShow
{
    self.cancelbtn.hidden = NO;
}

- (void)keyboardDidHide
{
    self.cancelbtn.hidden = YES;
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.cancelbtn.hidden = NO;
    [self.delegate StartReach:textField];
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField

{
    
    [self.delegate TouchUpInsideDone:textField.text];
    self.cancelbtn.hidden = YES;
    return [textField resignFirstResponder];
    
}


- (IBAction)textChanged:(UITextField *)sender {
    [self.delegate textFieldTextChanged:sender.text];
}


- (IBAction)TurnBack:(id)sender {
    [self.delegate TouchUpInsideCancelBtn];
}

- (IBAction)Cancel:(id)sender {
    self.searchTextFailed.text = nil;
    self.cancelbtn.hidden = YES;
    [self.searchTextFailed resignFirstResponder];
    [self.delegate Cancel];
}

@end
