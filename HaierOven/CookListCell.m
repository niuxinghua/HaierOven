//
//  CookListCell.m
//  HaierOven
//
//  Created by dongl on 15/1/5.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "CookListCell.h"
#import "CookListFoodView.h"

@implementation CookListCell

#define Food_Height 40
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)TurnDetailCookView:(id)sender {
    [self.delegate turnCookDetailView:self];
}

-(void)setFoods:(NSArray *)foods{
    _foods = foods;
    for (int i = 0; i<foods.count ; i++) {
        CookListFoodView *foodView = [[CookListFoodView alloc]initWithFrame:CGRectMake(0, Food_Height*i+50, PageW, Food_Height)];
        foodView.delegate = self;
        foodView.food = foods[i];
        [self addSubview:foodView];
    }
}

#pragma mark - CookListFoodViewDelegate

- (void)purchaseFood:(PurchaseFood *)food purchased:(BOOL)isPurchase
{
    [self.delegate purchaseFood:food inCell:self isPurchased:isPurchase];
}

-(void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    UIBezierPath* path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(self.width,0)];
    //    [path addLineToPoint:CGPointMake(self.right, self.bottom - 2)];
    path.lineWidth = 1;
    [GlobalGrayColor setStroke];
    [path stroke];
    
        [[UIColor blueColor] setFill];
        [path fill];
    
    UIBezierPath* path2 = [UIBezierPath bezierPath];
    [path appendPath:path2];
    
    
    [path2 moveToPoint:CGPointMake(0, self.height - 1)];
    [path2 addLineToPoint:CGPointMake(self.width,self.height - 1)];
    //    [path addLineToPoint:CGPointMake(self.right, self.bottom - 2)];
    path2.lineWidth = 1;
    [GlobalGrayColor setStroke];
    [path2 stroke];
    
    
    
    CGContextRestoreGState(context);
}
@end
