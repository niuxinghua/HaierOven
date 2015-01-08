//
//  BakeGroupAdviceCell.m
//  HaierOven
//
//  Created by dongl on 15/1/8.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "BakeGroupAdviceCell.h"
@interface BakeGroupAdviceCell()
@property (strong, nonatomic) IBOutlet UIButton *avaterBtn;
@property (strong, nonatomic) IBOutlet UILabel *tagLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *recentCookLabel;
@property (strong, nonatomic) IBOutlet UIButton *followBtn;

@end
@implementation BakeGroupAdviceCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.avaterBtn.layer.masksToBounds = YES;
    self.avaterBtn.layer.cornerRadius = self.avaterBtn.height/2;
    self.avaterBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.avaterBtn.layer.borderWidth = 2.0f;
    self.tagLabel.layer.masksToBounds = YES;
    self.tagLabel.layer.cornerRadius = 3;
    self.followBtn.layer.masksToBounds = YES;
    self.followBtn.layer.cornerRadius = 15;
}
- (IBAction)follow:(UIButton *)sender {
    [self.delegate followed:sender];
}
@end
