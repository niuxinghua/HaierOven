//
//  MyTool.m
//  众筹
//
//  Created by 刘康 on 14/11/17.
//  Copyright (c) 2014年 origheart. All rights reserved.
//

#import "MyTool.h"
#import <CommonCrypto/CommonDigest.h>

@implementation MyTool


+(MyTool *)sharedInstance
{
    static MyTool *instance = nil;
    static dispatch_once_t token;
    
    dispatch_once(&token, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

//判断是否是整形
+ (BOOL)isPureInt:(NSString *)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

//判断是否是浮点型
+ (BOOL)isPureFloat:(NSString *)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}

//判断是否是手机号码是否合法
+ (BOOL)validateTelephone:(NSString *)str
{
    @try {
        //1[0-9]{10}
        //^((13[0-9])|(15[^4,\\D])|(18[0,5-9]))\\d{8}$
        //    NSString *regex = @"[0-9]{11}";
        str = [NSString stringWithFormat:@"%@", str];
        NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,2,5-9]))\\d{8}$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        BOOL isMatch = [pred evaluateWithObject:str];
        return isMatch;
    }
    @catch (NSException *exception) {
        return NO;
    }
    @finally {
        
    }
    
}

//判断邮箱地址是否合法
+ (BOOL)validateEmail: (NSString *) candidate
{
    @try {
        candidate = [NSString stringWithFormat:@"%@", candidate];
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        return [emailTest evaluateWithObject:candidate];
    }
    @catch (NSException *exception) {
        return NO;
    }
    @finally {
        
    }
    
}

#pragma mark －获取当前系统的时间
+(NSString*)getCurrentTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm"];
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    return dateString;
}


/***************  金额小写转大写 start  ****************/
+(NSString *)converter:(NSString *)numStr
{//转换中文大写数字
    NSString *rel = nil;
    NSString *intStr = nil;
    NSString *floatStr1 = nil;
    NSString *floatStr2 = nil;
    NSRange range = [numStr rangeOfString:@"."];
    if (range.location != NSNotFound) {
        NSString *dStr = [numStr substringFromIndex:range.location+1];
        floatStr1 = [dStr substringToIndex:1];
        if (dStr.length == 2) {
            floatStr2 = [dStr substringFromIndex:1];
        }
        intStr = [numStr substringToIndex:range.location];
    }else{
        intStr = numStr;
    }
    
    NSString *topstr=[intStr stringByReplacingOccurrencesOfString:@"," withString:@""];//过滤逗号
    int numl=[topstr length];//确定长度
    NSString *cache;//缓存
    if ((numl==2||numl==6)&&[topstr hasPrefix:@"1"] ){//十位或者万位为一时候
        cache=@"拾";
        for (int i=1; i<numl; i++) {
            cache=[NSString stringWithFormat:@"%@%@",cache,[self bit:topstr thenum:i]];
        }
    }else{//其他
        cache=@"";
        for (int i=0; i<numl; i++) {
            cache=[NSString stringWithFormat:@"%@%@",cache,[self bit:topstr thenum:i]];
        }
    }//转换完大写
    rel = @"";
    if (![cache isEqualToString:@""]) {
        cache=[cache substringWithRange:NSMakeRange(0, [cache length]-1)];
    }else
    {
        cache = @"0";
    }
    for (int i=[cache length]; i>0; i--) {//擦屁股，如果尾部为0就擦除
        if ([cache hasSuffix:@"零"]) {
            cache=[cache substringWithRange:NSMakeRange(0, i-1)];
        }else{
            continue;
        }
    }
    for (int i=[cache length]; i>0; i--) {//重复零，删零
        NSString *a=[cache substringWithRange:NSMakeRange(i-1, 1)];
        NSString *b=[cache substringWithRange:NSMakeRange(i-2, 1)];
        if (!([a isEqualToString:b]&&[a isEqualToString:@"零"])) {
            rel = [NSString stringWithFormat:@"%@%@",a,rel];
        }
        cache=[cache substringWithRange:NSMakeRange(0, i-1)];
    }
    cache = rel;
    rel = @"元";
    for (int i=[cache length]; i>0; i--) {//去掉 “零万” 和 “亿万”
        NSString *a=[cache substringWithRange:NSMakeRange(i-1, 1)];
        NSString *b=[cache substringWithRange:NSMakeRange(i-2, 1)];
        if ([a isEqualToString:@"万"]&&[b isEqualToString:@"零"]) {
            NSString *c=[cache substringWithRange:NSMakeRange(i-3, 1)];
            if ([c isEqualToString:@"亿"]){
                rel = [NSString stringWithFormat:@"%@%@",c,rel];
                cache=[cache substringWithRange:NSMakeRange(0, i-3)];
                i=i-2;
            }else{
                rel = [NSString stringWithFormat:@"%@%@",a,rel];
                cache=[cache substringWithRange:NSMakeRange(0, i-2)];
                i--;
            }
        }else{
            rel = [NSString stringWithFormat:@"%@%@",a,rel];
        }
        cache=[cache substringWithRange:NSMakeRange(0, i-1)];
    }
    
    if ([rel isEqualToString:@"元"]) {
        rel=@"零元";
    }
    
    
    if (floatStr1!=nil ) {
        if (floatStr2!=nil && ![floatStr2 isEqualToString:@"0"]) {
            rel = [NSString stringWithFormat:@"%@%@角%@分",rel,[self NumtoCN:floatStr1 site:0],[self NumtoCN:floatStr2 site:0]];
        }else{
            if (![floatStr1 isEqualToString:@"0"]) {
                rel = [NSString stringWithFormat:@"%@%@角",rel,[self NumtoCN:floatStr1 site:0]];
            }
        }
    }
    
    return rel;
}


