//
//  AttributedString.m
//  TestAttributedString
//
//  Created by 刘康 on 14/10/17.
//  Copyright (c) 2014年 origheart. All rights reserved.
//

#import "AttributedString.h"

#import <CoreText/CoreText.h>

@implementation AttributedString

+ (NSMutableAttributedString*)attributedStringWithText:(NSString*)text andFont:(UIFont*)font andTextColor:(UIColor*)textColor andChapterSpacing:(NSInteger)characterSpacing andLinesSpacing:(CGFloat)lineSpace
{
        //去掉空行
        text = [text stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\n"];
        
        //创建AttributeString
        NSMutableAttributedString* attributedString =[[NSMutableAttributedString alloc] initWithString:text];
        
        //设置字体及大小
        CTFontRef helveticaBold = CTFontCreateWithName((CFStringRef)font.fontName,font.pointSize,NULL);
        [attributedString addAttribute:(id)kCTFontAttributeName value:(__bridge id)helveticaBold range:NSMakeRange(0,[attributedString length])];
        
        //设置字间距
        CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&characterSpacing);
        [attributedString addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0,[attributedString length])];
        CFRelease(num);

        
        
        //设置字体颜色
        [attributedString addAttribute:(id)kCTForegroundColorAttributeName value:(id)(textColor.CGColor) range:NSMakeRange(0,[attributedString length])];
        
        //创建文本对齐方式
//        CTTextAlignment alignment = kCTLeftTextAlignment;
//        
//        CTParagraphStyleSetting alignmentStyle;
//        
//        alignmentStyle.spec = kCTParagraphStyleSpecifierAlignment;
//        
//        alignmentStyle.valueSize = sizeof(alignment);
//        
//        alignmentStyle.value = &alignment;
    
        //设置文本行间距
        CTParagraphStyleSetting lineSpaceStyle;
        lineSpaceStyle.spec = kCTParagraphStyleSpecifierLineSpacingAdjustment;
        lineSpaceStyle.valueSize = sizeof(lineSpace);
        lineSpaceStyle.value =&lineSpace;
        
        //设置文本段间距
        CGFloat paragraphSpacing = 15.0;
        CTParagraphStyleSetting paragraphSpaceStyle;
        paragraphSpaceStyle.spec = kCTParagraphStyleSpecifierParagraphSpacing;
        paragraphSpaceStyle.valueSize = sizeof(CGFloat);
        paragraphSpaceStyle.value = &paragraphSpacing;
        
        //创建设置数组
        CTParagraphStyleSetting settings[ ] ={/*alignmentStyle,*/lineSpaceStyle,paragraphSpaceStyle};
        CTParagraphStyleRef style = CTParagraphStyleCreate(settings ,3);
        
        //给文本添加设置
        [attributedString addAttribute:(id)kCTParagraphStyleAttributeName value:(__bridge id)style range:NSMakeRange(0 , [attributedString length])];
        CFRelease(helveticaBold);
        
    return attributedString;
}

/*
 *绘制前获取label高度
 */
+ (int)getAttributedStringHeightWithAttributedString:(NSAttributedString*)attributedString andWidth:(int)width
{
    
    int total_height = 0;
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);    //string 为要计算高度的NSAttributedString
    CGRect drawingRect = CGRectMake(0, 0, width, 100000);  //这里的高要设置足够大
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, drawingRect);
    CTFrameRef textFrame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0,0), path, NULL);
    CGPathRelease(path);
    CFRelease(framesetter);
    
    NSArray *linesArray = (NSArray *) CTFrameGetLines(textFrame);
    
    CGPoint origins[[linesArray count]];
    CTFrameGetLineOrigins(textFrame, CFRangeMake(0, 0), origins);
    
    int line_y = (int) origins[[linesArray count] -1].y;  //最后一行line的原点y坐标
    
    CGFloat ascent;
    CGFloat descent;
    CGFloat leading;
    
    CTLineRef line = (__bridge CTLineRef) [linesArray objectAtIndex:[linesArray count]-1];
    CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    
    total_height = 100000 - line_y + (int) descent +1;//+1为了纠正descent转换成int小数点后舍去的值
    
    CFRelease(textFrame);
    
    return total_height;
    
}

@end
