//
//  AddFoodCell.m
//  HaierOven
//
//  Created by dongl on 14/12/29.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "AddFoodCell.h"

@implementation AddFoodCell

- (void)awakeFromNib {
    // Initialization code
    
    self.foodLabel.textColor = [UIColor blackColor];
    self.foodCountLabel.textColor = [UIColor blackColor];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

-(void)setFoodCountLabel:(UILabel *)foodCountLabel{
    _foodCountLabel = foodCountLabel;
    _foodCountLabel.layer.borderColor = GlobalOrangeColor.CGColor;
    _foodCountLabel.layer.borderWidth = 1.0;
    UITapGestureRecognizer *tapcount = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(import:)];
    _foodCountLabel.tag = 1;
    [_foodCountLabel addGestureRecognizer:tapcount];
}
-(void)setFoodLabel:(UILabel *)foodLabel{
    _foodLabel = foodLabel;
    _foodLabel.layer.borderColor = GlobalOrangeColor.CGColor;
    _foodLabel.layer.borderWidth = 1.0;
    _foodLabel.tag = 2;
    UITapGestureRecognizer *tapfood = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(import:)];
    [_foodLabel addGestureRecognizer:tapfood];
}

- (void)setFood:(Food *)food
{
    _food = food;
    
    self.foodLabel.text = food.name == nil ? @"请输入食材" : food.name;
    self.foodCountLabel.text = food.desc == nil ? @"请输入分量" : food.desc;
    
}

-(void)import:(UITapGestureRecognizer*)tap{
    UILabel *label = (UILabel*)[tap view];
    
    [self.delegate addFoodCell:self setLabelText:label];
}


-(void)setChickDeleteBtn:(BOOL)chickDeleteBtn{
    if (self.chickDeleteBtn) {
        self.delebtn.hidden = NO;
    }else
        self.delebtn.hidden = YES;

}
@end
