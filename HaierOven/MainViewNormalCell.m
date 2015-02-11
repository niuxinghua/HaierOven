//
//  MainViewNormalCell.m
//  HaierOven
//
//  Created by dongl on 14/12/17.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "MainViewNormalCell.h"
#import "CookbookDetailControllerViewController.h"

@interface MainViewNormalCell ()

@property (strong, nonatomic) UIImage* placeholder;

@end

@implementation MainViewNormalCell

- (void)awakeFromNib {
    self.bottomOrangeView.backgroundColor = [UIColor clearColor];
    self.avater.layer.cornerRadius = self.avater.frame.size.height/2;
    self.avater.layer.masksToBounds = YES;
    self.avater.userInteractionEnabled = YES;
    [self.avater.layer setBorderWidth:1.5]; //边框宽度
    [self.avater.layer setBorderColor:[UIColor whiteColor].CGColor];//边框颜色
    
    self.cookStarImageView.hidden = YES;
    self.placeholder = [MyTool createImageWithColor:RGB(240, 240, 240)];
    
    // 设置文本阴影
    self.goodCountLabel.shadowColor = RGBACOLOR(0, 0, 0, 0.6);
    self.goodCountLabel.shadowOffset = CGSizeMake(1.0, 1.0);
    self.timeLabel.shadowColor = RGBACOLOR(0, 0, 0, 0.6);
    self.timeLabel.shadowOffset = CGSizeMake(1.0, 1.0);
//    self.goodCountLabel.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.goodCountLabel.layer.shadowOffset = CGSizeMake(3.0, 3.0);
    
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
    
    
    
    [self.MainCellFoodBackground setImageWithURL: [NSURL URLWithString:cookbook.coverPhoto]];
//    [self.MainCellFoodBackground setContentMode:UIViewContentModeScaleAspectFill];
    //[self.MainCellFoodBackground setImageWithURL:<#(NSURL *)#>]
    
    // 这里应该判断是否是官方菜谱
    if (cookbook.creator.userLevel != nil) {
        
        if ([cookbook.creator.userLevel isEqualToString:@"1"] || [cookbook.creator.userLevel isEqualToString:@"2"]) {
            self.cookStarImageView.hidden = NO;
            self.AuthorityLabel.hidden = NO;
        } else {
            self.cookStarImageView.hidden = YES;
            self.AuthorityLabel.hidden = YES;
        }
        
        
    } else {
        //假数据
//        if ([cookbook.creator.userName isEqualToString:@"官方厨神"]) {
//            self.cookStarImageView.hidden = NO;
//            self.AuthorityLabel.hidden = NO;
//        } else {
//            self.cookStarImageView.hidden = YES;
//            self.AuthorityLabel.hidden = YES;
//        }
        
    }
    
    
    
    //[self.avater setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:cookbook.creator.avatarPath]];
    
    [self.avater setImageWithURL:[NSURL URLWithString:cookbook.creator.avatarPath]];
    
    self.foodName.text = cookbook.name;
    self.foodMakeFunction.text = cookbook.desc;
    self.cookerName.text = cookbook.creator.userName;
    
    self.timeLabel.text = cookbook.modifiedTime;
    
}

- (void)resetCell
{
    self.chickGoodBtn.selected = NO;
    self.avater.imageView.image = [UIImage imageNamed:@"default_avatar"];
    self.MainCellFoodBackground.image = self.placeholder; //[UIImage imageNamed:@"cookbook_list_item_bg_default"];
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
