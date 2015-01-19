//
//  UseBakeView.m
//  HaierOven
//
//  Created by dongl on 15/1/19.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "UseBakeView.h"
@interface UseBakeView()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *submitBakeBtn;
@property (weak, nonatomic) IBOutlet UIPickerView *dataPickView;
@property (strong, nonatomic) NSArray *workModels;
@property (strong, nonatomic) NSArray *temputure;
@property (strong, nonatomic) NSArray *times;
@property (strong, nonatomic) NSString *workmodel;
@property (strong, nonatomic) NSString * tem;
@property (strong, nonatomic) NSString * time;
@end
@implementation UseBakeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame{
    self = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([UseBakeView class]) owner:self options:nil] firstObject];
        self.frame = frame;
        [self initData];
       return self;
}

-(void)initData{
    self.workModels = @[@"功能1",@"功能2",@"功能3",@"功能4",@"功能5",@"功能6",@"功能7",@"功能8",@"功能9"];
    self.temputure = [self getTempArr];
    self.times = [self getMinute];
    
    self.submitBakeBtn.layer.cornerRadius = 10;
    self.submitBakeBtn.layer.masksToBounds = YES;
    self.dataPickView.delegate = self;
    [self.dataPickView selectRow:3 inComponent:0 animated:NO];
    [self.dataPickView selectRow:35 inComponent:1 animated:NO];
    [self.dataPickView selectRow:30 inComponent:2 animated:NO];
    self.time = self.times[30];
    self.tem = self.temputure[35];
    self.workmodel = self.workModels[3];

}


- (IBAction)SubmitUseBake:(id)sender {
    [self.delegate getUseDeviceDataWithWorkModel:self.workmodel andTime:self.time andTemperature:self.tem];
}

#pragma mark- pickviewDelegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    switch (component) {
        case 0:
            return self.workModels.count;
            break;
        case 1:
            return self.temputure.count;
            break;
        case 2:
            return self.times.count;
            break;
        default:
            return 0;
            break;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 50;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    
        UILabel *myView = nil;
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 130)];
        myView.textAlignment = NSTextAlignmentCenter;
        
        myView.font = [UIFont fontWithName:GlobalTitleFontName size:15];         //用label来设置字体大小
        myView.backgroundColor = [UIColor clearColor];
        myView.textColor = [UIColor blackColor];
    switch (component) {
        case 0:
            myView.text = [self.workModels objectAtIndex:row];
            break;
        case 1:
            myView.text = [self.temputure objectAtIndex:row];
            break;
        case 2:
            myView.text = [self.times objectAtIndex:row];
            break;
        default:
            return 0;
            break;
    }

        return myView;
        
}




-(NSArray *)getTempArr{
    NSString *temp;
    NSMutableArray *temps = [NSMutableArray new];
    int t = 0 ;
    for ( int i = 0; i<80; i++) {
        t = t+5;
        temp = [NSString stringWithFormat:@"%d°",t];
        [temps addObject:temp];
    }
    return [temps copy];
    
}

-(NSArray *)getMinute{
    NSString *minute;
    NSMutableArray *minutes = [NSMutableArray new];
    for ( int i = 0; i<240; i++) {
        minute = [NSString stringWithFormat:@"%d",i];
        [minutes addObject:minute];
    }
    
    return [minutes copy];
}


-(void) pickerView: (UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent: (NSInteger)component{

    switch (component) {
        case 0:
            self.workmodel = self.workModels[row];
            break;
        case 1:
            self.tem = self.temputure[row];
            break;
        case 2:
            self.time = self.times[row];
            break;
    }
}


@end
