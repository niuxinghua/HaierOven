//
//  CookbookOven.m
//  HaierOven
//
//  Created by 刘康 on 14/12/29.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "CookbookOven.h"

@implementation CookbookOven

- (instancetype)init
{
    if (self = [super init]) {
        self.roastStyle = @"";
        self.roastTemperature = @"";
        self.roastTime = @"20";
        self.ovenInfo = @{@"name" : @"haha"};
    }
    return self;
}

@end
