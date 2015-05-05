//
//  RelationshipCell.m
//  HaierOven
//
//  Created by dongl on 14/12/22.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "RelationshipCell.h"

@implementation RelationshipCell

- (void)awakeFromNib {
    self.avaterImage.layer.cornerRadius = self.avaterImage.frame.size.height/2;
    self.avaterImage.layer.masksToBounds = YES;
//    self.avaterImage.userInteractionEnabled = YES;
    //    [self.avaterImage.layer setBorderWidth:1]; //边框宽度
//    [self.avaterImage.layer setBorderColor:[UIColor whiteColor].CGColor];//边框颜色
    // Initialization code
    self.watchingBtn.layer.cornerRadius = 15;
    self.watchingBtn.layer.masksToBounds = YES;
    [self.watchingBtn setBackgroundImage:[MyTool createImageWithColor:UIColorFromRGB(0xb5b5b5)] forState:UIControlStateSelected];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUser:(Friend *)user
{
    _user = user;
    [self.avaterImage sd_setImageWithURL:[NSURL URLWithString:user.avatar]];
    
    self.nameLabel.text = user.userName;
    self.descriptionLabel.text = user.signature;
    if (!IsLogin || [self.userId isEqualToString:CurrentUserBaseId]) {
        self.watchingBtn.selected = user.isFollowed;
    } else { //判断我是否关注了此人
        [[InternetManager sharedManager] currentUser:CurrentUserBaseId followedUser:user.userBaseId callBack:^(BOOL success, id obj, NSError *error) {
            if (success) {
                NSInteger status = [obj[@"data"] integerValue];
                if (status == 1) {
                    self.watchingBtn.selected = YES;
                } else {
                    self.watchingBtn.selected = NO;
                }
            }
        }];
    }
    
}


- (IBAction)watchingButtonTapped:(UIButton *)sender
{
    [self.delegate RelationshipCell:self watchingButtonTapped:sender];
}


@end
