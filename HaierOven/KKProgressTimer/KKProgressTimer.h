//
//  KKProgressTimer.h
//  KKProgressTimer
//
//  Created by gin0606 on 2013/09/04.

//**********************************************************使用Demo**********************************************************

//#import "ViewController.h"
//#import "KKProgressTimer.h"
//
//@interface ViewController () <KKProgressTimerDelegate>
//
//@property (weak, nonatomic) IBOutlet KKProgressTimer *timerView;
//@property (weak, nonatomic) IBOutlet UILabel *remainLabel;
//
//@property (nonatomic) NSInteger seconds;
//
//@end
//
//@implementation ViewController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    self.seconds = 1 * 60;
//    
//    self.timerView.delegate = self;
//    self.timerView.progressColor = [UIColor redColor];
//    self.timerView.progressBackgroundColor = [UIColor greenColor];
//    self.timerView.circleBackgroundColor = [UIColor blueColor];
//    
//    __block CGFloat i = 0;
//    [self.timerView startWithBlock:^CGFloat{
//        return i++ / self.seconds;
//    }];
//    
//}
//
//
//#pragma mark KKProgressTimerDelegate Method
//
//- (void)didUpdateProgressTimer:(KKProgressTimer *)progressTimer percentage:(CGFloat)percentage {
//    
//    if (percentage >= 1) {
//        [progressTimer stop];
//    }
//    NSInteger remainSeconds = (long)(self.seconds - self.seconds * percentage);
//    self.remainLabel.text = [NSString stringWithFormat:@"%02d:%02d", remainSeconds/60, remainSeconds%60];
//    
//}
//
//- (void)didStopProgressTimer:(KKProgressTimer *)progressTimer percentage:(CGFloat)percentage {
//    NSLog(@"%s %f", __PRETTY_FUNCTION__, percentage);
//}
//
//
//@end

//**********************************************************使用Demo结束**********************************************************


#import <UIKit/UIKit.h>

@protocol KKProgressTimerDelegate;

typedef CGFloat (^KKProgressBlock)();

@interface KKProgressTimer : UIView
@property(nonatomic, weak) id <KKProgressTimerDelegate> delegate;

@property(nonatomic) CGFloat frameWidth;
@property(nonatomic, strong) UIColor *progressColor;
@property(nonatomic, strong) UIColor *progressBackgroundColor;
@property(nonatomic, strong) UIColor *circleBackgroundColor;


- (void)startWithBlock:(KKProgressBlock)block;

- (void)stop;
@end

@protocol KKProgressTimerDelegate <NSObject>
@optional
- (void)willUpdateProgressTimer:(KKProgressTimer *)progressTimer percentage:(CGFloat)percentage;

- (void)didUpdateProgressTimer:(KKProgressTimer *)progressTimer percentage:(CGFloat)percentage;

- (void)didStopProgressTimer:(KKProgressTimer *)progressTimer percentage:(CGFloat)percentage;
@end




