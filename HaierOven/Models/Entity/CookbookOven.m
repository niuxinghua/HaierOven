//
//  CookbookOven.m
//  HaierOven
//
//  Created by 刘康 on 14/12/29.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "CookbookOven.h"

@implementation CookbookOven

- (instancetype)initWithRoastStyle:(NSString*)roastStyle roastTemperature:(NSString*)temperature roastTime:(NSString*)time ovenInfo:(NSDictionary*)ovenInfo
{
    if (self = [super init]) {
        self.roastStyle = roastStyle;
        self.roastTemperature = temperature;
        self.roastTime = time;
        self.ovenInfo = ovenInfo;
    }
    return self;
}



@end
