//
//  SecDeviceTableViewCell.m
//  HaierOven
//
//  Created by dongl on 14/12/22.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "SecDeviceTableViewCell.h"

@interface SecDeviceTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *infoImageView;

@end

@implementation SecDeviceTableViewCell


- (void)awakeFromNib {
    // Initialization code
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(infoButtonTapped:)];
    [self.infoImageView addGestureRecognizer:tap];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)infoButtonTapped:(UITapGestureRecognizer *)sender
{
    [self.delegate deviceInfoButtonTapped];
}

@end
