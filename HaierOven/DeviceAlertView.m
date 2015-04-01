//
//  DeviceAlertView.m
//  HaierOven
//
//  Created by dongl on 14/12/25.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "DeviceAlertView.h"
@interface DeviceAlertView()
@property (strong, nonatomic)NSArray *arrHours;
@property (strong, nonatomic)NSArray *arrMins;
@end
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
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    self.frame = frame;
    self.arrHours = [self gethourArr];
    self.arrMins = [self getMinute];
    self.pickview.delegate = self;
    self.pickview.dataSource = self;
    [self.pickview selectRow:10 inComponent:0 animated:NO];
    self.colonLabel.hidden = YES;
    return self;
}

- (IBAction)chickAlert:(UIButton *)sender {
    switch (sender.tag) {
        case 1:
            if (self.alertType == alertOrder) {
                self.string = [NSString stringWithFormat:@"%@:%@",self.hour,self.min];
            } else {
                self.string = self.pickViewArr[[self.pickview selectedRowInComponent:0]];
            }
            
            [self.delegate confirm:self.string andAlertTye:_alertType andbtn:self.btn];
            break;
        case 2:
            [self.delegate cancel];
            break;
            
        default:
            break;
    }
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
    _pickViewArr = pickViewArr;
    [self.pickview reloadAllComponents];
}

- (void)setSelectedTemperature:(NSString *)selectedTemperature
{
    _selectedTemperature = selectedTemperature;
    
    // 取出行数
    NSInteger index = 0;
    if (self.alertType == alertTempture || self.alertType == alertNeedle || self.alertType == alertWormUp) {
        
        for (NSString* tempStr in self.pickViewArr) {
            if ([tempStr isEqualToString:selectedTemperature]) {
                index = [self.pickViewArr indexOfObject:tempStr];
                break;
            }
        }
        
        if (self.selectedTemperature == nil) {
            self.string = [self.pickViewArr firstObject];
        }
        
        [self.pickview selectRow:index inComponent:0 animated:NO];
    }
    
}

- (void)setDefaultSelectTime:(NSInteger)defaultSelectTime
{
    _defaultSelectTime = defaultSelectTime;
    
    // 取出行数
    NSInteger index = 0;
    if (self.alertType == alertTime) {
        for (NSString* timeStr in self.pickViewArr) {
            if ([timeStr hasPrefix:[NSString stringWithFormat:@"%d", defaultSelectTime]]) {
                index = [self.pickViewArr indexOfObject:timeStr];
                self.string = timeStr;
                break;
            }
        }
    }
    [self.pickview selectRow:index inComponent:0 animated:NO];
}

-(void)setAlertType:(AlertType)alertType
{
    _alertType = alertType;
    switch (_alertType) {
        case alertTime:
            self.alertTitle = @"设置烘烤时长";
            self.alertTitleLabel.frame = CGRectMake(25, 4, self.titleBg.width-30, self.titleBg.height-8);
            self.alertDescription = @"";
            self.pickViewArr = [self getTimeArr];
            
            [self.pickview selectRow:self.defaultSelectTime - 1 inComponent:0 animated:NO];
            
            if (self.defaultSelectTime != 0) {
                self.string = self.pickViewArr[self.defaultSelectTime - 1];
            }
            
            break;
            
        case alertTempture:
            self.alertTitle = @"设置烤箱温度";
            self.alertTitleLabel.frame = CGRectMake(25, 4, self.titleBg.width-30, self.titleBg.height-8);
            self.alertDescription = @"";
            self.pickViewArr = [self getTempArr];
            [self.pickview selectRow:0 inComponent:0 animated:NO];
            
            break;
            
        case alertClock:
            self.alertTitle = @"设置闹钟";
            self.alertTitleLabel.frame = CGRectMake(25, 4, self.titleBg.width-30, 21);
            self.alertDescription = @"将在时间达到时提醒您";
            self.pickViewArr = [self getTimeArr];
            self.string = [self.pickViewArr firstObject];
            break;
            
        case alertNeedle:
            self.alertTitle = @"设置探针目标温度";
            self.alertTitleLabel.frame = CGRectMake(25, 4, self.titleBg.width-30, 21);
            self.alertDescription = @"将在探针温度达到目标温度时提醒您";
            self.pickViewArr = [self getCheckTemperatureArr];
            [self.pickview selectRow:0 inComponent:0 animated:NO];
            break;
            
        case alertWormUp:
            self.alertTitle = @"设置预热目标温度";
            self.alertTitleLabel.frame = CGRectMake(25, 4, self.titleBg.width-30, 21);
            self.alertDescription = @"将在烤箱内温度达到目标温度时提醒您";
            self.pickViewArr = [self getWarmUpTempArr];
            [self.pickview selectRow:0 inComponent:0 animated:NO];
            break;
            
        case alertOrder:
            self.alertTitle = @"设置预约开始时间";
            self.alertTitleLabel.frame = CGRectMake(25, 4, self.titleBg.width-30, 21);
            self.alertDescription = @"将在预约时间开始工作";
            [self.pickview reloadAllComponents];
            
            self.colonLabel.hidden = NO;

            break;
            
        default:
            break;
    }
}


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return self.alertType==alertOrder?2:1;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    if (self.alertType == alertOrder) {
        return component==0?25:61;
    }else
    return self.pickViewArr.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 50;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    if (self.alertType == alertOrder) {
        
        UILabel *myView = nil;
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 150)];
        myView.textAlignment = NSTextAlignmentCenter;
        
        myView.font = [UIFont fontWithName:GlobalTitleFontName size:17];         //用label来设置字体大小
        myView.backgroundColor = [UIColor clearColor];
        myView.textColor = [UIColor blackColor];
        if (component ==0) {
            myView.text = [self.arrHours objectAtIndex:row];
        }else {
            myView.text = [self.arrMins objectAtIndex:row];
        }
        return myView;

    }else{
    
        UILabel *myView = nil;
        myView = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 20.0, 100, 150)];
        myView.textAlignment = NSTextAlignmentCenter;
        myView.text = [self.pickViewArr objectAtIndex:row];
        myView.font = [UIFont fontWithName:GlobalTitleFontName size:17];         //用label来设置字体大小
        myView.backgroundColor = [UIColor clearColor];
        myView.textColor = [UIColor blackColor];
        return myView;

    }
}


