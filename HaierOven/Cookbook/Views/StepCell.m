//
//  StepCell.m
//  HaierOven
//
//  Created by 刘康 on 14/12/30.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "StepCell.h"

@interface StepCell ()

@property (weak, nonatomic) IBOutlet UILabel *stepIndexLabel;

@property (weak, nonatomic) IBOutlet UIImageView *stepImageView;

@property (weak, nonatomic) IBOutlet UILabel *stepDescLabel;

@end

@implementation StepCell

- (void)awakeFromNib {
    // Initialization code
    self.stepIndexLabel.layer.masksToBounds = YES;
    self.stepIndexLabel.layer.cornerRadius = self.stepIndexLabel.height / 2;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

- (void)setStep:(Step *)step
{
    _step = step;
    self.stepIndexLabel.text = step.index;
    [self.stepImageView setImageWithURL:[NSURL URLWithString:step.photo] placeholderImage:IMAGENAMED(@"")];
    self.stepDescLabel.text = step.desc;
}

@end
