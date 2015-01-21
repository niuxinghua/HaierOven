//
//  AboutAppCell.m
//  HaierOven
//
//  Created by dongl on 15/1/20.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "AboutAppCell.h"
@interface AboutAppCell();
@property (weak, nonatomic) IBOutlet UILabel *contentlabel;
@property (weak, nonatomic) IBOutlet UILabel *titlelabel;

@end
@implementation AboutAppCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setTitle:(NSString *)title{
    _title = title;
    self.titlelabel.text = title;
}

-(void)setContent:(NSString *)content{
    _content = content;
    self.contentlabel.text = content;
}
@end
