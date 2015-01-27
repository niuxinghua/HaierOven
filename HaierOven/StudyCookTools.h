//
//  StudyCookTools.h
//  HaierOven
//
//  Created by dongl on 15/1/27.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StudyCookTools : NSObject
@property (strong, nonatomic) NSString *desc;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSMutableArray *images;
@property (nonatomic) CGFloat imageRect;

-(CGFloat)getHeight;
@end