-(void) pickerView: (UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent: (NSInteger)component{

    if (self.alertType == alertOrder) {
        if (component==0)
            self.hour = [NSString stringWithFormat:@"%i",row];
        else
            self.min = [NSString stringWithFormat:@"%i",row];
    }else
        self.string = self.pickViewArr[row];
}


- (NSArray*)getCheckTemperatureArr
{
    NSString *temp;
    NSMutableArray *temps = [NSMutableArray new];
    int t = 0 ;
    for ( int i = 74; i < 95; i++) {   //探针温度75°-95°，调整单位是1°
        t = i+1;
        temp = [NSString stringWithFormat:@"%d°",t];
        [temps addObject:temp];
    }
    return [temps copy];
}

- (NSArray*)getWarmUpTempArr
{
    NSString *temp;
    NSMutableArray *temps = [NSMutableArray new];
    int t = 0 ;
    
        for ( int i = 0; i <= 49; i++) {   //快速预热：5—250
            t = t+5;
            temp = [NSString stringWithFormat:@"%d°",t];
            [temps addObject:temp];
        }
    
    return [temps copy];
}

-(NSArray *)getTempArr
{
    NSString *temp;
    NSMutableArray *temps = [NSMutableArray new];
    int t = 0 ;
    
    if (!self.isChunzheng) {
        t = 45;
        for ( int i = 50; i <= 90; i++) {   //烘烤温度上限是300°，调整单位是5°
            t = t+5;
            temp = [NSString stringWithFormat:@"%d°",t];
            [temps addObject:temp];
        }
        return [temps copy];
    } else {
        t = 35;
        for ( int i = 40; i <= 54; i++) {   //纯蒸模式
            t = t+5;
            temp = [NSString stringWithFormat:@"%d°",t];
            [temps addObject:temp];
        }
        return [temps copy];
    }
    
    
    
}

-(NSArray *)getTimeArr{
    NSString *minute;
    NSMutableArray *minutes = [NSMutableArray new];
    for ( int i = 1; i <= 180; i++) {  //烘烤时间上限是150分钟，调整单位是1分钟，从1分钟开始
        minute = [NSString stringWithFormat:@"%d 分钟",i];
        [minutes addObject:minute];
    }
    
    return [minutes copy];
}

-(NSArray*)gethourArr{
    NSString *hour;
    NSMutableArray *minutes = [NSMutableArray new];
    for ( int i = 0; i<25; i++) {
        hour = [NSString stringWithFormat:@"%d",i];
        [minutes addObject:hour];
    }
    return [minutes copy];
}

-(NSArray *)getMinute{
    NSString *minute;
    NSMutableArray *minutes = [NSMutableArray new];
    for ( int i = 0; i<61; i++) {
        minute = [NSString stringWithFormat:@"%d",i];
        [minutes addObject:minute];
    }
    
    return [minutes copy];
}


@end
