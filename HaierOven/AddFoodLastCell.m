//
//  AddFoodLastCell.m
//  HaierOven
//
//  Created by dongl on 14/12/29.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "AddFoodLastCell.h"

@implementation AddFoodLastCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setAddFoodBtn:(UIButton *)addFoodBtn{
    _addFoodBtn = addFoodBtn;
    addFoodBtn.layer.borderColor = GlobalOrangeColor.CGColor;
    addFoodBtn.layer.borderWidth = 1;
}

-(void)layoutSubviews{
    [super layoutSubviews];
}


- (IBAction)addFood:(id)sender {
    [self.delegate addFoodCell];
}
@end
