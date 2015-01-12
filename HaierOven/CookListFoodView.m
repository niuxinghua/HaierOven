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
    
    self = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([CookListFoodView class]) owner:self options:nil] firstObject];
    self.frame = frame;
    
    self.deleteLine = [UIImageView new];
    self.deleteLine.image = IMAGENAMED(@"delete-line.png");
    self.deleteLine.frame = CGRectMake(10, self.FoodBtn.center.y, 0, 1);
    [self addSubview:self.deleteLine];
    
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    if (self.food.isPurchase) { //已购买的话，需要用线条标记，且按钮为被选中的状态
        self.deleteLine.frame = CGRectMake(10, self.FoodBtn.center.y, self.FoodBtn.width/2, 1);
        self.FoodBtn.selected = YES;
    } else {
        self.deleteLine.frame = CGRectMake(10, self.FoodBtn.center.y, 0, 1);
        self.FoodBtn.selected = NO;
    }
    
    
}

- (IBAction)ChickFoodAdd:(UIButton*)sender {
    if (sender.selected == NO) {
        [UIView animateWithDuration:0.3 animations:^{
            self.deleteLine.frame = CGRectMake(10, self.FoodBtn.center.y, self.FoodBtn.width/2, 1);
        } completion:^(BOOL finished) {
            sender.selected =YES;
            self.food.isPurchase = YES;
            [self.delegate purchaseFood:self.food purchased:YES];
        }];
    }else
        [UIView animateWithDuration:0.3 animations:^{
            self.deleteLine.frame = CGRectMake(10, self.FoodBtn.center.y, 0, 1);
        } completion:^(BOOL finished) {
            sender.selected =NO;
            self.food.isPurchase = NO;
            [self.delegate purchaseFood:self.food purchased:NO];
        }];
    
}

- (void)setFood:(PurchaseFood *)food
{
    _food = food;
    [self.FoodBtn setTitle:food.name forState:UIControlStateNormal];
    if (food.isPurchase) { //已购买的话，需要用线条标记，且按钮为被选中的状态
        self.deleteLine.frame = CGRectMake(10, self.FoodBtn.center.y, self.FoodBtn.width/2, 1);
        self.FoodBtn.selected = YES;
    }
    
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    UIBezierPath* path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointMake(0, 1)];
    [path addLineToPoint:CGPointMake(self.width, 1)];
    //    [path addLineToPoint:CGPointMake(self.right, self.bottom - 2)];
    
    path.lineWidth = 1;
    [GlobalGrayColor setStroke];
    [path stroke];
    
    //    [[UIColor blueColor] setFill];
    //    [path fill];
    
    CGContextRestoreGState(context);

}



@end
