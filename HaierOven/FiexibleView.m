//
//  FiexibleView.m
//  HaierOven
//
//  Created by dongl on 15/1/13.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "FiexibleView.h"
#define MARGIN_TB      1.0     // 气泡上下外边距
#define MARGIN_LR      1.0     // 气泡左右外边距
#define CORNER         3.0     // 气泡圆角半径

#define PADDING        20.0     // 气泡内边距
@interface FiexibleView();
@property (strong, nonatomic) UIImageView *bkimage;

@end
@implementation FiexibleView

- (void)drawRect:(CGRect)rect {
}


-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([FiexibleView class]) owner:self options:nil]firstObject];
    self.frame = frame;
    self.bkimage = [UIImageView new];
    self.bkimage.image = IMAGENAMED(@"ww");
    [self addSubview:self.bkimage];
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];

}


#define LABEL_H    38   //标签high
-(void)setEquipments:(NSArray *)equipments{
    _equipments = equipments;
    for (int i = 0; i<equipments.count; i++) {
        UILabel *label = [UILabel new];
        label.text = equipments[i];
        label.frame = CGRectMake(0, i*LABEL_H+20, 100, LABEL_H);
        label.textAlignment = NSTextAlignmentCenter;
        label.font= [UIFont fontWithName:GlobalTitleFontName size:15];
        label.textColor = GlobalOrangeColor;
        label.backgroundColor = [UIColor clearColor];
        label.tag = i;
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapLabel:)];
        [label addGestureRecognizer:tap];
        [self addSubview: label];
    }
}

-(void)tapLabel:(UIGestureRecognizer*)tap{
    UILabel *label =(UILabel *)[tap  view];
    [self.delegate tapLabel:label];
}
-(void)setImageFrame:(CGRect)imageFrame{
    _imageFrame = imageFrame;
    self.bkimage.frame = imageFrame;
}
@end
