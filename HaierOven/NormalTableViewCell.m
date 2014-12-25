//
//  NormalTableViewCell.m
//  HaierOven
//
//  Created by dongl on 14/12/16.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "NormalTableViewCell.h"

@implementation NormalTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        [self.delegate ChangeController:self.cellSelectedView];

    }
    // Configure the view for the selected state
}


- (void)layoutSubviews{
    [super layoutSubviews];
//    self.frame = self.bounds;
    
    CGPoint center = CGPointZero;
    
    center = self.titleImage.center;
    center.y = self.height / 2;
    self.titleImage.center = center;
    
    center = self.titleLabel.center;
    center.y = self.height / 2;
    self.titleLabel.center = center;
    
    
}

#define SelectedColor           ([UIColor colorWithRed:248.0f/255 green:203.0f/255 blue:109.0f/255 alpha:1.0])
#define UnSelectedColor           ([UIColor colorWithRed:239.0f/255 green:152.0f/255 blue:40.0f/255 alpha:1.0])

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    
    if (highlighted) {
        self.backgroundColor = SelectedColor;
    }
    else {
        self.backgroundColor = UnSelectedColor;
    }

}
@end
