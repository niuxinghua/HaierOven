//
//  CommentCountCell.m
//  HaierOven
//
//  Created by 刘康 on 14/12/31.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "CommentCountCell.h"

@interface CommentCountCell ()

@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;


@end

@implementation CommentCountCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCommentCount:(NSInteger)commentCount
{
    _commentCount = commentCount;
    self.commentCountLabel.text = [NSString stringWithFormat:@"%d", commentCount];
}

@end
