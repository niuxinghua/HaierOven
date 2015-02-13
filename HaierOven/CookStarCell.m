//
//  CookStarCell.m
//  HaierOven
//
//  Created by dongl on 15/1/5.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "CookStarCell.h"
@interface CookStarCell()
@property (weak, nonatomic) IBOutlet UIButton *followBtn;

@end
@implementation CookStarCell

- (void)awakeFromNib {
    self.followBtn.layer.masksToBounds = YES;
    self.followBtn.layer.cornerRadius = self.followBtn.height/2;

    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCookerStar:(CookerStar *)cookerStar
{
    _cookerStar = cookerStar;
    
    [self.avaterImageView setImageWithURL:[NSURL URLWithString:cookerStar.avatar] placeholderImage:IMAGENAMED(@"default_avatar.png")];
    
    switch (cookerStar.userLevel) {
        case 1:
            self.vipType.image = IMAGENAMED(@"Vcs.png");
            break;
        case 2:
            self.vipType.image = IMAGENAMED(@"Vcs.png");
            break;
        case 3:
            self.vipType.image = IMAGENAMED(@"Vcs.png");
            break;
            
        default:
            self.vipType.image = IMAGENAMED(@"Vcs.png");
            break;
    }
    
    self.nameLabel.text = cookerStar.userName;
    self.descLabel.text = cookerStar.signature;
    self.foodCountLabel.text = [NSString stringWithFormat:@"%ld个菜谱", (long)cookerStar.cookbookAmount];
    self.followButton.selected = cookerStar.isFollowed;
    
}

- (IBAction)follow:(UIButton *)sender {
    
    [self.delegate cookStarCell:self followButtonTapped:sender];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.avaterImageView.layer.cornerRadius = self.avaterImageView.height/2;
    self.avaterImageView.layer.masksToBounds = YES;
 }
@end
