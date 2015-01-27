//
//  StudyCookPartOne.h
//  HaierOven
//
//  Created by dongl on 15/1/27.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface StudyCookPartOne : NSObject
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSArray *tools;

-(StudyCookPartOne*)GetStudyCookPartOne:(NSArray*)data;
@end
