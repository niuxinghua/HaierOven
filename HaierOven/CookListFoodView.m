//
//  CookListFoodView.m
//  HaierOven
//
//  Created by dongl on 15/1/5.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "CookListFoodView.h"
@interface CookListFoodView ()
@property (strong, nonatomic) UIImageView *deleteLine;
@property (strong, nonatomic) IBOutlet UIButton *FoodBtn;
@end
@implementation CookListFoodView

-(instancetype)initWithFrame:(CGRect)frame{
    //    if (self = [ super initWithFrame:frame]) {
    self = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([CookListFoodView class]) owner:self options:nil] firstObject];
    self.frame = frame;
    
    //    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.deleteLine = [UIImageView new];
    self.deleteLine.image = IMAGENAMED(@"delete-line.png");
    self.deleteLine.frame = CGRectMake(10, self.FoodBtn.center.y, 0, 1);
    [self addSubview:self.deleteLine];
}

- (IBAction)ChickFoodAdd:(UIButton*)sender {
    if (sender.selected == NO) {
        [UIView animateWithDuration:0.3 animations:^{
            self.deleteLine.frame = CGRectMake(10, self.FoodBtn.center.y, self.FoodBtn.width+10, 1);
        } completion:^(BOOL finished) {
            sender.selected =YES;
        }];
    }else
        sender.selected = NO;
}


-(void)setFoodName:(NSString *)foodName{
    _foodName = foodName;
    [self.FoodBtn setTitle:foodName forState:UIControlStateNormal];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


@end
