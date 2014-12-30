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
    
    CGFloat y = self.commentView.bottom;
    
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

#define CELL_MARGIN_TB      4.0     // 气泡上下外边距
#define CELL_MARGIN_LR      4.0     // 气泡左右外边距
#define CELL_CORNER         8.0     // 气泡圆角半径

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    UIBezierPath* path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(CELL_MARGIN_LR, CELL_MARGIN_TB + CELL_CORNER)];
    [path addArcWithCenter:CGPointMake(CELL_MARGIN_LR + CELL_CORNER, CELL_MARGIN_TB + CELL_CORNER)
                    radius:CELL_CORNER
                startAngle:M_PI
                  endAngle:M_PI*3/2
                 clockwise:YES];
    [path addLineToPoint:CGPointMake(self.bounds.size.width - CELL_MARGIN_LR - CELL_CORNER, CELL_MARGIN_TB)];
    [path addArcWithCenter:CGPointMake(self.bounds.size.width - CELL_MARGIN_LR - CELL_CORNER, CELL_MARGIN_TB + CELL_CORNER)
                    radius:CELL_CORNER
                startAngle:M_PI*3/2
                  endAngle:M_PI*2
                 clockwise:YES];
    [path addLineToPoint:CGPointMake(self.bounds.size.width - CELL_MARGIN_LR, self.bounds.size.height - CELL_MARGIN_TB - CELL_CORNER)];
    [path addArcWithCenter:CGPointMake(self.bounds.size.width - CELL_MARGIN_LR - CELL_CORNER, self.bounds.size.height - CELL_MARGIN_TB - CELL_CORNER)
                    radius:CELL_CORNER
                startAngle:0.
                  endAngle:M_PI/2
                 clockwise:YES];
    [path addLineToPoint:CGPointMake(CELL_MARGIN_LR + CELL_CORNER, self.bounds.size.height - CELL_MARGIN_TB)];
    [path addArcWithCenter:CGPointMake(CELL_MARGIN_LR + CELL_CORNER, self.bounds.size.height - CELL_MARGIN_TB - CELL_CORNER)
                    radius:CELL_CORNER
                startAngle:M_PI/2
                  endAngle:M_PI
                 clockwise:YES];
    
    [path closePath];
    
    [[UIColor grayColor] setStroke];
    [path stroke];
    
    CGContextRestoreGState(context);
    
}

@end
