//
//  StudyDetailCell.m
//  HaierOven
//
//  Created by dongl on 15/1/20.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "StudyDetailCell.h"
#import "StudyCookImages.h"
@interface StudyDetailCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
//@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
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

-(void)setTools:(StudyCookTools *)tools{
    
    for (UIView* view in self.contentView.subviews) {
        if (view.tag == 99) {
            [view removeFromSuperview];
        }
    }
    _tools  = tools;
    self.titleLabel.text = tools.name;
//    self.descriptionLabel.text = tools.desc;
    
    CGFloat wide = PageW-38;
    CGFloat y = 0;
    
    for (int i = 0; i<self.tools.images.count; i++) {
        UIImageView *imageview = [UIImageView new];
        StudyCookImages *images =self.tools.images[i];
        imageview.image =  IMAGENAMED(images.imageName);
        CGFloat height  =  wide*images.imageRect;
        imageview.contentMode = UIViewContentModeScaleAspectFill;
    
        if (i == 0) {
             imageview.frame = CGRectMake(19, 9+8+[MyUtils getTextSizeWithText:tools.name andTextAttribute:@{NSFontAttributeName:self.titleLabel.font} andTextWidth:PageW-38].height,wide, height );
        }else{
         imageview.frame = CGRectMake(19, y+8,wide, height );
        }
       
//        imageview.frame = CGRectMake(19, self.titleLabel.bottom+y,wide, height );
        
        [self.contentView addSubview:imageview];
        imageview.tag = 99;
//        if (i == self.tools.images.count-1) {
            y = imageview.bottom;
//        }
    }
    

    if (self.tools.images.count ==0) {
        y = self.titleLabel.bottom;
    }
    
    
    UILabel *descLabel = [UILabel new];
    descLabel.tag   = 99;
    descLabel.text = tools.desc;
    descLabel.font = [UIFont fontWithName:GlobalTextFontName size:14];
    descLabel.numberOfLines = 0;
    descLabel.frame = CGRectMake(19, y+8, PageW-38, [MyUtils getTextSizeWithText:descLabel.text andTextAttribute:@{NSFontAttributeName:descLabel.font} andTextWidth:PageW-38].height);
    descLabel.textColor = [UIColor darkGrayColor];
    [self.contentView addSubview:descLabel];
//    self.descriptionLabel.frame = CGRectMake(19, 250, PageW-38, [MyUtils getTextSizeWithText:self.descriptionLabel.text andTextAttribute:@{NSFontAttributeName:self.descriptionLabel.font} andTextWidth:PageW-38].height);

}

@end
