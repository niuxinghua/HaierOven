//
//  StudyCookPartOne.m
//  HaierOven
//
//  Created by dongl on 15/1/27.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "StudyCookPartOne.h"
#import "StudyCookTools.h"
#import "StudyCookImages.h"
@implementation StudyCookPartOne
-(StudyCookPartOne*)GetStudyCookPartOne:(NSArray*)data{
    self.title = data[0];
    NSMutableArray *tempArr = [NSMutableArray new];
    for (int i = 1; i<data.count; i++) {
        StudyCookTools *tool = [StudyCookTools new];
        tool.desc           = data[i][@"descriptions"];
        tool.name           = data[i][@"name"];
        tool.images         = [NSMutableArray new];
        NSArray  *arr       = data[i][@"images"];
        for (int j= 0; j<arr.count; j++) {
            StudyCookImages *images = [StudyCookImages new];
            images.imageName = arr[j][@"image"];
             NSNumber *rect = arr[j][@"imageRect"];
            images.imageRect = [rect floatValue];
            [tool.images addObject:images];
        }
//        NSNumber *rect      = data[i][@"imageRect"];
//        tool.imageRect      = [rect floatValue];
        
        [tempArr addObject:tool];
    }
    self.tools = [tempArr mutableCopy];
    return self;
}
@end
