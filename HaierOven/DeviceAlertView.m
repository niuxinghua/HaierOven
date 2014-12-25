//
//  DeviceAlertView.m
//  HaierOven
//
//  Created by dongl on 14/12/25.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "DeviceAlertView.h"

@implementation DeviceAlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame{
    //    if (self = [ super initWithFrame:frame]) {
    self = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([DeviceAlertView class]) owner:self options:nil] firstObject];
    self.frame = frame;
    self.center = CGPointMake(PageW/2, PageH/2);
    return self;
}

- (IBAction)chickAlert:(UIButton *)sender {
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
}

-(void)setAlertTitle:(NSString *)alertTitle{
    _alertTitle = alertTitle;
    self.alertTitleLabel.text = _alertTitle;
}
-(void)setAlertDescription:(NSString *)alertDescription{
    _alertDescription = alertDescription;
    self.alertDescriptionLabel.text = _alertDescription;
}

-(void)setPickViewArr:(NSArray *)pickViewArr{
    self.pickview.delegate = self;
    self.pickview.dataSource = self;
    [self.pickview selectRow:20 inComponent:0 animated:NO];

    _pickViewArr = pickViewArr;
    [self.pickview reloadAllComponents];
}


-(void)setAlertType:(AlertType)alertType{
    _alertType = alertType;
    switch (_alertType) {
        case alertTime:
            self.alertTitle = @"设置烘烤时长";
            self.alertTitleLabel.frame = CGRectMake(25, 4, self.titleBg.width-30, self.titleBg.height-8);
            self.alertDescription = @"";
            self.pickViewArr = [self getTimeArr];
            break;
        case alertTempture:
            self.alertTitle = @"设置烤箱温度";
            self.alertTitleLabel.frame = CGRectMake(25, 4, self.titleBg.width-30, self.titleBg.height-8);
            self.alertDescription = @"";
            self.pickViewArr = [self getTempArr];

            break;
        case alertClock:
            self.alertTitle = @"设置闹钟";
            self.alertTitleLabel.frame = self.alertTitleLabel.frame;
            self.alertDescription = @"将在时间达到时提醒您";
            self.pickViewArr = [self getTimeArr];

            break;
            
        case alertNeedle:
            self.alertTitle = @"设置探针目标温度";
            self.alertTitleLabel.frame = self.alertTitleLabel.frame;
            self.alertDescription = @"将在探针温度达到目标温度时提醒您";
            self.pickViewArr = [self getTempArr];

            break;
        case alertWormUp:
            NSLog(@"去你妈预热");
            break;
        
            
        default:
            break;
    }
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.pickViewArr.count;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 50;
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    
    UILabel *myView = nil;
    myView = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 20.0, 100, 150)];
    myView.textAlignment = NSTextAlignmentCenter;
    myView.text = [self.pickViewArr objectAtIndex:row];
    myView.font = [UIFont fontWithName:GlobalTitleFontName size:17];         //用label来设置字体大小
    myView.backgroundColor = [UIColor clearColor];
    myView.textColor = [UIColor blackColor];
    return myView;
}


-(NSArray *)getTempArr{
    NSString *temp;
    NSMutableArray *temps = [NSMutableArray new];
    int t = 0 ;
    for ( int i = 0; i<50; i++) {
        t = t+5;
        temp = [NSString stringWithFormat:@"%d°",t];
        [temps addObject:temp];
    }
    return [temps copy];
    
}

-(NSArray *)getTimeArr{
    NSString *minute;
    NSMutableArray *minutes = [NSMutableArray new];
    for ( int i = 0; i<1440; i++) {
        minute = [NSString stringWithFormat:@"%d 分钟",i];
        [minutes addObject:minute];
    }
    
    return [minutes copy];
}

@end
