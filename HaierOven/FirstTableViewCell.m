//
//  FirstTableViewCell.m
//  HaierOven
//
//  Created by dongl on 14/12/16.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "FirstTableViewCell.h"

@implementation FirstTableViewCell


- (void)awakeFromNib {
    self.avaterImage.layer.cornerRadius = self.avaterImage.frame.size.height/2;
    self.avaterImage.layer.masksToBounds = YES;
    self.avaterImage.userInteractionEnabled = YES;
    [self.avaterImage.layer setBorderWidth:2]; //边框宽度
    [self.avaterImage.layer setBorderColor:[UIColor whiteColor].CGColor];//边框颜色
    
    self.siginBtn.layer.cornerRadius = 15;
    self.siginBtn.layer.masksToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)Sginin:(UIButton *)sender {
    [self.delegate signIn:sender];
}

- (void)setUser:(User *)user
{
    _user = user;
    [self.avaterImage setImageWithURL:[NSURL URLWithString:user.userAvatar]];
    self.userNameLabel.text = user.nickName == nil ? @"点击登录" : user.userName;
    
    
}

@end







