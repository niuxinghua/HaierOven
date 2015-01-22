//
//  OrderAlertView.m
//  HaierOven
//
//  Created by dongl on 15/1/21.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "OrderAlertView.h"
@interface OrderAlertView()
@property (weak, nonatomic) IBOutlet UIDatePicker *datepicker;

@end
@implementation OrderAlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame{
    //    if (self = [ super initWithFrame:frame]) {
    self = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([OrderAlertView class]) owner:self options:nil] firstObject];
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    self.frame = frame;

    return self;
}

#pragma mark - DatePicker响应事件

- (IBAction)pickViewValueChanged:(UIDatePicker *)sender
{
    NSDate* minimumDate = [[NSDate date] dateByAddingTimeInterval:self.minimumInteval];
    if ([sender.date compare:minimumDate] == NSOrderedAscending) {
        [sender setDate:minimumDate animated:YES];
    }
}



#pragma mark - 回调方法

- (IBAction)OrderChick:(UIButton *)sender {
    if (sender.tag ==1) {
        [self.delegate SettingOrder:self.datepicker.date];
    }else{
        [self.delegate OrderAlertViewHidden];
    }
    
}
@end
