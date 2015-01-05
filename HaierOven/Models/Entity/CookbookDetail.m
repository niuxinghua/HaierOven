//
//  CookbookDetail.m
//  HaierOven
//
//  Created by 刘康 on 14/12/23.
//  Copyright (c) 2014年 origheart. All rights reserved.
//

#import "CookbookDetail.h"

@implementation CookbookDetail

- (instancetype)init
{
    if (self = [super init]) {
        self.oven = [[CookbookOven alloc] init];
    }
    return self;
}

@end
