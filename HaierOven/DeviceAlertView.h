//
//  DeviceAlertView.h
//  HaierOven
//
//  Created by dongl on 14/12/25.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DeviceAlertView;
@protocol DeviceAlertViewDelegate <NSObject>
-(void)confirm:(NSString *)string
   andAlertTye:(NSInteger)type
        andbtn:(UIButton*)btn;
-(void)cancel;
@end
typedef NS_ENUM(NSInteger, AlertType)
{
    alertTempture =1,
    alertTime = 2,
    alertClock =3,
    alertNeedle  = 4,
    alertOrder = 5,
    alertWormUp = 6
};
@interface DeviceAlertView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>


@property (nonatomic) AlertType alertType;
@property (strong, nonatomic) IBOutlet UILabel *alertTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *alertDescriptionLabel;
@property (strong, nonatomic) IBOutlet UIPickerView *pickview;
@property (strong, nonatomic) IBOutlet UIView *titleBg;
@property (strong, nonatomic) UIButton *btn;
@property (strong, nonatomic) NSString *alertTitle;
@property (strong, nonatomic) NSString *alertDescription;
@property (strong, nonatomic) NSArray *pickViewArr;
@property (strong, nonatomic) NSString *string; //pickerview选完后数字

/**
 *  pickerView显示默认设置的时间 （分钟）
 */
@property (nonatomic) NSInteger defaultSelectTime;

/**
 *  是不是纯蒸模式，因为只有纯蒸模式的温度可调范围是40-110，其他都是50-250
 */
@property (nonatomic) BOOL isChunzheng;

/**
 *  已调整了的温度，弹框时，默认选中此温度
 */
@property (copy, nonatomic) NSString* selectedTemperature;

@property (strong, nonatomic) NSString *hour;
@property (strong, nonatomic) NSString *min;
@property (weak, nonatomic)id<DeviceAlertViewDelegate>delegate;
@property (strong, nonatomic) IBOutlet UILabel *colonLabel;
- (IBAction)chickAlert:(UIButton *)sender;

@end
