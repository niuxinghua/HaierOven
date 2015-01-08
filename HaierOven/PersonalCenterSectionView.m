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
#define CellImageRate   0.6
@implementation PersonalCenterSectionView

-(instancetype)initWithFrame:(CGRect)frame{
    //    if (self = [ super initWithFrame:frame]) {
    self = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([PersonalCenterSectionView class]) owner:self options:nil] firstObject];
    self.frame = frame;
    self.sectionType = sectionPersonalCenter;
    
    self.pushedButton.frame = CGRectMake(0, PageW*ScrRate-30/2, PageW/2, 30);
    self.likeButton.frame = CGRectMake(PageW/2, PageW*ScrRate-30/2, PageW/2, 30);
    self.orangeLine = [UIImageView new];
    self.orangeLine.image = IMAGENAMED(@"orangel.png");
    self.orangeLine.frame = CGRectMake(15, PageW*ScrRate-10, self.pushedButton.width-30, 2);
    [self addSubview:self.orangeLine];

    return self;
}



- (IBAction)TurnPushedController:(UIButton *)sender {
        [UIView animateWithDuration:0.2 animations:^{[self.orangeLine setFrame:CGRectMake(15, PageW*ScrRate-10, PageW/2-30, 2)];
        }completion:^(BOOL finished) {
            [self.delegate SectionType:sender.tag];
        }];
    
}

- (IBAction)TurnLikeController:(UIButton *)sender {
    
    [UIView animateWithDuration:0.2 animations:^{[self.orangeLine setFrame:CGRectMake(PageW/2+15, PageW*ScrRate-10, PageW/2-30, 2)];
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
        default:
            break;
    }
}

@end
