//
//  AttributedString.h
//  TestAttributedString
//
//  Created by 刘康 on 14/10/17.
//  Copyright (c) 2014年 origheart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AttributedString : NSObject

+ (NSMutableAttributedString*)attributedStringWithText:(NSString*)text andFont:(UIFont*)font andTextColor:(UIColor*)textColor andChapterSpacing:(NSInteger)characterSpacing andLinesSpacing:(CGFloat)lineSpace;
+ (int)getAttributedStringHeightWithAttributedString:(NSAttributedString*)attributedString andWidth:(int)width;

@end
