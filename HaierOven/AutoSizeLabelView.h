//
//  AutoSizeLabelView.h
//  HaierOven
//
//  Created by dongl on 14/12/29.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, AutoSizeLabelViewStyle) {
    AutoSizeLabelViewStyleCreatMenu = 0,        // 项目简介
    AutoSizeLabelViewStyleMenuDetail = 1,     //团队介绍

};
@class AutoSizeLabelView;
@protocol AutoSizeLabelViewDelegate <NSObject>

-(void)chooseTags:(UIButton*)btn;

@end
@interface AutoSizeLabelView : UIView
@property (strong, nonatomic)NSArray *tags;
@property (nonatomic,weak)id<AutoSizeLabelViewDelegate>delegate;
+(float )boolLabelLength:(NSString *)strString
            andAttribute:(NSDictionary *)attribute;
@end