+(NSString*)NumtoCN:(NSString*)string site:(int)site
{//阿拉伯数字转中文大写
    if ([string isEqualToString:@"0"]) {
        if (site==5) {
            return @"万零";
        }else{
            return @"零";
        }
    }else if ([string isEqualToString:@"1"]) {
        string=@"壹";
    }else if ([string isEqualToString:@"2"]) {
        string=@"贰";
    }else if ([string isEqualToString:@"3"]) {
        string=@"叁";
    }else if ([string isEqualToString:@"4"]) {
        string=@"肆";
    }else if ([string isEqualToString:@"5"]) {
        string=@"伍";
    }else if ([string isEqualToString:@"6"]) {
        string=@"陆";
    }else if ([string isEqualToString:@"7"]) {
        string=@"柒";
    }else if ([string isEqualToString:@"8"]) {
        string=@"捌";
    }else if ([string isEqualToString:@"9"]) {
        string=@"玖";
    }
    
    
    switch (site) {
        case 1:
            return [NSString stringWithFormat:@"%@元",string];
            break;
        case 2:
            return [NSString stringWithFormat:@"%@拾",string];
            break;
        case 3:
            return [NSString stringWithFormat:@"%@佰",string];
            break;
        case 4:
            return [NSString stringWithFormat:@"%@仟",string];
            break;
        case 5:
            return [NSString stringWithFormat:@"%@万",string];
            break;
        case 6:
            return [NSString stringWithFormat:@"%@拾",string];
            break;
        case 7:
            return [NSString stringWithFormat:@"%@佰",string];
            break;
        case 8:
            return [NSString stringWithFormat:@"%@仟",string];
            break;
        case 9:
            return [NSString stringWithFormat:@"%@亿",string];
            break;
        default:
            return string;
            break;
    }
}

+(NSString*)bit:(NSString*)string thenum:(int)num
{//取位转大写
    int site=[string length]-num;
    string=[string stringByReplacingOccurrencesOfString:@"," withString:@""];
    //    NSLog(@"传入字符串%@，总长度%d,传入位%d",string,[string length],num);
    string=[string substringWithRange:NSMakeRange(num,1)];
    string=[self NumtoCN:string site:site];
    //    NSLog(@"转换后:%@",string);
    return string;
    
}

+ (NSString *)stringToMD5:(NSString *)str
{
    
    const char *cStr = [str UTF8String];//转换成utf-8
    
    unsigned char result[16];//开辟一个16字节（128位：md5加密出来就是128位/bit）的空间（一个字节=8字位=8个二进制数）
    
    CC_MD5( cStr, strlen(cStr), result);
    
    /*
     
     extern unsigned char *CC_MD5(const void *data, CC_LONG len, unsigned char *md)官方封装好的加密方法
     
     把cStr字符串转换成了32位的16进制数列（这个过程不可逆转） 存储到了result这个空间中
     
     */
    
    return [NSString stringWithFormat:
            
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            
            result[0], result[1], result[2], result[3],
            
            result[4], result[5], result[6], result[7],
            
            result[8], result[9], result[10], result[11],
            
            result[12], result[13], result[14], result[15]
            
            ];
    
    /*
     
     x表示十六进制，%02X  意思是不足两位将用0补齐，如果多余两位则不影响
     
     NSLog("%02X", 0x888);  //888
     
     NSLog("%02X", 0x4); //04
     
     */
    
}


