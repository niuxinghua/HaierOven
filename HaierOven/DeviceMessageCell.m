//
//  DeviceMessageCell.m
//  HaierOven
//
//  Created by dongl on 14/12/23.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "DeviceMessageCell.h"
#import "MyUtils.h"
@implementation DeviceMessageCell

- (void)awakeFromNib {
    // Initialization code
    
    self.messageLabel = [UILabel new];
    self.messageLabel.numberOfLines = 0;
    self.messageLabel.font = [UIFont fontWithName:GlobalTextFontName size:14];
    [self addSubview:self.messageLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews{
    [super layoutSubviews];
    

}
-(void)setContentLabel:(NSString *)string{
    self.messageLabel=[UILabel new];
    self.messageLabel.text = string;
    self.messageLabel.numberOfLines = 0;
    self.messageLabel.font = [UIFont fontWithName:GlobalTextFontName size:14];
    CGSize size = CGSizeZero;
    size = [MyUtils getTextSizeWithText:string andTextAttribute:@{NSFontAttributeName :self.messageLabel.font} andTextWidth:self.width-80];
    self.messageLabel.frame = CGRectMake(20, self.messageTime.bottom, size.width, size.height);
    [self addSubview:self.messageLabel];
    
}

@end
