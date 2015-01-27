//
//  StudyDetailCell.m
//  HaierOven
//
//  Created by dongl on 15/1/20.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "StudyDetailCell.h"
@interface StudyDetailCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIView *middleImagesView;

@end
@implementation StudyDetailCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setStudy:(StudyCookPartOne *)study{
}

-(void)setTools:(StudyCookTools *)tools{
    
    for (UIView* view in self.contentView.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    
    _tools  = tools;
    self.titleLabel.text = tools.name;
    self.descriptionLabel.text = tools.desc;
    
    CGFloat wide = PageW-38;
    CGFloat height =   wide*self.tools.imageRect;

    for (int i = 0; i<self.tools.images.count; i++) {
        UIImageView *imageview = [UIImageView new];
        imageview.image = IMAGENAMED(self.tools.images[i]);
        
        imageview.frame = CGRectMake(19, 9+8+[MyUtils getTextSizeWithText:self.titleLabel.text andTextAttribute:@{NSFontAttributeName:self.titleLabel.font} andTextWidth:PageW-38].height+(height+8)*i,wide, height );
        [self.contentView addSubview:imageview];
    }

}

@end
