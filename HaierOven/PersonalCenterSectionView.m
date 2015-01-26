//
//  PersonalCenterSectionView.m
//  HaierOven
//
//  Created by dongl on 14/12/19.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "PersonalCenterSectionView.h"
#define AdvRate         0.5
#define ScrRate         0.1388888
#define CellImageRate   0.8
@implementation PersonalCenterSectionView

-(instancetype)initWithFrame:(CGRect)frame{
    //    if (self = [ super initWithFrame:frame]) {
    self = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([PersonalCenterSectionView class]) owner:self options:nil] firstObject];
    self.frame = frame;
    self.sectionType = sectionPersonalCenter;
    
//    self.pushedButton.frame = CGRectMake(0, PageW*ScrRate-30/2, PageW/2, 30);
//    self.likeButton.frame = CGRectMake(PageW/2, PageW*ScrRate-30/2, PageW/2, 30);
    self.orangeLine = [[UIImageView alloc]initWithFrame:CGRectMake(15, self.pushedButton.height-11, self.width/2-30, 2)];
    self.orangeLine.image = IMAGENAMED(@"orangel.png");
//    self.orangeLine.frame = CGRectMake(15, frame.size.height-7, self.width/2-30, 2);
    self.middleLine.hidden = YES;
    [self addSubview:self.orangeLine];
    return self;
}



- (IBAction)TurnPushedController:(UIButton *)sender {
        [UIView animateWithDuration:0.2 animations:^{[self.orangeLine setFrame:CGRectMake(15, self.pushedButton.height-9, self.pushedButton.width-30, 2)];
        }completion:^(BOOL finished) {
            [self.delegate SectionType:sender.tag];
        }];
    
}

- (IBAction)TurnLikeController:(UIButton *)sender {
    
    [UIView animateWithDuration:0.2 animations:^{[self.orangeLine setFrame:CGRectMake(self.likeButton.left+15, self.pushedButton.height-9, self.pushedButton.width-30, 2)];
    }completion:^(BOOL finished) {
        [self.delegate SectionType:sender.tag];
    }];

}

-(void)setSectionType:(SectionType)sectionType{
    _sectionType = sectionType;
    switch (sectionType) {
        case sectionFollow:
            [self.pushedButton setTitle:@"关注" forState:UIControlStateNormal];
            [self.likeButton setTitle:@"推荐" forState:UIControlStateNormal];
            break;
        case sectionPersonalCenter:
            [self.pushedButton setTitle:@"发布的" forState:UIControlStateNormal];
            [self.likeButton setTitle:@"赞过的" forState:UIControlStateNormal];
            break;
        case sectionBakeHouse:
            [self.pushedButton setTitle:@"热门" forState:UIControlStateNormal];
            [self.likeButton setTitle:@"最新" forState:UIControlStateNormal];
            break;
        case sectionNotification:
            [self.pushedButton setTitle:@"设备信息" forState:UIControlStateNormal];
            [self.likeButton setTitle:@"系统通知" forState:UIControlStateNormal];
            self.middleLine.hidden = NO;
            break;
        case sectionRegister:
            [self.pushedButton setTitle:@"邮箱注册" forState:UIControlStateNormal];
            [self.likeButton setTitle:@"手机注册" forState:UIControlStateNormal];
            self.middleLine.hidden = NO;
            break;
        case sectionHowToUse:
            [self.pushedButton setTitle:@"基本操作" forState:UIControlStateNormal];
            [self.likeButton setTitle:@"辅助功能" forState:UIControlStateNormal];
            self.middleLine.hidden = NO;
            break;
        default:
            break;
    }
}

@end
