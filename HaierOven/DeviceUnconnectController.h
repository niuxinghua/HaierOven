//
//  DeviceUnconnectController.h
//  HaierOven
//
//  Created by dongl on 14/12/23.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DeviceUnconnectControllerDelegate <NSObject>

@required
- (void)bindOvenAgainWithMac:(NSString*)mac;

@end

@interface DeviceUnconnectController : UIViewController

@property (strong, nonatomic) LocalOven* currentOven;
@property (weak, nonatomic) id<DeviceUnconnectControllerDelegate> delegate;

@end
