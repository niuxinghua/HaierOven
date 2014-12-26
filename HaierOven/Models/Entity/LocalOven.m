//
//  LocalOven.m
//  HaierOven
//
//  Created by 刘康 on 14/12/26.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "LocalOven.h"

@implementation LocalOven

- (NSString *)name
{
    if (_name == nil) {
        _name = @"我的烤箱";
    }
    return _name;
}

+ (LocalOven *)localOvenWithDictionary:(NSDictionary *)dict
{
    LocalOven* oven = [[LocalOven alloc] init];
    
    oven.name           = dict[@"name"];
    oven.ip             = dict[@"ip"];
    oven.mac            = dict[@"mac"];
    oven.typeIdentifier = dict[@"typeIdentifier"];
    oven.attribute      = dict[@"attribute"];
    
    return oven;
}

- (NSDictionary *)toDictionary
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    
    dict[@"name"]           = self.name;
    dict[@"ip"]             = self.ip;
    dict[@"mac"]            = self.mac;
    dict[@"typeIdentifier"] = self.typeIdentifier;
    dict[@"attribute"]      = self.attribute;
    
    return dict;
}


@end
