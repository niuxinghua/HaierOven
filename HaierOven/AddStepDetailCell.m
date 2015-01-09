//
//  AddStepDetailCell.m
//  HaierOven
//
//  Created by dongl on 14/12/30.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "AddStepDetailCell.h"

@implementation AddStepDetailCell

- (void)awakeFromNib {

    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews{
    [super layoutSubviews];


}


-(void)setStepImage:(UIImageView *)stepImage{
    _stepImage = stepImage;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(AddStepImage)];
    [stepImage addGestureRecognizer:tap];
}

-(void)setStepDescriptionLabel:(UILabel *)stepDescriptionLabel{
    _stepDescriptionLabel = stepDescriptionLabel;
    stepDescriptionLabel.layer.borderColor = GlobalOrangeColor.CGColor;
    stepDescriptionLabel.layer.borderWidth = 1;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(AddDescription)];
    [stepDescriptionLabel addGestureRecognizer:tap];

  }

-(void)setStepIndexLabel:(UILabel *)stepIndexLabel{
    _stepIndexLabel = stepIndexLabel;
    stepIndexLabel.layer.masksToBounds = YES;
    stepIndexLabel.layer.cornerRadius = self.stepIndexLabel.height/2;
}

-(void)setStepIndexString:(NSString *)stepIndexString{
    _stepIndexString = stepIndexString;
    _stepIndexLabel.text = stepIndexString;
}
-(void)setStepDescriptionString:(NSString *)stepDescriptionString{
    _stepDescriptionString = stepDescriptionString;
    self.stepDescriptionLabel.text = stepDescriptionString;
}

-(void)setEditStyle:(EditStyle)editStyle{
    _editStyle = editStyle;
    if (editStyle == EditStyleNone) {
        self.deleteBtn.hidden = YES;
    }else
        self.deleteBtn.hidden = NO;
}

-(void)setStep:(Step *)step{
    _step = step;
    self.stepDescriptionLabel.text =  step.desc;
    
    if (step.photo != nil) {
        NSString* imagePath = [BaseOvenUrl stringByAppendingPathComponent:step.photo];
        [self.stepImage setImageWithURL:[NSURL URLWithString:imagePath]];

    }
//    self.stepImage.image = step.
}

#pragma mark- 点击图片和描述
-(void)AddStepImage
{
    [self.delegate stepDetailCell:self AddStepImage:self.stepImage];

}
-(void)AddDescription{
    [self.delegate stepDetailCell:self AddStepDescription:self.stepDescriptionLabel];

}
- (IBAction)DeleteStep:(UIButton*)sender {
    [self.delegate stepDetailCell:self DeleteStepsAtIndex:sender.tag];
}
@end
