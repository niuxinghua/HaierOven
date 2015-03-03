
//
//  TimeProgressAlertView.m
//  HaierOven
//
//  Created by dongl on 15/1/21.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "TimeProgressAlertView.h"
#import "KKProgressTimer.h"
@interface TimeProgressAlertView()<KKProgressTimerDelegate>
@property (weak, nonatomic) IBOutlet KKProgressTimer *clockView;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end
@implementation TimeProgressAlertView

-(instancetype)initWithFrame:(CGRect)frame{
    //    if (self = [ super initWithFrame:frame]) {
    self = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([TimeProgressAlertView class]) owner:self options:nil] firstObject];
    self.frame = frame;
    //    self.layer.cornerRadius = 15;
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    self.clockView.delegate = self;
    
    self.clockView.progressColor = GlobalOrangeColor;
    self.clockView.progressBackgroundColor = [UIColor whiteColor];
    self.clockView.circleBackgroundColor = [UIColor clearColor];
    return self;
}



#pragma kkprogressTimerDelegate
- (void)didUpdateProgressTimer:(KKProgressTimer *)progressTimer percentage:(CGFloat)percentage {
    
    if (percentage >= 1) {
        [progressTimer stop];
    }
    NSInteger remainSeconds = (long)(self.seconds - self.seconds * percentage);
    self.label.text = [NSString stringWithFormat:@"%02d:%02d", remainSeconds/60, remainSeconds%60];
    
}

- (void)didStopProgressTimer:(KKProgressTimer *)progressTimer percentage:(CGFloat)percentage {
    [self.delegate TimeOutAlertShow];
}

- (IBAction)CancelClock:(id)sender {
    [self.delegate HiddenClockAlert];
}

- (IBAction)StopClock:(id)sender {
    [self.delegate StopClock];
}

-(void)setStart:(BOOL)start{
    if (start) {
        __block CGFloat i = 0;
        [self.clockView startWithBlock:^CGFloat{
            return i++ / self.seconds;
        }];
    }else{
        [self.clockView stop];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
