//
//  DeleteCookCell.m
//  HaierOven
//
//  Created by dongl on 15/1/7.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "DeleteCookCell.h"

@interface DeleteCookCell ()
@property (strong, nonatomic) IBOutlet UILabel *foodName;
@property (strong, nonatomic) IBOutlet UIButton *isDeleteBtn;


@end
@implementation DeleteCookCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)DeleteFood:(UIButton *)sender {
    sender.selected = sender.selected == NO?YES:NO;
    [self.delegate DeleteFoodCell:self adnDeleteBtn:sender];
}

-(void)setIsAllselected:(BOOL)isAllselected{
    _isAllselected  = isAllselected;
    self.isDeleteBtn.selected = isAllselected;
}
-(void)setCookString:(NSString *)cookString{
    _cookString = cookString;
    self.foodName.text = cookString;
}
@end
