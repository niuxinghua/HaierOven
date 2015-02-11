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
    NSString* desc = @"";
    switch (notice.type) {
        case 1:
            desc = [NSString stringWithFormat:@"赞了我的菜谱%@", notice.relatedDesc];
            break;
        case 2:
            desc = [NSString stringWithFormat:@"评论了我的菜谱%@", notice.relatedDesc];
            break;
        case 3:
            desc = [NSString stringWithFormat:@"回复了我的私信"];
            break;
        case 4:
            desc = [NSString stringWithFormat:@"关注了我"];
            break;
        case 5:
            desc = [NSString stringWithFormat:@"取消关注我"];
            break;
        case 6:
            desc = [NSString stringWithFormat:@"取消赞我的菜谱%@", notice.relatedDesc];
            break;
            
        default:
            break;
    }
    self.descLabel.text = desc;
    self.timeLabel.text = notice.createdTime;
    
}

- (void)setOvenNotification:(NSDictionary *)ovenNotification
{
    _ovenNotification = ovenNotification;
    
    [self.nameBtn setTitle:@"" forState:UIControlStateNormal];
    self.descLabel.text = ovenNotification[@"desc"];
    
    NSString* dateStr = ovenNotification[@"time"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm"];
    NSDate *date = [dateFormatter dateFromString:dateStr];
 
    self.timeLabel.text = [MyTool intervalSinceNow:date];
    
    
}

@end












