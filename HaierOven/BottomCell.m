//
//  BottomCell.m
//  HaierOven
//
//  Created by dongl on 14/12/30.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "BottomCell.h"

@implementation BottomCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setSaveDraftBtn:(UIButton *)saveDraftBtn{
    _saveDraftBtn = saveDraftBtn;
    saveDraftBtn.layer.cornerRadius = 10;
    saveDraftBtn.layer.masksToBounds = YES;
}

-(void)setPublicBtn:(UIButton *)publicBtn{
    _publicBtn = publicBtn;
    publicBtn.layer.cornerRadius = 10;
    publicBtn.layer.masksToBounds = YES;
}

-(void)setMyPS_String:(NSString *)myPS_String{
    _myPS_String = myPS_String;
    _myPS_Label.text = myPS_String;
}
@end
