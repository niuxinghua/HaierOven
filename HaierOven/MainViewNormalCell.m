//
//  MainViewNormalCell.m
//  HaierOven
//
//  Created by dongl on 14/12/17.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "MainViewNormalCell.h"

@implementation MainViewNormalCell

- (void)awakeFromNib {
    self.bottomOrangeView.backgroundColor = [UIColor clearColor];
    self.avater.layer.cornerRadius = self.avater.frame.size.height/2;
    self.avater.layer.masksToBounds = YES;
    self.avater.userInteractionEnabled = YES;
    [self.avater.layer setBorderWidth:1.5]; //边框宽度
    [self.avater.layer setBorderColor:[UIColor whiteColor].CGColor];//边框颜色
    
// Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCookbook:(Cookbook *)cookbook
{
    _cookbook = cookbook;
    [self resetCell];
    
    self.goodCountLabel.text = cookbook.praises;
    
    [self.MainCellFoodBackground setImageWithURL: [NSURL URLWithString:cookbook.coverPhoto] placeholderImage:IMAGENAMED(@"fakedataImage.png")];
    // 这里应该判断是否是官方菜谱
//    [self.AuthorityLabel setImageWithURL:[NSURL URLWithString:cookbook.creator.avatarPath] placeholderImage:IMAGENAMED(@"QQQ.png")];
    [self.avater setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:cookbook.creator.avatarPath] placeholderImage:IMAGENAMED(@"QQQ.png")];
    
    self.foodName.text = cookbook.name;
    self.foodMakeFunction.text = cookbook.desc;
    self.cookerName.text = cookbook.creator.userName;
    
}

- (void)resetCell
{
    self.chickGoodBtn.selected = NO;
}

-(void)setHadVideo:(BOOL)hadVideo{
    _hadVideo = hadVideo;
    self.vedioBtn.hidden = hadVideo;
}
- (IBAction)Like:(UIButton *)sender {
    [self.delegate ChickLikeBtn:self andBtn:sender];
}

- (IBAction)Play:(UIButton *)sender {
    [self.delegate ChickPlayBtn:self];
}
@end
