//
//  CommentView.m
//  众筹
//
//  Created by 刘康 on 14/11/27.
//  Copyright (c) 2014年 origheart. All rights reserved.
//

#import "CommentView.h"


@interface CommentView ()

@property (strong, nonatomic) UIImageView* userAvatar;

@property (strong, nonatomic) UILabel* userNameLabel;

@property (strong, nonatomic) AttributedLabel* commentLabel;

@property (strong, nonatomic) UILabel* commentTimeLabel;



@end

@implementation CommentView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    self.userAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, kAvatarSize, kAvatarSize)];
    self.userAvatar.layer.cornerRadius = self.userAvatar.height / 2;
    self.userAvatar.layer.masksToBounds = YES;
    [self addSubview:self.userAvatar];
    
    CGRect frame = CGRectMake(self.userAvatar.right + 8, 10, self.width - 8 - kAvatarSize - 8 - 8, 21);
    self.userNameLabel = [[UILabel alloc] initWithFrame:frame];
    self.userNameLabel.font = [UIFont systemFontOfSize:15];
    self.userNameLabel.textColor = [UIColor orangeColor];
    [self addSubview:self.userNameLabel];
    
    self.commentLabel = [[AttributedLabel alloc] initWithFrame:CGRectMake(8, self.userAvatar.bottom + 10, self.width - 16, 40)];
    self.commentLabel.linesSpacing = kLineSpacing;
    self.commentLabel.characterSpacing = kCharacterSpacing;
    self.commentLabel.font = CommentFont;
    self.commentLabel.textColor = [UIColor darkGrayColor];
    [self addSubview:self.commentLabel];
    
    self.commentTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, self.commentTimeLabel.bottom + 8, self.width / 2, 21)];
    self.commentTimeLabel.font = [UIFont italicSystemFontOfSize:15];
    self.commentTimeLabel.textColor = [UIColor grayColor];
    [self addSubview:self.commentTimeLabel];
    
    self.replyButton = [DrawedButton buttonWithType:UIButtonTypeCustom];
    self.replyButton.frame = CGRectMake(self.width - kReplyButtonWidth - 16, self.commentTimeLabel.top, kReplyButtonWidth, 21);
    [self.replyButton setTitle:@"回复" forState:UIControlStateNormal];
    [self.replyButton setTitleColor:GlobalRedColor forState:UIControlStateNormal];
    [self.replyButton addTarget:self action:@selector(replyCommentTapped) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.replyButton];
    
}

- (void)replyCommentTapped
{
    [self.delegate replyButtonTappedForCommentView:self];
}

/**
 *  当赋值comment对象是调用此方法重新布局以显示内容
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    if (self.comment.isSubComment) {
//        self.replyButton.hidden = YES;
//        CGRect frame = self.frame;
//        frame.origin.x += 20;
//        frame.size.width -= 20;
//        self.frame = frame;
//    }
    NSString* avatarPath = self.comment.creatorAvatar;
    [self.userAvatar setImageWithURL:[NSURL URLWithString:avatarPath] placeholderImage:IMAGENAMED(@"placeholder.png")];
    
    CGPoint center = self.userAvatar.center;
    CGRect frame = CGRectMake(self.userAvatar.right + 10, center.y - 21 / 2, self.width - 10 - kAvatarSize - 10 - 10, 21);
    self.userNameLabel.frame = frame;
    self.userNameLabel.text = self.comment.creatorLoginName;
    
    self.commentLabel.text = self.comment.content;
    CGFloat commentHeight = [self.commentLabel getAttributedStringHeightWidthValue:self.width - 60];
    self.commentLabel.frame = CGRectMake(20, self.userAvatar.bottom + 10, self.width - 60, commentHeight);
    
    self.commentTimeLabel.frame = CGRectMake(20, self.commentLabel.bottom + 10, self.width / 2, 21);
    self.commentTimeLabel.text = self.comment.modifiedTime;
    
//    if (!self.comment.isSubComment) {
//        self.replyButton.frame = CGRectMake(self.width - kReplyButtonWidth - 30, self.commentTimeLabel.top, kReplyButtonWidth, 21);
//    }
    
    self.backgroundColor = [UIColor clearColor];
    
}

#define CELL_MARGIN_TB      8.0     // 气泡上下外边距
#define CELL_MARGIN_LR      8.0     // 气泡左右外边距
#define CELL_CORNER         10.0     // 气泡圆角半径

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    UIBezierPath* path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointMake(CELL_MARGIN_LR, self.bottom - 2)];
    [path addLineToPoint:CGPointMake(self.right - CELL_MARGIN_LR, self.bottom - 2)];
    
//    [path moveToPoint:CGPointMake(CELL_MARGIN_LR, CELL_MARGIN_TB + CELL_CORNER)];
//    [path addArcWithCenter:CGPointMake(CELL_MARGIN_LR + CELL_CORNER, CELL_MARGIN_TB + CELL_CORNER)
//                    radius:CELL_CORNER
//                startAngle:M_PI
//                  endAngle:M_PI*3/2
//                 clockwise:YES];
//    [path addLineToPoint:CGPointMake(self.bounds.size.width - CELL_MARGIN_LR - CELL_CORNER, CELL_MARGIN_TB)];
//    [path addArcWithCenter:CGPointMake(self.bounds.size.width - CELL_MARGIN_LR - CELL_CORNER, CELL_MARGIN_TB + CELL_CORNER)
//                    radius:CELL_CORNER
//                startAngle:M_PI*3/2
//                  endAngle:M_PI*2
//                 clockwise:YES];
//    [path addLineToPoint:CGPointMake(self.bounds.size.width - CELL_MARGIN_LR, self.bounds.size.height - CELL_MARGIN_TB - CELL_CORNER)];
//    [path addArcWithCenter:CGPointMake(self.bounds.size.width - CELL_MARGIN_LR - CELL_CORNER, self.bounds.size.height - CELL_MARGIN_TB - CELL_CORNER)
//                    radius:CELL_CORNER
//                startAngle:0.
//                  endAngle:M_PI/2
//                 clockwise:YES];
//    [path addLineToPoint:CGPointMake(CELL_MARGIN_LR + CELL_CORNER, self.bounds.size.height - CELL_MARGIN_TB)];
//    [path addArcWithCenter:CGPointMake(CELL_MARGIN_LR + CELL_CORNER, self.bounds.size.height - CELL_MARGIN_TB - CELL_CORNER)
//                    radius:CELL_CORNER
//                startAngle:M_PI/2
//                  endAngle:M_PI
//                 clockwise:YES];
    
    [path closePath];
    path.lineWidth = 1;
    [[UIColor grayColor] setStroke];
    [path stroke];
    
    CGContextRestoreGState(context);
    
}


@end
