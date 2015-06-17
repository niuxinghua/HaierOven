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

@property (weak, nonatomic) IBOutlet UIView *containerView;

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
    
    self.containerView.layer.cornerRadius = 8;
    self.containerView.layer.masksToBounds = YES;
    
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
    //[self resetCell];
    self.MainCellFoodBackground.image = nil;
    
    @try {
        self.AuthorityLabel.hidden = YES;
        self.cookStarImageView.hidden = YES;
        
        self.goodCountLabel.text = cookbook.praises;
        [self.MainCellFoodBackground setImageWithURL:[NSURL URLWithString:cookbook.coverPhoto]];
        // 判断是否是官方菜谱
        if ([cookbook.creator.userLevel isEqualToString:@"1"] || [cookbook.creator.userLevel isEqualToString:@"2"]) {
            self.cookStarImageView.hidden = NO;
        }
        self.AuthorityLabel.hidden = !cookbook.isAuthority; // 只有userLevel为1才显示“官方菜谱”
        
        [self.avater setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:cookbook.creator.avatarPath] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
        
        self.foodName.text = cookbook.name;
        
        if (cookbook.desc.length == 0 || [cookbook.desc isEqualToString:@"(null)"]) {
            self.foodMakeFunction.text = @"";
        } else {
            self.foodMakeFunction.text = cookbook.desc;
        }
        
        self.cookerName.text = cookbook.creator.userName;
        
        self.timeLabel.text = cookbook.modifiedTime;
        
    }
    @catch (NSException *exception) {
        NSLog(@"Show Image Error...");
    }
    @finally {
        
    }
    
    
    
    
}

- (void)resetCell
{
    self.chickGoodBtn.selected = NO;
    self.avater.imageView.image = [UIImage imageNamed:@"default_avatar"];
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
