//
//  MenuDraftTableViewCell.m
//  HaierOven
//
//  Created by dongl on 14/12/28.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "MenuDraftTableViewCell.h"

@implementation MenuDraftTableViewCell
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setIsEdit:(BOOL)isEdit{
    _isEdit = isEdit;
    if (isEdit) {
        self.deleteBg.hidden = NO;
        self.deleteBtn.hidden = NO;
    }else{
        self.deleteBg.hidden = YES;
        self.deleteBtn.hidden = YES;
    }
}

- (IBAction)DeleteDraft:(id)sender {
    [self.delegate DeleteDraftMneu:self];
}

-(void)setDeleteBg:(UIImageView *)deleteBg{
    _deleteBg = deleteBg;
    deleteBg.image = [MyTool createImageWithColor:GlobalRedColor];
}

- (void)setCookbook:(Cookbook *)cookbook
{
    _cookbook = cookbook;
    NSURL* imageUrl = [NSURL URLWithString:cookbook.coverPhoto];
    [self.coverImage setImageWithURL:imageUrl placeholderImage:IMAGENAMED(@"fakedataImage.png")];
    self.foodNameLabel.text = cookbook.name;
    self.descriptionLabel.text = cookbook.desc;
}

@end








