//
//  StudyCookCell.m
//  HaierOven
//
//  Created by dongl on 15/1/20.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "StudyCookCell.h"
#import "StudyCookView.h"
@interface StudyCookCell()
@property (weak, nonatomic) IBOutlet UIButton *bkImageBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end
@implementation StudyCookCell

- (void)awakeFromNib {
    self.bkImageBtn.layer.cornerRadius = 3;
    self.bkImageBtn.layer.masksToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)showDetail:(id)sender {
    self.icon.selected = !self.icon.selected;
    [self.delegate fixedCell:self];
}

-(void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = title;
}

-(void)setBkImage:(UIImage *)bkImage{
    _bkImage = bkImage;
    [self.bkImageBtn setBackgroundImage:bkImage forState:UIControlStateNormal];
    [self.bkImageBtn setBackgroundImage:bkImage forState:UIControlStateHighlighted];
}

-(void)setDetails:(NSArray *)details{
    for (StudyCookView *view in self.bottomView.subviews) {
        [view removeFromSuperview];
    }
    for (int i = 0; i<details.count; i++) {
        StudyCookView *stuView = [[StudyCookView alloc]initWithFrame:CGRectMake(0, i*45+8, self.bottomView.width, 44)];
        stuView.layer.masksToBounds = YES;
        stuView.layer.cornerRadius = 3;
        stuView.title = details[i];
        stuView.tag  = i;
        stuView.delegate = self.delegate;
//        stuView.backgroundColor  = [UIColor blueColor];
        [self.bottomView addSubview:stuView];
    }
}
@end
