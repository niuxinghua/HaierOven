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

@property (weak, nonatomic) IBOutlet UILabel *selectedTimeLabel;

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

- (void)setDefaultDate
{
    NSDate* minimumDate = [[NSDate date] dateByAddingTimeInterval:self.minimumInteval];
    [self.datepicker setDate:minimumDate animated:YES];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM月dd日 HH:mm";
    self.selectedTimeLabel.text = [formatter stringFromDate:minimumDate];
}

- (void)setSelectedDate:(NSDate *)selectedDate
{
    _selectedDate = selectedDate;
    if (selectedDate != nil) {
        [self.datepicker setDate:selectedDate];
    }
}

#pragma mark - DatePicker响应事件

- (IBAction)pickViewValueChanged:(UIDatePicker *)sender
{
    NSDate* minimumDate = [[NSDate date] dateByAddingTimeInterval:self.minimumInteval];
    
    // 选择的时间前后不能超过12小时
    //NSTimeInterval inteval = [sender.date timeIntervalSinceDate:minimumDate];
    
    NSDate* maxDate = [[NSDate date] dateByAddingTimeInterval:/*self.minimumInteval + */12 * 60 * 60];
    
    
    if ([sender.date compare:minimumDate] == NSOrderedAscending) {
        [sender setDate:minimumDate animated:YES];
    }
    
    if ([sender.date compare:maxDate] == NSOrderedDescending) {
        [sender setDate:maxDate animated:YES];
    }
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM月dd日 HH:mm";
    
    self.selectedTimeLabel.text = [formatter stringFromDate:sender.date];
}



#pragma mark - 回调方法

- (IBAction)OrderChick:(UIButton *)sender
{
    if (sender.tag ==1) {
        
        // 点击确定时必须确认时间
        NSDate* minimumDate = [[NSDate date] dateByAddingTimeInterval:self.minimumInteval];
        if ([self.datepicker.date compare:minimumDate] == NSOrderedAscending) {
            [self.datepicker setDate:minimumDate animated:YES];
        }

        NSDate* maxDate = [[NSDate date] dateByAddingTimeInterval:/*self.minimumInteval + */12 * 60 * 60];
        if ([self.datepicker.date compare:maxDate] == NSOrderedDescending) {
            [self.datepicker setDate:maxDate animated:YES];
        }
        
        [self.delegate SettingOrder:self.datepicker.date sender:sender];
    }else{
        [self.delegate OrderAlertViewHidden];
    }
    
}



@end



