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

@end

@interface DeviceAlertView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>

typedef NS_ENUM(NSInteger, AlertType)
{
    alertTempture =1,
    alertTime = 2,
    alertClock =3,
    alertNeedle  = 4,
    alertWormUp = 5
};
@property (nonatomic) AlertType alertType;

@property (strong, nonatomic) IBOutlet UILabel *alertTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *alertDescriptionLabel;
@property (strong, nonatomic) IBOutlet UIPickerView *pickview;
@property (strong, nonatomic) IBOutlet UIView *titleBg;

@property (strong, nonatomic) NSString *alertTitle;
@property (strong, nonatomic) NSString *alertDescription;
@property (strong, nonatomic) NSArray *pickViewArr;

@property (weak, nonatomic)id<DeviceAlertViewDelegate>delegate;
- (IBAction)chickAlert:(UIButton *)sender;

@end
