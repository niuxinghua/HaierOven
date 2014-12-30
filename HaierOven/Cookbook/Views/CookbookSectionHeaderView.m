//
//  CookbookSectionHeaderView.m
//  HaierOven
//
//  Created by 刘康 on 14/12/27.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "CookbookSectionHeaderView.h"

@interface CookbookSectionHeaderView ()
@property (weak, nonatomic) IBOutlet UIButton *foodsButton;
@property (weak, nonatomic) IBOutlet UIButton *methodButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (strong, nonatomic) IBOutlet UIImageView *orangeLine;
@property (nonatomic) CurrentContentType contentType;
@end

@implementation CookbookSectionHeaderView

-(instancetype)initWithFrame:(CGRect)frame andCurrentContentType:(CurrentContentType)type
{
    self = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([CookbookSectionHeaderView class]) owner:self options:nil] firstObject];
    self.frame = frame;
    self.contentType = type;
    self.orangeLine = [UIImageView new];
    self.orangeLine.image = IMAGENAMED(@"orangel.png");
    [self addSubview:self.orangeLine];
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.foodsButton.frame      = CGRectMake(0, 0, self.width / 3, self.height - 10);
    self.methodButton.frame     = CGRectMake(self.foodsButton.right, 0, self.width / 3, self.height - 10);
    self.commentButton.frame    = CGRectMake(self.methodButton.right, 0, self.width / 3, self.height - 10);
    float x = 10;
    switch (self.contentType) {
        case CurrentContentTypeFoods:
            x = self.foodsButton.left + 10;
            break;
        case CurrentContentTypeMethods:
            x = self.methodButton.left + 10;
            break;
        case CurrentContentTypeComment:
            x = self.commentButton.left + 10;
            break;
            
        default:
            break;
    }
    self.orangeLine.frame       = CGRectMake(x, self.height - 8, self.width / 3 - 20, 2);
    
}

- (IBAction)buttonsTapped:(UIButton *)sender
{
    CGRect frame = self.orangeLine.frame;
    frame.origin.x = sender.left + 10;
    switch (sender.tag) {
        case 0:
            self.contentType = CurrentContentTypeFoods;
            break;
        case 1:
            self.contentType = CurrentContentTypeMethods;
            break;
        case 2:
            self.contentType = CurrentContentTypeComment;
            break;
            
        default:
            break;
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.orangeLine.frame = frame;
    }];
    
    // Delegation
    [self.delegate CookbookSectionView:self didTappedWithContentType:self.contentType];
}



@end
