//
//  DeviceConnectProgressView.m
//  HaierOven
//
//  Created by dongl on 14/12/23.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "DeviceConnectProgressView.h"
#import "LineProgressView.h"

@implementation DeviceConnectProgressView
@synthesize progressView;
-(instancetype)initWithFrame:(CGRect)frame{
        if (self = [ super initWithFrame:frame]) {
    self = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([DeviceConnectProgressView class]) owner:self options:nil] firstObject];
//    self.frame = frame;
            self.center = CGPointMake(PageW/2, PageH/2-50);
        }
    
    self.wifiStatusImage.image = [UIImage animatedImageNamed:@"wifilianjie0" duration:2];
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    progressView = [[LDProgressView alloc] initWithFrame:CGRectMake(20, self.wifiStatusImage.bottom+30, self.frame.size.width-40, 10)];
    progressView.color = GlobalOrangeColor;
    progressView.flat = @YES;
//    progressView.progress = 0.0;
    [progressView setProgress:0.0 andTimeInterval:0.01];
    progressView.animate = @YES;
    progressView.showText = @NO;
    progressView.showStroke = @NO;
    progressView.progressInset = @0;
    progressView.showBackground = @NO;
    progressView.outerStrokeWidth = @0.7;
    progressView.type = LDProgressSolid;
    [self addSubview:progressView];
    
}
@end
