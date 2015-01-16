//
//  SystemNotificationCell.m
//  HaierOven
//
//  Created by dongl on 15/1/15.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "SystemNotificationCell.h"
@interface SystemNotificationCell()
@property (strong, nonatomic) IBOutlet UIButton *nameBtn;
@property (strong, nonatomic) IBOutlet UILabel *descLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@end
@implementation SystemNotificationCell
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setName:(NSString *)name{
    _name = name;
    [self.nameBtn setTitle:name forState:UIControlStateNormal];
    [self.nameBtn setTitle:name forState:UIControlStateHighlighted];
}
-(void)setDesc:(NSString *)desc{
    _desc = desc;
    self.descLabel.text = desc;
}
-(void)setTime:(NSString *)time{
    _time = time;
    self.timeLabel.text = time;
}

- (void)setNotice:(NoticeInfo *)notice
{
    _notice = notice;
    [self.nameBtn setTitle:notice.promoter.userName forState:UIControlStateNormal];
    self.descLabel.text = notice.relatedDesc;
    self.timeLabel.text = notice.createdTime;
    
}

@end












