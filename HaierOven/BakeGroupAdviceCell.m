//
//  BakeGroupAdviceCell.m
//  HaierOven
//
//  Created by dongl on 15/1/8.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "BakeGroupAdviceCell.h"
@interface BakeGroupAdviceCell()
@property (strong, nonatomic) IBOutlet UIButton *avaterBtn;
@property (strong, nonatomic) IBOutlet UILabel *tagLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *recentCookLabel;
@property (strong, nonatomic) IBOutlet UIButton *followBtn;

@end
@implementation BakeGroupAdviceCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCooker:(Cooker *)cooker
{
    _cooker = cooker;
    //[self.avaterBtn setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:cooker.avatar]];
    [self.avaterBtn setImageWithURL:[NSURL URLWithString:cooker.avatar]];
    switch (cooker.userLevel) {
        case 1:
            self.tagLabel.text = @"天子一号";
            break;
        case 2:
            self.tagLabel.text = @"厨神名人";
            break;
        case 3:
            self.tagLabel.text = @"推荐达人";
            break;
            
        default:
            self.tagLabel.text = @"官方厨神";
            break;
    }
    
    self.nameLabel.text = cooker.userName;
    self.titleLabel.text = cooker.signature;
    NSString* cookNames = @"最近做过：";
    for (int loop = 0; loop < self.cooker.cookbooks.count; loop++) {
        Cookbook* cookbook = cooker.cookbooks[loop];
        cookNames = loop == self.cooker.cookbooks.count-1 ? [cookNames stringByAppendingFormat:@"%@", cookbook.name] : [cookNames stringByAppendingFormat:@"%@、", cookbook.name];
    }
    self.recentCookLabel.text = cookNames;
    self.followBtn.selected = cooker.isFollowed;
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.avaterBtn.layer.masksToBounds = YES;
    self.avaterBtn.layer.cornerRadius = self.avaterBtn.height/2;
    self.avaterBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.avaterBtn.layer.borderWidth = 2.0f;
    self.tagLabel.layer.masksToBounds = YES;
    self.tagLabel.layer.cornerRadius = 3;
    self.followBtn.layer.masksToBounds = YES;
    self.followBtn.layer.cornerRadius = self.followBtn.height / 2;
}
- (IBAction)follow:(UIButton *)sender {
    [self.delegate bakeGroupAdviceCell:self followed:sender];
}
@end
