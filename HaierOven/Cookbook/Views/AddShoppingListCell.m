//
//  AddShoppingListCell.m
//  HaierOven
//
//  Created by 刘康 on 14/12/30.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "AddShoppingListCell.h"

@interface AddShoppingListCell ()

@property (weak, nonatomic) IBOutlet UIButton *addButton;


@end

@implementation AddShoppingListCell

- (void)awakeFromNib {
    self.addButton.layer.masksToBounds = YES;
    self.addButton.layer.cornerRadius = self.addButton.height / 2.0;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundColor = [UIColor clearColor];
    self.backgroundView = nil;
    self.contentView.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)addButonTapped:(UIButton *)sender
{
    [self.delegate AddShoppingListWithCell:self];
}


@end