+ (UIImage*)createImageWithColor:(UIColor*)color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+ (float)heightForTextView:(UITextView *)textView WithText:(NSString *)strText
{
    
    float fPadding = 16.0; // 8.0px x 2
    
    CGSize constraint = CGSizeMake(textView.contentSize.width - fPadding, CGFLOAT_MAX);
    
    CGSize size = [strText sizeWithFont: textView.font constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    float fHeight = size.height + 16.0;
    
    return fHeight;
    
}

+ (NSAttributedString*)getAttributedStringWithHTMLString:(NSString *)htmlString
{
    return [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
}

+ (NSString *)formattedDateDescription:(NSDate*)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *theDay = [dateFormatter stringFromDate:date];//日期的年月日
    NSString *currentDay = [dateFormatter stringFromDate:[NSDate date]];//当前年月日
    
    NSInteger timeInterval = -[date timeIntervalSinceNow];
    if (timeInterval < 60) {
        return @"1分钟内";
    } else if (timeInterval < 3600) {//1小时内
        return [NSString stringWithFormat:@"%ld分钟前", timeInterval / 60];
    } else if (timeInterval < 21600) {//6小时内
        return [NSString stringWithFormat:@"%ld小时前", timeInterval / 3600];
    } else if ([theDay isEqualToString:currentDay]) {//当天
        [dateFormatter setDateFormat:@"HH:mm"];
        return [NSString stringWithFormat:@"今天"];
    } else if ([[dateFormatter dateFromString:currentDay] timeIntervalSinceDate:[dateFormatter dateFromString:theDay]] == 86400) {//昨天
        [dateFormatter setDateFormat:@"HH:mm"];
        return [NSString stringWithFormat:@"昨天"];
    } else {//以前
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        return [dateFormatter stringFromDate:date];
    }
}

+ (NSString *)intervalSinceNow: (NSDate *)theDate
{
    NSString *timeString=@"";
//    NSDateFormatter *format=[[NSDateFormatter alloc] init];
//    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSDate *fromdate=[format dateFromString:theDate];
    NSTimeZone *fromzone = [NSTimeZone systemTimeZone];
    NSInteger frominterval = [fromzone secondsFromGMTForDate: theDate];
    NSDate *fromDate = [theDate dateByAddingTimeInterval: frominterval];
    //获取当前时间
    NSDate *adate = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: adate];
    NSDate *localeDate = [adate dateByAddingTimeInterval: interval];
    
    double intervalTime = [fromDate timeIntervalSinceReferenceDate] - [localeDate timeIntervalSinceReferenceDate];
    long lTime = fabs((long)intervalTime);
    NSInteger iSeconds = lTime % 60;
    NSInteger iMinutes = (lTime / 60) % 60;
    NSInteger iHours = fabs(lTime/3600);
    NSInteger iDays = lTime/60/60/24;
    NSInteger iMonth =lTime/60/60/24/12;
    NSInteger iYears = lTime/60/60/24/384;
    
//    NSLog(@"相差%d年%d月 或者 %d日%d时%d分%d秒", iYears,iMonth,iDays,iHours,iMinutes,iSeconds);
    if (iMinutes < 1 && iSeconds >0) {
        timeString = @"刚刚";
    }
    else if (iHours<1 && iMinutes>0)
    {
        timeString=[NSString stringWithFormat:@"%d分前",iMinutes];
        
    }else if (iHours>0&&iDays<1 && iMinutes>0) {
        timeString=[NSString stringWithFormat:@"%d小时前",iHours/*,iMinutes*/];
    }
    else if (iHours>0&&iDays<1) {
        timeString=[NSString stringWithFormat:@"%d小时前",iHours];
    }else if (iDays>0 && iHours>0)
    {
        timeString=[NSString stringWithFormat:@"%d天前",iDays/*iHours*/];
    }
    else if (iDays>0)
    {
        timeString=[NSString stringWithFormat:@"%d天",iDays];
    }
    return timeString;
}


@end



