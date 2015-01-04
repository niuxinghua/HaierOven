//
//  CommentListCell.m
//  众筹
//
//  Created by 刘康 on 14/11/25.
//  Copyright (c) 2014年 origheart. All rights reserved.
//

#import "CommentListCell.h"

@interface CommentListCell () <CommentViewDelegate>

@property (strong, nonatomic)CommentView* commentView;

@end

@implementation CommentListCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    self.commentView = [[CommentView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.commentView];
    self.commentView.delegate = self;

    
//    NSLog(@"initUI, 在Comment中又%d个子comment", self.comment.subComments.count);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setComment:(Comment *)comment
{
    _comment = comment;
    
    [self resetCellContent];
    
    self.commentView.comment = self.comment;
    
    [self.commentView setNeedsLayout];
    
    self.commentView.frame = CGRectMake(0, 0, Main_Screen_Width, [comment getHeight]);
    
//    CGFloat y = self.commentView.bottom;
    
//    for (Comment* subComment in comment.subComments) {
//        
//        CommentView* subCommentView = [[CommentView alloc] initWithFrame:CGRectMake(20, y, Main_Screen_Width - 20, [subComment getHeight])];
//        [self.commentView addSubview:subCommentView];
//        subCommentView.comment = subComment;
//        [subCommentView setNeedsLayout];
//        y = subCommentView.bottom;
//        
//    }
}

- (void)resetCellContent
{
    [self.commentView removeFromSuperview];
    [self initUI];
}

- (void)replyButtonTappedForCommentView:(CommentView *)commentView
{
    NSLog(@"回复---");
    [self.delegete replyTappedForCommentListCell:self];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    UIBezierPath* path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 1)];
    [path addLineToPoint:CGPointMake(self.right, 1)];
    path.lineWidth = 1;
    [[UIColor whiteColor] setStroke];
    [path stroke];
    
    CGContextRestoreGState(context);
    
}

@end
