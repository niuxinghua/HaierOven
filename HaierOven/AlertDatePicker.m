//
//  AlertDatePicker.m
//  HaierOven
//
//  Created by dongl on 15/1/14.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "AlertDatePicker.h"
@interface AlertDatePicker();
@property (strong, nonatomic) IBOutlet UIDatePicker *myDatePickerView;

@end
@implementation AlertDatePicker

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame{
//    if (self = [super initWithFrame:frame]) {
        self =[[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([AlertDatePicker class]) owner:self options:nil]firstObject];
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
//    }
    return self;
    
}
- (IBAction)ChickDate:(UIButton*)sender {
    if (sender.tag) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *strDate = [dateFormatter stringFromDate:self.myDatePickerView.date];
        [self.delegate ChangeUserBrith:strDate];
    }else{
        [self.delegate UnEdit];
    }
}

-(void)setBirthLabel:(UILabel *)birthLabel{
    _birthLabel = birthLabel;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:birthLabel.text];
    
    [self.myDatePickerView setDate:date animated:YES];
}

@end
