//
//  CommentView.m
//  众筹
//
//  Created by 刘康 on 14/11/27.
//  Copyright (c) 2014年 origheart. All rights reserved.
//

#import "CommentView.h"

const CGFloat kTimeLabelWidth = 150.0;

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
    self.userAvatar.layer.borderWidth = 1;
    self.userAvatar.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [self addSubview:self.userAvatar];
    
    CGRect frame = CGRectMake(self.userAvatar.right + 8, 10, self.width - 8 - kAvatarSize - 8 - 8, 21);
    self.userNameLabel = [[UILabel alloc] initWithFrame:frame];
    self.userNameLabel.font = CommentFont;
    self.userNameLabel.textColor = [UIColor orangeColor];
    [self addSubview:self.userNameLabel];
    
    self.commentLabel = [[AttributedLabel alloc] initWithFrame:CGRectMake(8, self.userAvatar.bottom + 10, self.width - 16, 40)];
    self.commentLabel.linesSpacing = kLineSpacing;
    self.commentLabel.characterSpacing = kCharacterSpacing;
    self.commentLabel.font = CommentFont;
    self.commentLabel.textColor = [UIColor darkGrayColor];
    [self addSubview:self.commentLabel];
    
    self.commentTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, self.commentTimeLabel.bottom + 8, self.width / 2, 21)];
    self.commentTimeLabel.font = CommentFont;
    self.commentTimeLabel.textColor = [UIColor grayColor];
    self.commentTimeLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.commentTimeLabel];
    
    self.replyButton = [DrawedButton buttonWithType:UIButtonTypeCustom];
    self.replyButton.frame = CGRectMake(self.width - kReplyButtonWidth - 16, self.commentTimeLabel.top, kReplyButtonWidth, 21);
    [self.replyButton setTitle:@"回复" forState:UIControlStateNormal];
    [self.replyButton setTitleColor:GlobalRedColor forState:UIControlStateNormal];
    [self.replyButton addTarget:self action:@selector(replyCommentTapped) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.replyButton];
    
    self.backgroundColor = [UIColor clearColor];
    
}

- (void)replyCommentTapped
{
    [self.delegate replyButtonTappedForCommentView:self];
}

#define TimeLabelWidth  80.0;

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
    self.commentLabel.frame = CGRectMake(self.userAvatar.right - 10, self.userAvatar.bottom + 10, self.width - 60, commentHeight);
    
    self.commentTimeLabel.frame = CGRectMake(self.right - 20 - kTimeLabelWidth, self.userNameLabel.top, kTimeLabelWidth, 21);
    self.commentTimeLabel.text = self.comment.modifiedTime;
    
//    if (!self.comment.isSubComment) {
//        self.replyButton.frame = CGRectMake(self.width - kReplyButtonWidth - 30, self.commentTimeLabel.top, kReplyButtonWidth, 21);
//    }
    
    self.backgroundColor = [UIColor clearColor];
    
}



@end
