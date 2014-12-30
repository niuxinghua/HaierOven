//
//  AttributedLabel.h
//  TestAttributedString
//
//  Created by 刘康 on 14/10/17.
//  Copyright (c) 2014年 origheart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttributedLabel : UILabel

@property(nonatomic,assign) CGFloat characterSpacing;
@property(nonatomic,assign) long    linesSpacing;

/*
 *绘制前获取text高度
 */
- (int)getAttributedStringHeightWidthValue:(int)width;

@end
