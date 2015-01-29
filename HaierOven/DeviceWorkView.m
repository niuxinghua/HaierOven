//
//  DeviceWorkView.m
//  HaierOven
//
//  Created by dongl on 14/12/24.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "DeviceWorkView.h"
@interface DeviceWorkView ()
@property CGFloat x;
@property CGFloat y;
@property float radius;
@end
@implementation DeviceWorkView

@synthesize lineProgressView;
@synthesize x;
@synthesize y;
@synthesize radius;
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self InitLineProgressLayer];
        [self InitTimeLabel];
        [self InitDecorateLabel];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self InitLineProgressLayer];
        [self InitTimeLabel];
        [self InitDecorateLabel];
        
    }
    return self;
}

-(instancetype)init{
    if (self = [super init]) {
        [self InitLineProgressLayer];
        [self InitTimeLabel];
        [self InitDecorateLabel];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.backgroundColor = [UIColor clearColor];
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    UIBezierPath* path = [UIBezierPath bezierPath];
//    [path moveToPoint:CGPointMake(10, 20)];
//    CGFloat x0 = (self.width - 2*radius)/2.0 + radius;
//    CGFloat y0 = (self.height - 2*radius)/2.0 + radius;
    
    [path addArcWithCenter:CGPointMake(x, y)
                    radius:radius-2
                startAngle:M_PI * 0.72  //开始弧度
                  endAngle:M_PI * 2.28
                 clockwise:YES];
    path.lineWidth = 2;
    [GlobalOrangeColor setStroke];
    [path stroke];
    
    CGContextRestoreGState(context);
}
-(void)InitLineProgressLayer{
     x = (self.width - 2*radius)/2.0 + radius;
     y = (self.height - 2*radius)/2.0 + radius;
    radius = self.width/2;

    lineProgressView = [[LineProgressView alloc] initWithFrame:CGRectMake(0,0, self.width, self.height)];
//    lineProgressView.backgroundColor = [UIColor colorWithPatternImage:IMAGENAMED(@"boardbg")];
    lineProgressView.delegate = self;
    lineProgressView.total = 80;
    lineProgressView.color = GlobalOrangeColor;
    lineProgressView.radius = radius-5;
    lineProgressView.innerRadius = 93;
    lineProgressView.completedColor = [UIColor lightGrayColor];
    lineProgressView.endAngle = M_PI * 0.72;
    lineProgressView.startAngle = M_PI * 2.28;
//    lineProgressView.animationDuration = 8;
    lineProgressView.layer.shouldRasterize = YES;
    lineProgressView.backgroundColor = [UIColor clearColor];

//    lineProgressView.completed = 15;
    [self addSubview:lineProgressView];
//    [lineProgressView setCompleted:1.0*lineProgressView.total animated:YES];
}
-(void)InitTimeLabel{
    self.timeLabel = [UILabel new];
    self.timeLabel.frame = CGRectMake(0, 0, self.width-25, self.height-25);
    self.timeLabel.center = CGPointMake(self.width/2, self.height/2);
    self.timeLabel.layer.cornerRadius = self.timeLabel.width/2;
    self.timeLabel.layer.masksToBounds = YES;
    self.timeLabel.backgroundColor = [UIColor blackColor];
    self.timeLabel.textColor = [UIColor whiteColor];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
//    self.timeLabel.text = @"22.49";
    self.timeLabel.font = [UIFont fontWithName:GlobalTitleFontName size:16];
    [self addSubview:self.timeLabel];
    
}
-(void)InitDecorateLabel{
    UILabel *decoratelabel = [UILabel new];
    decoratelabel.frame = CGRectMake(self.width/2-22.5, self.timeLabel.bottom-5, 45, 20);
    decoratelabel.text = @"倒计时";
    decoratelabel.layer.masksToBounds = YES;
    decoratelabel.layer.cornerRadius = 10;
    decoratelabel.textColor = [UIColor whiteColor];
    decoratelabel.font = [UIFont fontWithName:GlobalTitleFontName size:12];
    decoratelabel.textAlignment = NSTextAlignmentCenter;
    decoratelabel.layer.borderWidth = 1;
    decoratelabel.layer.borderColor = GlobalOrangeColor.CGColor;
    [decoratelabel setBackgroundColor:[UIColor colorWithPatternImage:IMAGENAMED(@"sectionbg")]];
    [self addSubview:decoratelabel];
    
}

- (void)setLeftTime:(NSString*)leftTime
{
    _leftTime = leftTime;
    self.timeLabel.text = leftTime;
}

-(void)setAnimationDuration:(float)animationDuration{
    _animationDuration = animationDuration ;
    lineProgressView.animationDuration = animationDuration;
}

@end
