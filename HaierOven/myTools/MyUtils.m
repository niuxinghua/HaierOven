//
//  MyUtils.m
//  追爱行动
//
//  Created by 刘康 on 14-10-10.
//  Copyright (c) 2014年 origheart. All rights reserved.
//

#import "MyUtils.h"

@implementation MyUtils

+ (CGSize)getTextSizeWithText:(NSString*)text andTextAttribute:(NSDictionary*)attribute andTextWidth:(CGFloat)width
{
    CGSize size = [text boundingRectWithSize:CGSizeMake(width, 0) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return size;
}

@end

