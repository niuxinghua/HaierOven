//
//  CoverCell.m
//  HaierOven
//
//  Created by dongl on 14/12/29.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "CoverCell.h"

@interface CoverCell ()


@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;





@end

@implementation CoverCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCoverImage:(UIImage *)coverImage
{
    _coverImage = coverImage;
    self.coverImageView.image = coverImage;
}

@end
